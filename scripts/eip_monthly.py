#!/usr/bin/env python3
"""Generate a monthly Ethereum EIP activity report in Markdown.

Clones (or updates) https://github.com/ethereum/EIPs, walks the commits made in
the given month, and writes a Markdown report covering:

  * newly merged EIPs
  * status transitions (Draft -> Review -> Last Call -> Final, ...)
  * inclusion-list changes in hardfork Meta EIPs (Scheduled / Considered /
    Proposed / Declined for Inclusion) and activation table updates
  * the most actively edited EIPs
  * the full commit log

Only the Python standard library and a `git` binary are required.

Usage:
    python3 scripts/eip_monthly.py                    # current month
    python3 scripts/eip_monthly.py --month 2026-09
    python3 scripts/eip_monthly.py --month 2026-09 --out 2026-09/eip-activity.md
"""

from __future__ import annotations

import argparse
import datetime as dt
import re
import subprocess
import sys
from collections import OrderedDict, defaultdict
from dataclasses import dataclass, field
from pathlib import Path

EIPS_REPO = "https://github.com/ethereum/EIPs.git"
EIP_URL = "https://eips.ethereum.org/EIPS/eip-{n}"
COMMIT_URL = "https://github.com/ethereum/EIPs/commit/{sha}"
EIP_PATH_RE = re.compile(r"^EIPS/eip-(\d+)\.md$")
LIST_ITEM_RE = re.compile(r"^\*\s+\[EIP-(\d+)\]\(\./eip-\d+\.md\):\s*(.*)$")
ACTIVATION_ROW_RE = re.compile(r"^\|\s*([^|]+?)\s*\|\s*([^|]*?)\s*\|\s*([^|]*?)\s*\|$")

# Ordered from "closest to mainnet" to "furthest", used for sorting sections.
INCLUSION_SECTIONS = [
    "Scheduled for Inclusion",
    "Considered for Inclusion",
    "Proposed for Inclusion",
    "Declined for Inclusion",
]


# --------------------------------------------------------------------------- #
# git helpers
# --------------------------------------------------------------------------- #


def git(repo: Path, *args: str, check: bool = True) -> str:
    result = subprocess.run(
        ["git", "-C", str(repo), *args],
        capture_output=True,
        text=True,
        check=False,
    )
    if check and result.returncode != 0:
        raise RuntimeError(f"git {' '.join(args)} failed:\n{result.stderr}")
    return result.stdout


def ensure_repo(cache: Path, since: dt.date) -> Path:
    """Clone or refresh ethereum/EIPs with enough history to cover `since`."""
    # Fetch a little extra history so the month-start snapshot is available.
    shallow_since = (since - dt.timedelta(days=31)).isoformat()
    if not (cache / ".git").exists():
        cache.parent.mkdir(parents=True, exist_ok=True)
        print(f"Cloning {EIPS_REPO} into {cache} ...", file=sys.stderr)
        subprocess.run(
            [
                "git", "clone", "--filter=blob:none", "--no-checkout",
                f"--shallow-since={shallow_since}", EIPS_REPO, str(cache),
            ],
            check=True,
        )
    else:
        print(f"Updating {cache} ...", file=sys.stderr)
        git(cache, "fetch", "--quiet", f"--shallow-since={shallow_since}", "origin")
    return cache


def default_branch_ref(repo: Path) -> str:
    out = git(repo, "symbolic-ref", "--quiet", "refs/remotes/origin/HEAD", check=False).strip()
    return out or "origin/master"


def rev_at(repo: Path, ref: str, before: dt.date) -> str | None:
    """Last commit on `ref` strictly before midnight UTC of `before`."""
    out = git(repo, "rev-list", "-1", f"--before={before.isoformat()}T00:00:00Z", ref).strip()
    return out or None


def show_file(repo: Path, rev: str | None, path: str) -> str | None:
    if rev is None:
        return None
    result = subprocess.run(
        ["git", "-C", str(repo), "show", f"{rev}:{path}"],
        capture_output=True,
        text=True,
        check=False,
    )
    return result.stdout if result.returncode == 0 else None


