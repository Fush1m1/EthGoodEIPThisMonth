# EthGoodEIPThisMonth

イーサリアムの EIP（Ethereum Improvement Proposals）の動きを月ごとにまとめるリポジトリ。

## 月次レポート

| 月 | まとめ | Solidity |
| --- | --- | --- |
| 2026-09 | [eip-activity.md](./2026-09/eip-activity.md) | [contracts](./2026-09/contracts) |

## Solidity サンプル

各月のフォルダの `contracts/` に、その月の EIP に対応した Solidity 実装を置いています（Foundry プロジェクト）。

```bash
git submodule update --init
cd 2026-09/contracts
forge test
```
