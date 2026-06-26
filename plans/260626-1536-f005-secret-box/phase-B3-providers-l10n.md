# Phase B3 — Providers + phase controller + l10n keys (Track B)

**Track:** B (logic) · **blockedBy:** B2 · **Status:** done

**Delivered:** SecretBoxController (StateNotifier: `close → opening → revealed` + error guard) + UiState (`{phase, reward?, errorMessage?}`); shared `secretBoxRepositoryProvider` (singleton, feed stats source); usecase providers (DI); l10n keys (VN/EN/JA) for all static labels; `gen-l10n` succeeds; analyze clean.

## Context Links
- Pattern refs: `lib/features/kudos/presentation/providers/kudos_providers.dart`
  (repo DI → usecase DI → AsyncNotifier controller), `lib/core/l10n/app_*.arb`
- Spec: `spec/secret-box/secret-box.md` (FR2–FR9)

## Overview
- **Priority:** P2 · **Status:** pending
- DI providers for the repo + usecases, a controller that drives the
  `closed → opening → revealed` state machine, and l10n keys for all static labels.

## Key Insights
- The controller is the heart: it holds `SecretBoxPhase` + the revealed `SecretBoxReward?`.
  `open()` sets phase=opening, awaits `OpenSecretBox`, then sets phase=revealed with the reward.
  UI watches phase; A1 plays animation on `opening`.
- The repo provider MUST be the SAME instance the feed stats read post-open (single source of
  truth for the unopened count) — expose a shared provider, INT binds feed stats to it.
- l10n: VN default / EN / JA. Reward names stay DATA (not keys) per i18n discipline.

## Requirements
- **Functional:** expose `secretBoxRepositoryProvider`, usecase providers, a
  `SecretBoxController` (StateNotifier/AsyncNotifier) with `open()`/`reset()`, and a state object
  `{phase, reward?, error?}`.
- **Non-functional:** files < 200 lines; analyze clean; ARB keys in all three locales.

## Architecture
Data flow: UI → `controller.open()` → phase=opening (UI animates) → `OpenSecretBox` usecase →
reward → phase=revealed → UI shows reward. `controller.reset()` returns to closed (re-entry).

## Related Code Files
**Create:**
- `lib/features/secret_box/presentation/providers/secret_box_providers.dart` — repo/usecase DI + controller.

**Modify:**
- `lib/core/l10n/app_vi.arb`, `app_en.arb`, `app_ja.arb` — add Secret Box static labels
  (title, open CTA, "đang mở", reward heading, close, "none left"). Regenerate
  `app_localizations*.dart` via `fvm flutter gen-l10n`.

**Delete:** none.

## Implementation Steps
1. Define `SecretBoxUiState {phase, reward?, errorMessage?}` (in providers file or co-located).
2. `secretBoxRepositoryProvider` → `StubSecretBoxRepository()` (shared singleton).
3. Usecase providers (`getSecretBoxStateProvider`, `openSecretBoxProvider`).
4. `SecretBoxController` with `open()` / `reset()` driving phase transitions + error capture.
5. Add ARB keys (VN/EN/JA) for every static label; run `gen-l10n`.

## Todo List
- [ ] secret_box_providers.dart (DI + controller + ui state)
- [ ] ARB keys ×3 + gen-l10n

## Success Criteria
- `fvm flutter analyze` clean; `gen-l10n` succeeds; controller transitions closed→opening→revealed
  in a provider-level test.

## Risk Assessment
- **Med:** error mid-open leaves phase stuck. Mitigation — `open()` wraps in guard, on error sets
  phase back to closed + errorMessage; UI shows retry.

## Security Considerations
- None.

## Next Steps
- Unblocks B4 (route renders a screen that reads this controller) and INT.