# --------------------------------------------------------------------------- #
# EIP parsing
# --------------------------------------------------------------------------- #


def parse_front_matter(text: str | None) -> dict[str, str]:
    if not text or not text.startswith("---"):
        return {}
    end = text.find("\n---", 3)
    if end == -1:
        return {}
    meta: dict[str, str] = {}
    for line in text[3:end].splitlines():
        if ":" in line:
            key, _, value = line.partition(":")
            meta[key.strip()] = value.strip().strip('"')
    return meta


def parse_inclusion_lists(text: str | None) -> dict[str, dict[int, str]]:
    """Map inclusion section name -> {eip number: listed title}."""
    sections: dict[str, dict[int, str]] = {}
    if not text:
        return sections
    current: str | None = None
    for line in text.splitlines():
        if line.startswith("#"):
            heading = line.lstrip("#").strip()
            current = next((s for s in INCLUSION_SECTIONS if s in heading), None)
            if current:
                sections.setdefault(current, {})
            continue
        if current:
            m = LIST_ITEM_RE.match(line.strip())
            if m:
                sections[current][int(m.group(1))] = m.group(2).strip()
    return sections


def parse_activation(text: str | None) -> dict[str, tuple[str, str]]:
    rows: dict[str, tuple[str, str]] = {}
    if not text or "### Activation" not in text:
        return rows
    block = text.split("### Activation", 1)[1]
    for line in block.splitlines():
        if line.startswith("## "):
            break
        m = ACTIVATION_ROW_RE.match(line.strip())
        if m and not set(m.group(1)) <= {"-", " "} and m.group(1) != "Network Name":
            rows[m.group(1)] = (m.group(2), m.group(3))
    return rows


def is_hardfork_meta(meta: dict[str, str]) -> bool:
    return meta.get("type") == "Meta" and meta.get("title", "").startswith("Hardfork Meta")


# --------------------------------------------------------------------------- #
# Data model
# --------------------------------------------------------------------------- #


@dataclass
class Commit:
    sha: str
    date: str
    subject: str
    files: list[tuple[str, str]]  # (status letter, path)


@dataclass
class EipActivity:
    number: int
    added: bool = False
    commits: list[Commit] = field(default_factory=list)
    before: dict[str, str] = field(default_factory=dict)
    after: dict[str, str] = field(default_factory=dict)

    @property
    def title(self) -> str:
        return self.after.get("title") or self.before.get("title") or "(untitled)"

    @property
    def kind(self) -> str:
        meta = self.after or self.before
        category = meta.get("category")
        return f"{meta.get('type', '?')}" + (f" / {category}" if category else "")

    @property
    def status_change(self) -> tuple[str, str] | None:
        old, new = self.before.get("status"), self.after.get("status")
        if old and new and old != new:
            return old, new
        return None


def collect_commits(repo: Path, ref: str, start: dt.date, end: dt.date) -> list[Commit]:
    log = git(
        repo, "log", ref, "--no-merges", "--name-status",
        f"--since={start.isoformat()}T00:00:00Z",
        f"--until={end.isoformat()}T00:00:00Z",
        "--format=\x1e%H\x1f%cs\x1f%s",
    )
    commits: list[Commit] = []
    for chunk in log.split("\x1e")[1:]:
        header, *body = chunk.strip("\n").split("\n")
        sha, date, subject = header.split("\x1f", 2)
        files = []
        for line in body:
            parts = line.split("\t")
            if len(parts) >= 2:
                files.append((parts[0][0], parts[-1]))
        commits.append(Commit(sha, date, subject, files))
    commits.reverse()  # chronological
    return commits


