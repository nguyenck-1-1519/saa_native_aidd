---
feature_id: F005
title: Secret Box — reveal flow (iOS)
lang: vi
platform: iOS (Flutter) — Android sau
fileKey: kQk65hSYF2
momorph_screens:
  - Secret Box closed:    kQk65hSYF2
  - Secret Box opening:   KUmv414uC9
  - Revealed variants:    7 screenIds (see §5a)
status: implemented (local stub — no real backend)
depends_on: F004 Kudos (đã xong; secretBoxStateProvider cấp thông tin cho kudosStatsProvider)
---

# F005 — Secret Box (reveal flow)

## 1. Mục tiêu

Full-screen Secret Box reveal animation: closed → opening → revealed.
Reach: KudosScreen "Mở Secret Box" button → `/secret-box` (push ngoài shell).

## 2. Màn — SecretBoxScreen (screenId kQk65hSYF2 / KUmv414uC9 + 7 revealed variants)

9 MoMorph screenIds → 1 screen + state machine (xem §4).

| State | MoMorph screenId | Mô tả |
|---|---|---|
| closed | kQk65hSYF2 | Hộp đóng, nút "Mở" |
| opening | KUmv414uC9 | Animation phát; nút disable |
| revealed (7 variants) | (7 ids — reward asset variants) | Reward card hiện thị |

## 3. Module

```
lib/features/secret_box/
├── domain/
│   ├── entities/secret_box_reward.dart      # id, name, descriptor, assetRef?
│   ├── entities/secret_box_state.dart       # unopenedCount, openedRewards
│   ├── repositories/secret_box_repository.dart
│   ├── usecases/get_secret_box_state.dart
│   ├── usecases/open_secret_box.dart
│   └── value_objects/secret_box_phase.dart  # closed | opening | revealed
├── data/
│   ├── sources/secret_box_mock_data.dart
│   ├── repositories/stub_secret_box_repository.dart
│   └── repositories/fake_secret_box_repository.dart
└── presentation/
    ├── secret_box_screen.dart
    ├── providers/secret_box_providers.dart
    └── widgets/
        ├── secret_box_app_bar.dart
        ├── secret_box_closed_content.dart
        ├── secret_box_opening_animation.dart
        ├── secret_box_opening_wrapper.dart
        ├── secret_box_revealed_content.dart
        └── secret_box_reward_image.dart
```

## 4. State machine

```
closed  →(tap Mở)→  opening  →(usecase OK)→  revealed
  ↑                                               |
  └─────────────────(reset / re-open)─────────────┘
  ↑
  └─(usecase error)─ closed + errorMessage
```

- `SecretBoxPhase` enum drives UI branch inside `SecretBoxScreen`.
- `SecretBoxController` (Riverpod `Notifier<SecretBoxUiState>`) owns the transition + double-tap guard.
- On success: `ref.invalidate(secretBoxStateProvider)` → `kudosStatsProvider` recomputes feed counter.

## 5. FR

- FR1: Closed state — hộp đóng; nút "Mở Secret Box" tap → starts open sequence.
- FR2: Opening state — animation phát; nút disable (double-tap guard).
- FR3: Revealed state — reward card: tên, descriptor, ảnh (assetRef) hoặc Icon fallback.
- FR4: Error path — usecase throw → reset to closed, show `errorMessage`.
- FR5: Route `/secret-box` push từ KudosScreen "Mở Secret Box" (ngoài shell).
- FR6: Dữ liệu từ `StubSecretBoxRepository` (local in-memory; 1 unopened box → FR8 after open).
- FR7 (stats-sync): `kudosStatsProvider` watch `secretBoxStateProvider` làm single source — feed counter (secretBoxOpened / secretBoxUnopened) luôn khớp thực tế ngay sau khi mở hộp.
- FR8 (none-left): `unopenedCount = 0` → `open()` throws; UI resets; stub cho phép test path ngay sau 1 lần mở.
- FR9: i18n nhãn tĩnh (vi/en/ja); JA cần review người bản ngữ.

## 5a. Screen list (F005)

| Screen | Route | Class | MoMorph screenId(s) |
|---|---|---|---|
| SecretBoxScreen | `/secret-box` | `SecretBoxRouteWrapper` → `SecretBoxScreen` | kQk65hSYF2 (closed), KUmv414uC9 (opening), + 7 revealed variants |

## 6. Assets

`SecretBoxReward.assetRef` là nullable: `null` → `SecretBoxRewardImage` hiển thị Icon fallback.
Box + reward art assets chưa export S3 từ MoMorph — fallback đang active.

## 7. NFR

- Clean Architecture: `features/secret_box/{domain,data,presentation}`. File <200 dòng.
- Riverpod: `secretBoxRepositoryProvider` (shared, single instance) + `secretBoxStateProvider` (FutureProvider) + `secretBoxControllerProvider` (NotifierProvider). `kudosStatsProvider` watch `secretBoxStateProvider` — không dùng riêng repo.
- Tests: 77 tests (F005); tổng suite 371, 0 failed.

## 8. Deferred

- Real backend persistence + server reward allocation.
- Sharing flow (chia sẻ reward).
- Box + reward art assets — chờ design export S3.
- Android.
