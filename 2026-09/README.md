# 2026年9月 イーサリアム主要 EIP まとめ

対象期間: 2026-09-01 〜 2026-09-26（[ethereum/EIPs](https://github.com/ethereum/EIPs) の master）
コミット履歴の集計データ → [`eip-activity.md`](./eip-activity.md)
Solidity サンプル → [`contracts/`](./contracts)

## TL;DR

- **Glamsterdam の Sepolia アクティベーション日程が決定** — 2026-10-06 13:53:36 UTC（epoch 353024）。いよいよテストネット展開フェーズへ。
- **次の次のフォーク Hegotá のスコープが大きく整理された** — ACDE245/246・ACDC187 の判断で 11 件が CFI（Considered for Inclusion）に昇格、18 件が DFI（Declined）に。Frame Transaction（EIP-8141）周辺の EIP が CFI に固まりつつある。
- **ポスト量子（PQ）関連の提案が相次いで登場** — ML-DSA 検証プリコンパイル（EIP-8355）、PQ 署名/STARK のメンプール集約（EIP-8288）、BLS(0x00) 引き出し認証の段階的廃止（EIP-8365）。
- **EIP-8246（SELFDESTRUCT による ETH バーンの廃止）が Last Call 入り**（締切 2026-11-04）。

| 指標 | 件数 |
| --- | --- |
| コミット数 | 65 |
| 変更のあった EIP | 29 |
| 新規マージされた EIP | 7 |
| ステータス変更 | 2 |

---

## 1. ハードフォーク動向

### Glamsterdam（[EIP-7773](https://eips.ethereum.org/EIPS/eip-7773)）

| ネットワーク | Epoch | Timestamp |
| --- | --- | --- |
| Sepolia | 353024 | 2026-10-06 13:53:36 UTC |
| Hoodi | 未定 | 未定 |
| Mainnet | 未定 | 未定 |

- テストネット表から Holešky が外れ、Hoodi に置き換わった。
- 採用 EIP のタイトル表記が各 EIP と揃えられた（EIP-2780「Resource-based intrinsic transaction gas」、EIP-7997「Deterministic Factory Contract」、EIP-8038「State-access gas cost update」）。
- 採用済み EIP のうち、ガス再設計の中核である **EIP-8037（State Creation Gas Cost Increase）** は今月最多の 8 コミット。フレーム巻き戻し時の state-gas 返却、子フレームのマージ時の扱い、トランザクションの gas limit 上限を 2^32-1 にする変更など、実装に向けた細部の詰めが続いた。**EIP-8038（State-access gas cost update）**、**EIP-7928（Block-Level Access Lists）**、**EIP-2780** も細かな修正あり。

### Hegotá（[EIP-8081](https://eips.ethereum.org/EIPS/eip-8081)）

SFI（Scheduled for Inclusion）は引き続き **FOCIL（EIP-7805）** と **Frame Transaction（EIP-8141）** の 2 本柱。今月の判断は以下のとおり。

**CFI に昇格（Proposed → Considered）**

| EIP | 内容 |
| --- | --- |
| [EIP-3298](https://eips.ethereum.org/EIPS/eip-3298) | ストレージクリア時のリファンドとリファンド上限の廃止 |
| [EIP-7668](https://eips.ethereum.org/EIPS/eip-7668) | ブルームフィルタの廃止 |
| [EIP-7906](https://eips.ethereum.org/EIPS/eip-7906) | State diff を読むオペコードによるトランザクションアサーション |
| [EIP-7979](https://eips.ethereum.org/EIPS/eip-7979) | EVM の Call / Return オペコード |
| [EIP-8015](https://eips.ethereum.org/EIPS/eip-8015) | `deposit` / `eth1data` フィールドの削除（CL） |
| [EIP-8131](https://eips.ethereum.org/EIPS/eip-8131) | トランザクション内容のフロア料金の統一 |
| [EIP-8163](https://eips.ethereum.org/EIPS/eip-8163) | `EXTENSION (0xae)` オペコードの予約 |
| [EIP-8250](https://eips.ethereum.org/EIPS/eip-8250) | Frame Transaction 向け Keyed Nonce |
| [EIP-8253](https://eips.ethereum.org/EIPS/eip-8253) | nonce 0 のストレージ付きアカウントの nonce を加算 |
| [EIP-8272](https://eips.ethereum.org/EIPS/eip-8272) | Frame Transaction 向け Recent Roots |
| [EIP-8279](https://eips.ethereum.org/EIPS/eip-8279) | Block Access List のバイトフロア |

**新たに PFI（Proposed for Inclusion）に追加**: EIP-8142（Block-in-Blobs）、8198（Quick Slots）、8355（ML-DSA プリコンパイル）、8365（BLS 引き出し認証の廃止）、8369（FOCIL 向け VOPS プロファイル）、8371（RowDAS）、8379（Top-up Sync）、8383（CL ブロック保持期間の短縮）

**DFI（Declined）**: EIP-2488（CALLCODE 非推奨化）、7645（ORIGIN を SENDER にエイリアス）、7807（SSZ 実行ブロック）、7819（SETDELEGATE）、7851、7862（Delayed State Root）、7923、8094、8115、8146（BAL サイドカー）、8182（プライベート ETH/ERC-20 送金）、8188、8200（EVMification）、8219（Checked Arithmetic）、8237、8243、8304、8321（Hash-Chain RANDAO）

> 読みどころ: CFI 入りした 7906 / 8250 / 8272 はいずれも EIP-8141 の Frame Transaction を前提にした拡張で、Hegotá が「アカウント抽象化 + 検閲耐性（FOCIL）」フォークとして輪郭を持ち始めている。一方、SSZ 実行ブロックや Delayed State Root のような大型構造変更は見送られた。

---

## 2. 新規 EIP ピックアップ

### ポスト量子への布石

- **[EIP-8355](https://eips.ethereum.org/EIPS/eip-8355) Precompiles for ML-DSA Verification**
  NIST FIPS 204 の格子署名 ML-DSA（44/65/87 の 3 パラメータ）を検証するプリコンパイル 3 種。入力は `pubkey ++ signature ++ message` の単純連結で、長さプレフィックス不要。Hegotá の PFI 入り。
- **[EIP-8288](https://eips.ethereum.org/EIPS/eip-8288) In-mempool signature and proof aggregation**
  EIP-8141 に新しいフレームモードを追加し、PQ 署名や STARK 証明をメンプール内で再帰 STARK に集約する。PQ 署名のサイズ問題への回答として注目。
- **[EIP-8365](https://eips.ethereum.org/EIPS/eip-8365) BLS withdrawal credential retirement**
  `0x00`（BLS）引き出し認証を持つバリデータを自動 exit させ、新規作成も停止。`BLSToExecutionChange` は残すので資金は回収可能。PQ 移行に向けた段階的廃止の第 1 段階。

### EVM / 実行レイヤー

- **[EIP-8360](https://eips.ethereum.org/EIPS/eip-8360) TCREATE Opcode**
  1 トランザクションの間だけ存在する「一時コントラクト」を作る新オペコード。使い捨てコントラクトによる state 肥大化を避ける狙いで、EIP-8037/8038 のガス再設計と対になる。

### 同期・ネットワーク

- **[EIP-8379](https://eips.ethereum.org/EIPS/eip-8379) Top-up Sync**
  Engine API に EL ヘッド取得メソッドを追加し、「state が無い」と「履歴が無い」を区別。CL 主導で `newPayload` / `forkchoiceUpdated` だけで EL を同期させる。
- **[EIP-8383](https://eips.ethereum.org/EIPS/eip-8383) Reduce CL Block Retention Window**
  CL のブロック保持義務を 33,024 epoch（約 5 か月）から 8,192 epoch（約 36 日）に短縮し、ノード運用コストを削減。

### FOCIL 周辺

- **[EIP-8369](https://eips.ethereum.org/EIPS/eip-8369) VOPS Profiles for FOCIL Eligibility**（Informational）
  部分ステートレスノードでも FOCIL の包含強制を判定できるよう、対象トランザクションを 2 つのプロファイル（従来型 tx / Frame tx）に整理。

---

## 3. ステータス変更

| EIP | 変更 | コメント |
| --- | --- | --- |
| [EIP-8246](https://eips.ethereum.org/EIPS/eip-8246) Remove SELFDESTRUCT Burn | Review → **Last Call** | SELFDESTRUCT 時に残高を焼かずに保持する。Last Call 締切 2026-11-04。Glamsterdam 採用済み |
| [EIP-7784](https://eips.ethereum.org/EIPS/eip-7784) GETCONTRACT opcode | Stagnant → **Review** | コードハッシュからそのバイトコードを持つアドレスを返すオペコード。復活 |

---

## 4. その他の注目アップデート

- **[EIP-7906](https://eips.ethereum.org/EIPS/eip-7906)** — `TXTRACE` / `TXDIFF` / `EVENTDATACOPY` の 3 オペコードと `POST_TX` フレームに整理。ウォレットが「このトランザクションの結果が X でなければ取り消す」というアサーションを付けられ、ブラインド署名対策になる。Hegotá CFI 入り。
- **[EIP-8130](https://eips.ethereum.org/EIPS/eip-8130)** — 「Keystore Accounts」に改名。オンチェーンの keystore と新 tx タイプによる AA 案。
- **[EIP-8250](https://eips.ethereum.org/EIPS/eip-8250) / [EIP-8272](https://eips.ethereum.org/EIPS/eip-8272)** — Keyed Nonce の初回利用を state gas として課金、Recent Roots を canonical frame で検証するなど、プライバシー系 tx を見据えた仕様詰め。
- **[EIP-8297](https://eips.ethereum.org/EIPS/eip-8297) / [EIP-8347](https://eips.ethereum.org/EIPS/eip-8347)** — Partitioned Binary Tree（PBT）への state tree 移行と、そのオフライン移行手順の更新。
- **[EIP-1](https://eips.ethereum.org/EIPS/eip-1)** — Unicode Technical Standards（UTS）へのリンクを許可。

---

## 5. Solidity サンプル（[`contracts/`](./contracts)）

今月の EIP のうち、コントラクト開発者に直接影響するものを Solidity で実装した。
Foundry プロジェクトで、forge-std などの外部依存はない。

| ファイル | 対応 EIP | 内容 |
| --- | --- | --- |
| [`src/eip8355/MLDSA.sol`](./contracts/src/eip8355/MLDSA.sol) | EIP-8355 | ML-DSA 検証プリコンパイル（0x12〜0x14）の呼び出しライブラリ。長さチェック、ガス見積もり、プリコンパイル導入済みかの判定つき |
| [`src/eip8355/MLDSAAccount.sol`](./contracts/src/eip8355/MLDSAAccount.sol) | EIP-8355 | ML-DSA 鍵で操作するポスト量子スマートアカウント（nonce・chainid 付きでリプレイ防止、鍵ローテーション対応） |
| [`src/eip8246/SelfDestructBurn.sol`](./contracts/src/eip8246/SelfDestructBurn.sol) | EIP-8246 | `SelfBurner`: SELFDESTRUCT で ETH を焼却する従来のパターン（OP Stack の `burn()` 相当）<br>`BurnProbe`: EIP-8246 が有効なチェーンかをオンチェーンで判定<br>`SupplyBurner`: EIP-8246 後の移行例（dead アドレスへ送金） |

```bash
cd 2026-09/contracts
forge test
```

- EIP-8355 のテストでは、プリコンパイルのアドレスに入出力形式だけ合わせたモックを `vm.etch` で配置している（ML-DSA の暗号処理そのものは検証しない）。
- EIP-8246 のテストは現行 EVM（EIP-8246 未導入）での挙動を確認するもの。EIP-8246 が入った EVM では焼却されずに残高が残るため、結果が逆になる。
- EIP-7906（TXTRACE/TXDIFF）、EIP-8360（TCREATE）、EIP-7784（GETCONTRACT）は新しいオペコードで solc がまだ対応していないため、サンプルには含めていない。