def build_activity(repo: Path, commits: list[Commit], rev_before: str | None,
                   rev_after: str) -> "OrderedDict[int, EipActivity]":
    activity: dict[int, EipActivity] = {}
    for commit in commits:
        for status, path in commit.files:
            m = EIP_PATH_RE.match(path)
            if not m:
                continue
            number = int(m.group(1))
            entry = activity.setdefault(number, EipActivity(number))
            if not entry.commits or entry.commits[-1] is not commit:
                entry.commits.append(commit)
            if status == "A":
                entry.added = True
    for number, entry in activity.items():
        path = f"EIPS/eip-{number}.md"
        entry.before = parse_front_matter(show_file(repo, rev_before, path))
        entry.after = parse_front_matter(show_file(repo, rev_after, path))
        if not entry.before:
            entry.added = True
    return OrderedDict(sorted(activity.items()))


# --------------------------------------------------------------------------- #
# Markdown rendering
# --------------------------------------------------------------------------- #


def eip_link(number: int) -> str:
    return f"[EIP-{number}]({EIP_URL.format(n=number)})"


def md_escape(text: str) -> str:
    # Relative links like [ERC-20](./eip-20.md) break outside the EIPs repo.
    text = re.sub(r"\[([^\]]+)\]\(\./[^)]*\)", r"\1", text)
    return text.replace("|", "\\|")


def render_hardfork_changes(repo: Path, activity: "OrderedDict[int, EipActivity]",
                            rev_before: str | None, rev_after: str,
                            titles: dict[int, str]) -> list[str]:
    lines: list[str] = []
    for number, entry in activity.items():
        if not is_hardfork_meta(entry.after):
            continue
        path = f"EIPS/eip-{number}.md"
        old_text, new_text = show_file(repo, rev_before, path), show_file(repo, rev_after, path)
        old_lists, new_lists = parse_inclusion_lists(old_text), parse_inclusion_lists(new_text)

        def where(lists: dict[str, dict[int, str]]) -> dict[int, str]:
            return {n: sec for sec, items in lists.items() for n in items}

        old_where, new_where = where(old_lists), where(new_lists)
        for items in new_lists.values():
            titles.update(items)
        moves = []
        for n in sorted(set(old_where) | set(new_where)):
            a, b = old_where.get(n), new_where.get(n)
            if a != b:
                moves.append((n, a or "—", b or "（削除）"))

        old_act, new_act = parse_activation(old_text), parse_activation(new_text)
        act_changes = [
            (net, new_act[net]) for net in new_act
            if new_act[net] != old_act.get(net) and any(new_act[net])
        ]

        if not moves and not act_changes:
            continue
        lines.append(f"### {eip_link(number)}: {entry.title}\n")
        if act_changes:
            lines.append("**アクティベーション日程の更新**\n")
            lines.append("| ネットワーク | Epoch | Timestamp |")
            lines.append("| --- | --- | --- |")
            for net, (epoch, ts) in act_changes:
                lines.append(f"| {net} | {epoch} | {ts} |")
            lines.append("")
        if moves:
            order = {s: i for i, s in enumerate(INCLUSION_SECTIONS)}
            moves.sort(key=lambda m: (order.get(m[2], 99), m[0]))
            lines.append("**インクルージョン状態の変化（月初 → 月末）**\n")
            lines.append("| EIP | タイトル | 月初 | 月末 |")
            lines.append("| --- | --- | --- | --- |")
            for n, a, b in moves:
                title = md_escape(titles.get(n, ""))
                lines.append(f"| {eip_link(n)} | {title} | {a} | {b} |")
            lines.append("")
    return lines


