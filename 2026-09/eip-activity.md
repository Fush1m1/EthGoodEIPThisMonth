# EIP アクティビティレポート 2026-09

> [ethereum/EIPs](https://github.com/ethereum/EIPs) のコミット履歴から集計（対象: 2026-09、基準コミット [`0b8184b`](https://github.com/ethereum/EIPs/commit/0b8184b1d6ed9fba836222684fd082b32782d4ef)）。

## サマリー

| 指標 | 件数 |
| --- | --- |
| コミット数 | 65 |
| 変更のあった EIP | 29 |
| 新規マージされた EIP | 7 |
| ステータス変更 | 2 |

## 新規 EIP

| EIP | タイトル | 種別 | ステータス | 概要 |
| --- | --- | --- | --- | --- |
| [EIP-8288](https://eips.ethereum.org/EIPS/eip-8288) | In-mempool signature and proof aggregation | Standards Track / Core | Draft | Adds recursive STARK-based aggregation for quantum-resistant signatures and STARKs via an EIP-8141 frame mode |
| [EIP-8355](https://eips.ethereum.org/EIPS/eip-8355) | Precompiles for ML-DSA Verification | Standards Track / Core | Draft | Three precompiles verifying ML-DSA signatures from a concatenated public key, signature, and trailing message |
| [EIP-8360](https://eips.ethereum.org/EIPS/eip-8360) | TCREATE Opcode | Standards Track / Core | Draft | Introduce a new opcode for creating contracts that exist only for the duration of a single transaction |
| [EIP-8365](https://eips.ethereum.org/EIPS/eip-8365) | BLS withdrawal credential retirement | Standards Track / Core | Draft | Exit validators with 0x00 withdrawal credentials and stop creating new ones, keeping the credential change path open |
| [EIP-8369](https://eips.ethereum.org/EIPS/eip-8369) | VOPS Profiles for FOCIL Eligibility | Informational | Draft | Describes VOPS profiles that a future FOCIL extension could use to determine which transactions receive inclusion enforcement. |
| [EIP-8379](https://eips.ethereum.org/EIPS/eip-8379) | Top-up Sync | Standards Track / Core | Draft | CL-driven EL synchronization by exposing the execution client head and distinguishing missing state from missing history in the engine API |
| [EIP-8383](https://eips.ethereum.org/EIPS/eip-8383) | Reduce CL Block Retention Window | Standards Track / Networking | Draft | Reduces the required beacon block retention window to 8192 epochs |

## ステータス変更

| EIP | タイトル | 変更 |
| --- | --- | --- |
| [EIP-7784](https://eips.ethereum.org/EIPS/eip-7784) | GETCONTRACT opcode | Stagnant → **Review** |
| [EIP-8246](https://eips.ethereum.org/EIPS/eip-8246) | Remove SELFDESTRUCT Burn | Review → **Last Call** |

## ハードフォーク Meta EIP の動き

### [EIP-7773](https://eips.ethereum.org/EIPS/eip-7773): Hardfork Meta - Glamsterdam

**アクティベーション日程の更新**

| ネットワーク | Epoch | Timestamp |
| --- | --- | --- |
| Sepolia | 353024 | 1791294816 (2026-10-06 13:53:36 UTC) |

### [EIP-8081](https://eips.ethereum.org/EIPS/eip-8081): Hardfork Meta - Hegotá

**インクルージョン状態の変化（月初 → 月末）**

| EIP | タイトル | 月初 | 月末 |
| --- | --- | --- | --- |
| [EIP-3298](https://eips.ethereum.org/EIPS/eip-3298) | Remove storage-clear refund and refund cap | Proposed for Inclusion | Considered for Inclusion |
| [EIP-7668](https://eips.ethereum.org/EIPS/eip-7668) | Remove bloom filters | Proposed for Inclusion | Considered for Inclusion |
| [EIP-7906](https://eips.ethereum.org/EIPS/eip-7906) | Transaction Assertions via State Diff Opcode | Proposed for Inclusion | Considered for Inclusion |
| [EIP-7979](https://eips.ethereum.org/EIPS/eip-7979) | Call and Return Opcodes for the EVM | Proposed for Inclusion | Considered for Inclusion |
| [EIP-8015](https://eips.ethereum.org/EIPS/eip-8015) | Remove `deposit` and `eth1data` fields | Proposed for Inclusion | Considered for Inclusion |
| [EIP-8131](https://eips.ethereum.org/EIPS/eip-8131) | Unified Transaction Content Floor | Proposed for Inclusion | Considered for Inclusion |
| [EIP-8163](https://eips.ethereum.org/EIPS/eip-8163) | Reserve `EXTENSION (0xae)` opcode | Proposed for Inclusion | Considered for Inclusion |
| [EIP-8250](https://eips.ethereum.org/EIPS/eip-8250) | Keyed Nonces for Frame Transactions | Proposed for Inclusion | Considered for Inclusion |
| [EIP-8253](https://eips.ethereum.org/EIPS/eip-8253) | Bump nonce of zero-nonce storage accounts | Proposed for Inclusion | Considered for Inclusion |
| [EIP-8272](https://eips.ethereum.org/EIPS/eip-8272) | Recent Roots for Frame Transactions | Proposed for Inclusion | Considered for Inclusion |
| [EIP-8279](https://eips.ethereum.org/EIPS/eip-8279) | Block Access List Byte Floor | Proposed for Inclusion | Considered for Inclusion |
| [EIP-8142](https://eips.ethereum.org/EIPS/eip-8142) | Block-in-Blobs (BiB) | — | Proposed for Inclusion |
| [EIP-8198](https://eips.ethereum.org/EIPS/eip-8198) | Quick Slots | — | Proposed for Inclusion |
| [EIP-8355](https://eips.ethereum.org/EIPS/eip-8355) | Precompiles for ML-DSA verification | — | Proposed for Inclusion |
| [EIP-8365](https://eips.ethereum.org/EIPS/eip-8365) | BLS withdrawal credential retirement | — | Proposed for Inclusion |
| [EIP-8369](https://eips.ethereum.org/EIPS/eip-8369) | VOPS Profiles for FOCIL Eligibility | — | Proposed for Inclusion |
| [EIP-8371](https://eips.ethereum.org/EIPS/eip-8371) | RowDAS - Distributed Blob Reconstruction | — | Proposed for Inclusion |
| [EIP-8379](https://eips.ethereum.org/EIPS/eip-8379) | Top-up Sync | — | Proposed for Inclusion |
| [EIP-8383](https://eips.ethereum.org/EIPS/eip-8383) | Reduce CL Block Retention Window | — | Proposed for Inclusion |
| [EIP-2488](https://eips.ethereum.org/EIPS/eip-2488) | Deprecate the CALLCODE opcode | Proposed for Inclusion | Declined for Inclusion |
| [EIP-7645](https://eips.ethereum.org/EIPS/eip-7645) | Alias ORIGIN to SENDER | Proposed for Inclusion | Declined for Inclusion |
| [EIP-7807](https://eips.ethereum.org/EIPS/eip-7807) | SSZ execution blocks | Proposed for Inclusion | Declined for Inclusion |
| [EIP-7819](https://eips.ethereum.org/EIPS/eip-7819) | SETDELEGATE instruction | Proposed for Inclusion | Declined for Inclusion |
| [EIP-7851](https://eips.ethereum.org/EIPS/eip-7851) | Code-Controlled EOA Delegation | Proposed for Inclusion | Declined for Inclusion |
| [EIP-7862](https://eips.ethereum.org/EIPS/eip-7862) | Delayed State Root | Proposed for Inclusion | Declined for Inclusion |
| [EIP-7923](https://eips.ethereum.org/EIPS/eip-7923) | Linear, Page-Based Memory Costing | Proposed for Inclusion | Declined for Inclusion |
| [EIP-8094](https://eips.ethereum.org/EIPS/eip-8094) | eth/vhash - Blob-Aware Mempool | Proposed for Inclusion | Declined for Inclusion |
| [EIP-8115](https://eips.ethereum.org/EIPS/eip-8115) | Batch priority fees at end of block | Proposed for Inclusion | Declined for Inclusion |
| [EIP-8146](https://eips.ethereum.org/EIPS/eip-8146) | Block Access List Sidecars | Proposed for Inclusion | Declined for Inclusion |
| [EIP-8182](https://eips.ethereum.org/EIPS/eip-8182) | Private ETH and ERC-20 Transfers | Proposed for Inclusion | Declined for Inclusion |
| [EIP-8188](https://eips.ethereum.org/EIPS/eip-8188) | Last-Written Block for Accounts and Slots | Proposed for Inclusion | Declined for Inclusion |
| [EIP-8200](https://eips.ethereum.org/EIPS/eip-8200) | EVMification | Proposed for Inclusion | Declined for Inclusion |
| [EIP-8219](https://eips.ethereum.org/EIPS/eip-8219) | Checked Arithmetic Opcodes | — | Declined for Inclusion |
| [EIP-8237](https://eips.ethereum.org/EIPS/eip-8237) | Independent CL/EL Sync | Proposed for Inclusion | Declined for Inclusion |
| [EIP-8243](https://eips.ethereum.org/EIPS/eip-8243) | Batching Attestations at Source | Proposed for Inclusion | Declined for Inclusion |
| [EIP-8304](https://eips.ethereum.org/EIPS/eip-8304) | Trustless log and transaction index | Proposed for Inclusion | Declined for Inclusion |
| [EIP-8321](https://eips.ethereum.org/EIPS/eip-8321) | Hash-Chain RANDAO | — | Declined for Inclusion |

## 更新が活発だった EIP

| EIP | タイトル | 種別 | ステータス | コミット数 |
| --- | --- | --- | --- | --- |
| [EIP-8037](https://eips.ethereum.org/EIPS/eip-8037) | State Creation Gas Cost Increase | Standards Track / Core | Review | 8 |
| [EIP-8081](https://eips.ethereum.org/EIPS/eip-8081) | Hardfork Meta - Hegotá | Meta | Draft | 8 |
| [EIP-7906](https://eips.ethereum.org/EIPS/eip-7906) | Transaction Assertions via State Diff Opcode | Standards Track / Core | Draft | 5 |
| [EIP-8038](https://eips.ethereum.org/EIPS/eip-8038) | State-access gas cost update | Standards Track / Core | Review | 3 |
| [EIP-8130](https://eips.ethereum.org/EIPS/eip-8130) | Keystore Accounts | Standards Track / Core | Draft | 3 |
| [EIP-8246](https://eips.ethereum.org/EIPS/eip-8246) | Remove SELFDESTRUCT Burn | Standards Track / Core | Last Call | 3 |
| [EIP-8250](https://eips.ethereum.org/EIPS/eip-8250) | Keyed Nonces for Frame Transactions | Standards Track / Core | Draft | 3 |
| [EIP-8272](https://eips.ethereum.org/EIPS/eip-8272) | Recent Roots for Frame Transactions | Standards Track / Core | Draft | 3 |
| [EIP-8288](https://eips.ethereum.org/EIPS/eip-8288) | In-mempool signature and proof aggregation | Standards Track / Core | Draft | 3 |
| [EIP-8360](https://eips.ethereum.org/EIPS/eip-8360) | TCREATE Opcode | Standards Track / Core | Draft | 3 |
| [EIP-7773](https://eips.ethereum.org/EIPS/eip-7773) | Hardfork Meta - Glamsterdam | Meta | Review | 2 |
| [EIP-8337](https://eips.ethereum.org/EIPS/eip-8337) | Validated EVM Code | Standards Track / Core | Draft | 2 |
| [EIP-8347](https://eips.ethereum.org/EIPS/eip-8347) | Offline State Migration to the PBT | Standards Track / Core | Draft | 2 |
| [EIP-8369](https://eips.ethereum.org/EIPS/eip-8369) | VOPS Profiles for FOCIL Eligibility | Informational | Draft | 2 |
| [EIP-1](https://eips.ethereum.org/EIPS/eip-1) | EIP Purpose and Guidelines | Meta | Living | 1 |
| [EIP-2780](https://eips.ethereum.org/EIPS/eip-2780) | Resource-based intrinsic transaction gas | Standards Track / Core | Review | 1 |
| [EIP-7784](https://eips.ethereum.org/EIPS/eip-7784) | GETCONTRACT opcode | Standards Track / Core | Review | 1 |
| [EIP-7843](https://eips.ethereum.org/EIPS/eip-7843) | SLOTNUM opcode | Standards Track / Core | Review | 1 |
| [EIP-7928](https://eips.ethereum.org/EIPS/eip-7928) | Block-Level Access Lists | Standards Track / Core | Review | 1 |
| [EIP-8066](https://eips.ethereum.org/EIPS/eip-8066) | Upgrade Mascots | Informational | Review | 1 |
| [EIP-8141](https://eips.ethereum.org/EIPS/eip-8141) | Frame Transaction | Standards Track / Core | Draft | 1 |
| [EIP-8163](https://eips.ethereum.org/EIPS/eip-8163) | Reserve `EXTENSION (0xae)` opcode | Standards Track / Core | Review | 1 |
| [EIP-8297](https://eips.ethereum.org/EIPS/eip-8297) | Partitioned Binary Tree | Standards Track / Core | Draft | 1 |
| [EIP-8298](https://eips.ethereum.org/EIPS/eip-8298) | SETCODEFROM Code Reuse Instruction | Standards Track / Core | Draft | 1 |
| [EIP-8304](https://eips.ethereum.org/EIPS/eip-8304) | Trustless log and transaction index | Standards Track / Core | Draft | 1 |
| [EIP-8355](https://eips.ethereum.org/EIPS/eip-8355) | Precompiles for ML-DSA Verification | Standards Track / Core | Draft | 1 |
| [EIP-8365](https://eips.ethereum.org/EIPS/eip-8365) | BLS withdrawal credential retirement | Standards Track / Core | Draft | 1 |
| [EIP-8379](https://eips.ethereum.org/EIPS/eip-8379) | Top-up Sync | Standards Track / Core | Draft | 1 |
| [EIP-8383](https://eips.ethereum.org/EIPS/eip-8383) | Reduce CL Block Retention Window | Standards Track / Networking | Draft | 1 |

## コミットログ

- 2026-09-01 [`54e1f09`](https://github.com/ethereum/EIPs/commit/54e1f09368557d380f08e44c3db6155355a4771c) Add EIP: Precompiles for ML-DSA Verification
- 2026-09-01 [`74b9c00`](https://github.com/ethereum/EIPs/commit/74b9c00a5c388347ec16f669dfc7e13920ddfcda) Update EIP-8016: fix minor typos
- 2026-09-01 [`b75cbe6`](https://github.com/ethereum/EIPs/commit/b75cbe61150f09a44c38843be916417283d5b7bf) Update EIP-8141: Remove a redundant check for frame's state gas limit
- 2026-09-01 [`8f1fe73`](https://github.com/ethereum/EIPs/commit/8f1fe737929d0816743c66fd334710de9af7384a) Add EIP: VOPS Profiles for FOCIL Eligibility
- 2026-09-02 [`84cc044`](https://github.com/ethereum/EIPs/commit/84cc044fe46b063d4efcbd81d229e03312f726cc) Update EIP-8081: Add new EIPs to the list in eip-8081.md
- 2026-09-02 [`260de0b`](https://github.com/ethereum/EIPs/commit/260de0b47ee34d8afd5e9b2314a5679e3ee3725e) Update EIP-8081: Frame Transaction
- 2026-09-02 [`51dc7b9`](https://github.com/ethereum/EIPs/commit/51dc7b939adae83369e1bf37b9ad71a3b190cd00) Update EIP-8369: Clarify EIP-8369 review follow-ups
- 2026-09-02 [`94f5a3e`](https://github.com/ethereum/EIPs/commit/94f5a3e3c146c28625d9ab2f8a7c0a848530a13a) Update EIP-8250: charge keyed nonce first use as state gas
- 2026-09-03 [`cd901da`](https://github.com/ethereum/EIPs/commit/cd901daab2a32187b27d94ecc76b773fd2ed530f) Update EIP-7906: reference the frame-family registry for opcode bytes
- 2026-09-03 [`6a6569c`](https://github.com/ethereum/EIPs/commit/6a6569c489383a546337e9da8289ecde84d0dd21) Update EIP-8130: rename to Keystore Accounts
- 2026-09-03 [`e0875b5`](https://github.com/ethereum/EIPs/commit/e0875b56ace4908361a3b40f6dbc852e4d5141f7) Add EIP: Top-up Sync
- 2026-09-04 [`20fb52b`](https://github.com/ethereum/EIPs/commit/20fb52b9b2c370b6964c59e4f998f63a14803122) Update EIP-8272: verify recent roots with a canonical frame
- 2026-09-04 [`65d177d`](https://github.com/ethereum/EIPs/commit/65d177d431638639d35897d6e869301a5ea8a02c) Update EIP-8037: restore a frame's state-gas on rollback
- 2026-09-04 [`58596a9`](https://github.com/ethereum/EIPs/commit/58596a9911b945fc855caa80a904c5b3f4c4f254) Update EIP-8037: remove the duplicated calldata floor note
- 2026-09-04 [`c406bdb`](https://github.com/ethereum/EIPs/commit/c406bdb2ffbf2fbf9d85698e97b3b2e8b6e79112) Update EIP-8037: correct the general state-gas charge timing
- 2026-09-04 [`fe87e74`](https://github.com/ethereum/EIPs/commit/fe87e741f2ebf1d73a808fe5f245481740a77736) Update EIP-8272: Add lightclient as a co-author
- 2026-09-04 [`3ff5cff`](https://github.com/ethereum/EIPs/commit/3ff5cff17a11ab31273ee14ebea0df8bbc4f4aef) Update EIP-8037: return state-gas to gas_left when a child merges
- 2026-09-04 [`052029f`](https://github.com/ethereum/EIPs/commit/052029f3625328d6f51dec8e62a7090201e66f17) Update EIP-8037: remove unused evm_execution_gas_used counter
- 2026-09-04 [`7243c92`](https://github.com/ethereum/EIPs/commit/7243c92ba812437c64bae9fc6524ee269b29daa9) Update EIP-2780: align runtime charging and reference cases
- 2026-09-04 [`9388239`](https://github.com/ethereum/EIPs/commit/9388239ee5205f341d948a73bf8eb109f761b167) Update EIP-8246: note the CREATE2 redeploy of a funded remnant
- 2026-09-04 [`9207c60`](https://github.com/ethereum/EIPs/commit/9207c6011f526bd40abd79649484a1a342585bd4) Update EIP-8246: give a concrete example of L2 burn usage
- 2026-09-06 [`a9031bd`](https://github.com/ethereum/EIPs/commit/a9031bdc85949321a9707dd59ba44cdcba4a0eb0) Add EIP: TCREATE Opcode
- 2026-09-07 [`824cbc0`](https://github.com/ethereum/EIPs/commit/824cbc0b0e459ea6b105d8b96420a5d46abf0806) Update EIP-8272: count recent root verification gas
- 2026-09-08 [`991d932`](https://github.com/ethereum/EIPs/commit/991d932f52a56477753cd9f62114b842cd77275c) Update EIP-8304: Update eip-8304.md
- 2026-09-09 [`1f373da`](https://github.com/ethereum/EIPs/commit/1f373dabb23ca0602fc78b3a08a767263b76e228) Add EIP: Frame Type for PQ Sig and STARK Aggregation
- 2026-09-09 [`ef1abf4`](https://github.com/ethereum/EIPs/commit/ef1abf4b6d311597f64314966a883ef9f48d8185) Update EIP-8288: Update eip-8288.md
- 2026-09-09 [`d2a64c2`](https://github.com/ethereum/EIPs/commit/d2a64c2d4cc44f2f507577d0ebfb110dcc21d358) Update EIP-7928: Amend storage-read gas-feasibility check
- 2026-09-11 [`f3079a0`](https://github.com/ethereum/EIPs/commit/f3079a09e8c606afcb0e5e1a309ff228b88dc067) Update EIP-8250: Preserve nested fees in transaction payload
- 2026-09-12 [`c4f6cf4`](https://github.com/ethereum/EIPs/commit/c4f6cf42414ed3970d27c9e542384d94ade7736d) Update EIP-8288: New title for EIP-8288
- 2026-09-14 [`9dcd727`](https://github.com/ethereum/EIPs/commit/9dcd72754f3fe4b48a4dbeffee669dc4c60f7ec5) Update EIP-8037: keep pre-execution state-gas out of the frame rollback
- 2026-09-14 [`d708780`](https://github.com/ethereum/EIPs/commit/d7087803ca236498c73f64665df0ddac7d621950) Update EIP-8037: cap the transaction gas limit at 2^32-1
- 2026-09-14 [`286a88e`](https://github.com/ethereum/EIPs/commit/286a88e75f7bb301ba58e534e3484aae86001ed2) Update EIP-8038: Preserve the warm SELFDESTRUCT access exemption
- 2026-09-14 [`fa00701`](https://github.com/ethereum/EIPs/commit/fa00701bb23869a0d285cfddffbe8fab6d7b4465) Update EIP-7906: abstract covers all three opcodes and the POST_TX frame mode
- 2026-09-14 [`0a97853`](https://github.com/ethereum/EIPs/commit/0a9785358ca740a3f302b9e197712ca0d4a2b2bc) Update EIP-7906: state what a single TXTRACE or TXDIFF call returns
- 2026-09-14 [`ecb47af`](https://github.com/ethereum/EIPs/commit/ecb47af4c9ef6166bc79cf45cb4574a1d0ad29df) Update EIP-7906: give EVENTDATACOPY its own section
- 2026-09-14 [`aad37d7`](https://github.com/ethereum/EIPs/commit/aad37d71f92291e4bec2966057a6b8e0287d9e2b) Update EIP-8081: DFI decisions from ACDE245
- 2026-09-14 [`d6bcf06`](https://github.com/ethereum/EIPs/commit/d6bcf061bf8942ff5ef9dc940e236b1f367e4bd0) Update EIP-8130: align scope bits, POLICY/OPERATOR semantics, and importAccount with the canonical repository
- 2026-09-14 [`9d98cc7`](https://github.com/ethereum/EIPs/commit/9d98cc796ddb1f895ef638d4d64c5f52092f75f9) Update EIP-8081: Add 8379
- 2026-09-14 [`7c073a9`](https://github.com/ethereum/EIPs/commit/7c073a9d83c6e39f4ee14a71acbb513e2b987c12) Update EIP-8081: DFI 8219
- 2026-09-15 [`1bbccfb`](https://github.com/ethereum/EIPs/commit/1bbccfb3b9dd06d3b5668792eb8185d309b6e407) Update EIP-8038: clarify charge attribution and component definitions
- 2026-09-15 [`37294ec`](https://github.com/ethereum/EIPs/commit/37294ec724511f5cc9d607f703dc189662fc47c0) Update EIP-7773: Align listed EIP titles
- 2026-09-15 [`2db02af`](https://github.com/ethereum/EIPs/commit/2db02af3e4e8c3553b6419a0b6159fcef599ce48) Update EIP-8246: Move to Last Call
- 2026-09-15 [`673f211`](https://github.com/ethereum/EIPs/commit/673f2116e1d87a3128e9f54ec9ff08f6a36d2d5c) Update EIP-7784: Move to Review
- 2026-09-16 [`90194cf`](https://github.com/ethereum/EIPs/commit/90194cfa32915fc8a4ba5b7eea783774c2182b7f) Update EIP-8066: Require mascot relevance
- 2026-09-16 [`16390e1`](https://github.com/ethereum/EIPs/commit/16390e1faee756757021e785f4e6ef35a7e6a0f5) Update EIP-8130: apply EIP-7623 calldata floor to intrinsic gas
- 2026-09-16 [`c99b1c8`](https://github.com/ethereum/EIPs/commit/c99b1c82ccb2802b15291b297fac2fabef7e6381) Update EIP-1: Allow links to UTS (#10565)
- 2026-09-17 [`2c2da76`](https://github.com/ethereum/EIPs/commit/2c2da76671d77e7d2f5060b23f8a92cb5d62897e) Add EIP: BLS withdrawal credential retirement
- 2026-09-17 [`e44e196`](https://github.com/ethereum/EIPs/commit/e44e1960a9328282af8dd884837c2302f6a45c3d) Update EIP-7843: align Engine API method names with execution-apis
- 2026-09-17 [`644b847`](https://github.com/ethereum/EIPs/commit/644b84799ba6873edcb13c0e21fdd319b4efbc08) Update EIP-7773: Set Sepolia activation time
- 2026-09-18 [`4c7e248`](https://github.com/ethereum/EIPs/commit/4c7e2487e4da3131bcadc7399f8b153f5344c0b7) Update EIP-8038: use execution-gas wording, fix the CALLCODE creation cell and a stale benchmark test name
- 2026-09-18 [`dbc6d45`](https://github.com/ethereum/EIPs/commit/dbc6d457cbf90d5f9d55552f3fd91d58b88cc898) Update EIP-8037: remove stale EIP-7610 collision rules
- 2026-09-20 [`d288471`](https://github.com/ethereum/EIPs/commit/d288471ea8026e6a5b816218ebe8fb1209a34d6e) Update EIP-8360: clarify ephemeral account semantics and fix EIP-684 references
- 2026-09-21 [`9e4d587`](https://github.com/ethereum/EIPs/commit/9e4d5878ac4935877cc346b1067632428a0e596b) Update EIP-8250: forbid reverting approval effects on validation-prefix restore
- 2026-09-21 [`74c8e3f`](https://github.com/ethereum/EIPs/commit/74c8e3fef9eaab3ae55a25be5cb8de2b387faa5b) Update EIP-7906: per-topic-value event views (TXDIFF 0x0B/0x0C)
- 2026-09-21 [`24c0edb`](https://github.com/ethereum/EIPs/commit/24c0edb17b82cb65f26d29f03e084637ec2ae2d4) Update EIP-8081: Decisions from ACDC187
- 2026-09-23 [`9e24115`](https://github.com/ethereum/EIPs/commit/9e24115af7b6ecf492d4e5b7aac84c975fe4f938) Update EIP-8163: move non-L1 usage out of Specification
- 2026-09-23 [`064a772`](https://github.com/ethereum/EIPs/commit/064a7729f7834375fe60ed154a4cc502c31628a6) Add EIP: Reduce CL Block Retention Window
- 2026-09-23 [`bc7a7a8`](https://github.com/ethereum/EIPs/commit/bc7a7a8dd70dc0a4947b6cb1eea05d9796d1f80a) Update EIP-8337: Unframed entries.
- 2026-09-23 [`cc497c3`](https://github.com/ethereum/EIPs/commit/cc497c3150da41dba9b34f6f79f65a9fcf033eb9) Update EIP-8360: Specify CREATE and CREATE2 in TCREATE accounts
- 2026-09-23 [`10bc64e`](https://github.com/ethereum/EIPs/commit/10bc64e2ea592ac7ec8ee87812ca8a8955a68bac) Update EIP-8081: add EIP-8383 to PFI'd
- 2026-09-24 [`9334ef5`](https://github.com/ethereum/EIPs/commit/9334ef5e847a6088e80691b761a48938d8154991) Update EIP-8337: Clearer definitions and formatting.
- 2026-09-24 [`57474d3`](https://github.com/ethereum/EIPs/commit/57474d392627f777d41ac2140a82d7208b9c262f) Update EIP-8297: reserved basic-data bytes must be zero
- 2026-09-24 [`210a28d`](https://github.com/ethereum/EIPs/commit/210a28dac6931dba40da7fd48334220e59f0ae73) Update EIP-8298: allow SETCODEFROM in initcode and require an existing source
- 2026-09-24 [`95176db`](https://github.com/ethereum/EIPs/commit/95176db61e5751e44964fb5e0766412cf2bf6e9a) Update EIP-8081: Decisions from ACDE246
- 2026-09-24 [`0b8184b`](https://github.com/ethereum/EIPs/commit/0b8184b1d6ed9fba836222684fd082b32782d4ef) Update EIP-8347: empty snapshots and the scope of the preimage match
