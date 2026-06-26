# Phase TEST — Tests: open flow, reveal states, entry, no-overflow, i18n

**Track:** — · **blockedBy:** INT · **Status:** pending

## Context Links
- Pattern refs: existing kudos widget/provider tests under `test/` (375×812 surface convention)
- Memory note: fixed-width overflow bug + 375px test discipline (`tester.view.physicalSize =
  Size(1170,2532); dpr=3`)

## Overview
- **Priority:** P2 · **Status:** pending
- Prove the feature against the FINAL integrated code. Run with `fvm flutter test`.

## Test Matrix

| Layer | What it proves | Cases |
|-------|----------------|-------|
| Unit (domain/data) | stub repo + usecases | `open()` decrements unopened + returns reward; `open()` past supply → none-left path; `getState()` shape |
| Unit (provider) | controller state machine | closed→opening→revealed on `open()`; error → back to closed + message; `reset()` → closed |
| Widget | SecretBoxScreen renders each phase | closed shows CTA; revealed shows reward (incl. null-asset fallback); no overflow at 375px |
| Widget | entry from feed | feed "Mở Secret Box" button enabled + tap pushes `/secret-box` |
| Widget | i18n | VN default labels; EN + JA render localized static labels (no hardcoded VN leak) |
| Integration | full loop + stats | open → reveal → close → feed `secretBoxOpened`/`secretBoxUnopened` updated |

## Requirements
- **Functional:** cover open flow, all 3 reveal states, feed entry, none-left (FR8), stats sync (FR7).
- **Non-functional:** no fake passes; tests hit real stub repo (override with a deterministic
  test stub via provider override, not mocks of domain).

## Related Code Files
**Create:** test files under `test/features/secret_box/{domain,data,presentation}/…` + an
integration test for the feed→box→feed loop. **Modify/Delete:** none.

## Implementation Steps
1. Domain/data unit tests (repo + usecases).
2. Controller state-machine tests (provider container).
3. Widget tests per phase at 375×812 (overflow guard).
4. Entry-from-feed widget test (button enabled + navigation).
5. i18n tests (pump under EN/JA locale).
6. Integration test: full loop asserts stats delta.

## Todo List
- [ ] domain/data unit tests
- [ ] controller tests
- [ ] per-phase widget tests (+ overflow)
- [ ] entry-from-feed test
- [ ] i18n tests
- [ ] integration loop + stats test

## Success Criteria
- `fvm flutter test` all green; no overflow warnings; EN/JA show no Vietnamese leak.

## Risk Assessment
- **Med:** animation timing flakiness in widget tests. Mitigation — `tester.pumpAndSettle()` /
  pump fixed durations; assert end-state not mid-frame.

## Security Considerations
- None.

## Next Steps
- On green: hand to `reviewer`; promote spec to `docs/features/F005_SecretBox/`; run
  `/tkm:rebuild-spec --features F005`; update roadmap + changelog.