def render(month: str, repo: Path, commits: list[Commit],
           activity: "OrderedDict[int, EipActivity]",
           rev_before: str | None, rev_after: str) -> str:
    titles = {n: e.title for n, e in activity.items()}
    added = [e for e in activity.values() if e.added]
    status_changes = [e for e in activity.values() if e.status_change and not e.added]
    busiest = sorted(activity.values(), key=lambda e: (-len(e.commits), e.number))

    out: list[str] = []
    out.append(f"# EIP アクティビティレポート {month}\n")
    out.append(
        f"> `scripts/eip_monthly.py` により [ethereum/EIPs]({EIPS_REPO[:-4]}) の "
        f"コミット履歴から自動生成（対象: {month}、基準コミット "
        f"[`{rev_after[:7]}`]({COMMIT_URL.format(sha=rev_after)})）。\n"
    )

    out.append("## サマリー\n")
    out.append("| 指標 | 件数 |")
    out.append("| --- | --- |")
    out.append(f"| コミット数 | {len(commits)} |")
    out.append(f"| 変更のあった EIP | {len(activity)} |")
    out.append(f"| 新規マージされた EIP | {len(added)} |")
    out.append(f"| ステータス変更 | {len(status_changes)} |")
    out.append("")

    out.append("## 新規 EIP\n")
    if added:
        out.append("| EIP | タイトル | 種別 | ステータス | 概要 |")
        out.append("| --- | --- | --- | --- | --- |")
        for e in added:
            out.append(
                f"| {eip_link(e.number)} | {md_escape(e.title)} | {e.kind} | "
                f"{e.after.get('status', '?')} | {md_escape(e.after.get('description', ''))} |"
            )
    else:
        out.append("_なし_")
    out.append("")

    out.append("## ステータス変更\n")
    if status_changes:
        out.append("| EIP | タイトル | 変更 |")
        out.append("| --- | --- | --- |")
        for e in status_changes:
            old, new = e.status_change
            out.append(f"| {eip_link(e.number)} | {md_escape(e.title)} | {old} → **{new}** |")
    else:
        out.append("_なし_")
    out.append("")

    hardfork = render_hardfork_changes(repo, activity, rev_before, rev_after, titles)
    out.append("## ハードフォーク Meta EIP の動き\n")
    out.extend(hardfork or ["_なし_", ""])

    out.append("## 更新が活発だった EIP\n")
    out.append("| EIP | タイトル | 種別 | ステータス | コミット数 |")
    out.append("| --- | --- | --- | --- | --- |")
    for e in busiest:
        out.append(
            f"| {eip_link(e.number)} | {md_escape(e.title)} | {e.kind} | "
            f"{e.after.get('status', '?')} | {len(e.commits)} |"
        )
    out.append("")

    out.append("## コミットログ\n")
    for c in commits:
        out.append(f"- {c.date} [`{c.sha[:7]}`]({COMMIT_URL.format(sha=c.sha)}) {c.subject}")
    out.append("")
    return "\n".join(out)


# --------------------------------------------------------------------------- #
# CLI
# --------------------------------------------------------------------------- #


def month_bounds(month: str) -> tuple[dt.date, dt.date]:
    start = dt.datetime.strptime(month, "%Y-%m").date()
    end = (start.replace(day=28) + dt.timedelta(days=4)).replace(day=1)
    return start, end


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--month", default=dt.date.today().strftime("%Y-%m"),
                        help="target month in YYYY-MM (default: current month)")
    parser.add_argument("--repo", type=Path, default=Path(".cache/EIPs"),
                        help="local clone of ethereum/EIPs (created if missing)")
    parser.add_argument("--no-fetch", action="store_true",
                        help="use --repo as is without cloning/fetching")
    parser.add_argument("--out", type=Path,
                        help="output file (default: <month>/eip-activity.md)")
    args = parser.parse_args(argv)

    start, end = month_bounds(args.month)
    repo = args.repo if args.no_fetch else ensure_repo(args.repo, start)
    ref = default_branch_ref(repo)

    rev_after = rev_at(repo, ref, end)
    if rev_after is None:
        print("No commits found for the requested period.", file=sys.stderr)
        return 1
    rev_before = rev_at(repo, ref, start)

    commits = collect_commits(repo, ref, start, end)
    activity = build_activity(repo, commits, rev_before, rev_after)
    report = render(args.month, repo, commits, activity, rev_before, rev_after)

    out = args.out or Path(args.month) / "eip-activity.md"
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(report, encoding="utf-8")
    print(f"Wrote {out} ({len(commits)} commits, {len(activity)} EIPs)", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
