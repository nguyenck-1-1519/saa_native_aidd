# F004 Kudos Follow-up — 5 Screens Shipped, Integration Seam Surfaced

**Date**: 2026-06-26 09:50
**Severity**: Medium
**Component**: F004 Kudos feature / integration layer
**Status**: Resolved

## What Happened

Executed the F004 Kudos follow-up plan (`plans/260625-2309-kudos-remaining-screens/`) end-to-end: built and shipped 5 iOS screens (View kudo detail + anonymous variant, All Kudos, Community Standards, Rules), made recipient search and feed filters functional over local stub data. MoMorph two-track orchestration via `tkm:takumi --auto`: 4 background UI implementer agents ran parallel to 1 Track-B logic agent; integration passed them to a single INT phase, then tester → reviewer → fix-pass → delivery (pm, doc-writer, git-manager). Delivered to `feat/kudos-remaining-screens` local branch, 69 files touched, commit `8bbf71c`. Secret Box flow carved out as future F005.

## The Brutal Truth

The orchestration looked clean — parallel tracks, clear join points — until the tester ran the full suite. What reported green in per-file isolated tests turned into 11 failures across the integrated codebase. The sting: the write-kudo screen's tests were passing in isolation but breaking when the real code ran because of a provider coupling the INT phase had wired. Hours spent chasing a phantom bug that wasn't actually in the new code but in how the new code changed the shape of a shared screen. That kind of gap — between "this test passes" and "this code runs in the actual app" — is exactly what kills a team's trust in the suite. The galling part is that we knew better: integration rewires are high-risk touches, and the tester should have run the **whole** suite, not just the new tests in isolation.

## Technical Details

**The integration break:**
- Track B logic included a `recipientSearchControllerProvider` (debounced) wired into the write-kudo form's recipient field.
- When the INT phase rewired the write-kudo screen to use that provider, the existing write-kudo test suite (written before recipient search existed) pumped the screen without providing a `ProviderScope` for the new controller.
- Result: 8 write-kudo test failures with "No ProviderScope found" at runtime.

**The all-kudos list phantom:**
- The all-kudos tests asserted for specific widgets using `find.byType()` on a `DropdownButton`, but the real filter UI is a chips + bottom-sheet in the route wrapper `kudos_route_wrappers.dart`.
- The test mocks were stale, asserting against a shape that no longer existed in the actual delivered code.
- 3 failed widget tests; test assertions made false promises about what the code does.

**Debounce timing trap:**
- The debounced `recipientSearchController` requires `pumpAndSettle(Duration)` in widget tests, not bare `pump()`.
- 1 test flaked intermittently because the pump finished before the debounce window closed.

**Error evidence:**
```
E/flutter (64752): NoProviderContainerFound: Could not find a ProviderContainer above this widget.
E/flutter (64752): This likely happened because:
E/flutter (64752):  - The widget tree does not have a ProviderScope at the root
E/flutter (64752):  - Or the ProviderScope was placed below the widget using the provider
```

Quality gates at the moment:
- 82 new tests written; suite assumed all-green.
- Tester report marked DONE with 270 total tests passing (per-file aggregate).
- **Full `fvm flutter test` output never run before review.**

## What We Tried

1. **Isolation testing (failed):** Ran per-file test targets; all green. Did not catch cross-file coupling.
2. **Spun up a full-suite run after review:** Surface 11 failures; root-cause each.
3. **Fix pass (successful):**
   - Wrapped failing write-kudo tests in explicit `ProviderScope` scaffolding.
   - Rewrote all-kudos list test assertions to match the **actual** route-wrapper chip+sheet UI.
   - Added `pumpAndSettle(Duration(milliseconds: 500))` after debounce-triggering actions.
   - Verified no remaining test logic conflicts.
4. **Re-run full suite:** 270 green.

## Root Cause Analysis

**Primary: Integration layer as a blind spot.** The two-track split was clean for UI and logic — but the seam where they join (INT phase) carries hidden coupling: provider rewires touch shared screens (write-kudo, home feed) that have their own test suites. Those test suites were written before the rewire; they encode assumptions about the screen shape that are now stale. The tester's isolation-mode green was an honest false signal — the test passed because it never saw the real wiring.

**Secondary: Test discipline gap.** The MoMorph two-track spin spawned 4 parallel UI agents + 1 logic agent. Each reported per-file test passes. The tester's role was to run the integration suite, but the request was phrased as "test new code" (per-file), not "verify the full app still runs" (suite-level). A one-sentence difference in scope led to a phantom bug hunt.

**Tertiary: Debounce and widget-tree assumptions.** Tests written before debounced search existed don't know to pump long enough; tests written for a bare `DropdownButton` don't expect a route-wrapper. These are bread-and-butter integration issues, but they weren't caught until **after** review approval.

## Lessons Learned

1. **Per-file green ≠ suite green.** In a parallel-execution model (especially MoMorph two-track), integration is NOT a free join. The INT phase rewires shared screens; those rewires break existing tests. Lesson: Always run `fvm flutter test` (the full suite) before marking work done, not just the new tests or per-file targets. The codebase is one thing; it either works end-to-end or it doesn't.

2. **Fold the router into integration, not Track B.** Putting route-table changes (B4) inside the Track-B logic spine meant the router imported screen classes before Track A finished building them. This forced Track A ↔ B coupling. The fix was moving B4 into the INT phase, so the router sits as the join point, not a dependency inside B. Lesson: Route tables are integration artifacts; they live at the seam, not on either side.

3. **Debounced providers need explicit pump timing in tests.** A bare `pump()` or `pumpAndSettle()` doesn't respect user-side debounce windows. The provider closes its async gate; the pump completes before the gate opens. Lesson: When a test triggers a debounced action, call `pumpAndSettle(Duration(milliseconds: [debounce_window]))` explicitly, not just `pumpAndSettle()`.

4. **Integration rewires are high-risk touches.** When INT phase touches a shared screen (write-kudo, feed), treat it like a refactor: re-run the screen's existing test suite in full, not just the new assertions. The old tests encode the old shape; they fail when the shape changes, and that failure is actionable (tells you what broke).

## Next Steps

- **Merge to main (blocked on user decision):** The branch is local; not pushed. PM/doc-writer/git-manager completed their handoff. Delivery is ready pending approval to merge `feat/kudos-remaining-screens` → `main` and push.
- **Secret Box (F005):** Carved out; ~10 states to build ([iOS] Open secret box + Standby variants). Separate plan when ready.
- **Backend wiring (deferred):** Recipient search, filters, and all detail data are currently over local stub. DI is ready; swap the repo impl when backend ships. No code changes needed — just wire the real repo into the existing usecases.
- **JA native-copy review:** Kudos feature added i18n keys; native JA speaker review needed.
- **Tech debt:** Documented in memory — awards→home widget coupling, S3 null fallbacks, Signature award prize dual-value. Each flagged for next touch.

## Quality Record

- Tests: 82 new, 270 total (all green after fix-pass).
- Analysis: `fvm flutter analyze` clean.
- Review verdict: APPROVE-WITH-NITS → all nits fixed (H1 filter-clear sentinel, M4 message-length trim, file splits, unused i18n keys wired, autoDispose on family).
- Delivery: local branch, not pushed; ready to merge.
