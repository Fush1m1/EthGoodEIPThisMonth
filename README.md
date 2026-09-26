# EthGoodEIPThisMonth

イーサリアムの EIP（Ethereum Improvement Proposals）の動きを月ごとにまとめるリポジトリ。

## 月次レポート

| 月 | まとめ | 自動集計 |
| --- | --- | --- |
| 2026-09 | [2026-09/README.md](./2026-09/README.md) | [2026-09/eip-activity.md](./2026-09/eip-activity.md) |

## レポート生成

`scripts/eip_monthly.py` は [ethereum/EIPs](https://github.com/ethereum/EIPs) を `.cache/EIPs` に clone し、指定月のコミットから以下を Markdown に出力します（Python 3.10+ と git のみ必要）。

- 新規マージされた EIP
- ステータス変更（Draft → Review → Last Call → Final など）
- ハードフォーク Meta EIP のインクルージョン状態（SFI / CFI / PFI / DFI）の変化とアクティベーション日程
- 更新が活発だった EIP とコミットログ

```bash
python3 scripts/eip_monthly.py                     # 今月
python3 scripts/eip_monthly.py --month 2026-09     # 指定月 → 2026-09/eip-activity.md
python3 scripts/eip_monthly.py --month 2026-09 --out path/to/report.md
```
