# F005–F008 Multi-Feature iOS Implementation Sprint

**Date**: 2026-06-26 19:29
**Severity**: Low
**Component**: iOS Flutter screens (System, Secret Box, Notifications, Profile)
**Status**: Resolved

## What Happened

Built the four final iOS MoMorph features end-to-end over a single takumi two-track session, executed sequentially on branch `feat/kudos-remaining-screens` (local, not pushed). Order was F008 → F005 → F007 → F006, each feature hitting Track A UI implementation in parallel with Track B logic, integrated, tested, reviewed, fixed, sealed, then committed before the next feature started. Delivered 475 passing tests, clean analyzer output, zero pushes. iOS MoMorph coverage now complete except Search (no design exists).

## The Brutal Truth

This sequence worked, but the relief is tempered. The reviewer pass — which flagged REAL bugs that the green test suite completely missed — proved we're running a three-stage gate and calling two stages finished is false confidence. The galling part is the tests were green on every feature. The green was lying.

Each feature's reviewer found something the tester didn't: F007 had route string mismatch (stored `/kudos/detail/{id}`, resolver expected entity IDs, malformed `/kudos/detail//kudos/...` on deep-link), F006 had a dead dropdown and unmapped awards list, F005 had a controller stuck in opening state because `on Exception catch` doesn't catch Dart's built-in Error types, F007 had wrapper tests that could never fail because they only asserted the MaterialApp existed. Tests passing meant nothing.

The craft lesson sits heavy: **green tests do not mean correct**. The reviewer's eye, asking "would I ship this?", found every one. Skip that pass and something ships broken.

## Technical Details

**F008 System Screens** (commits `4203f7e`)
- Access Denied (403) + Not Found (404) error routes
- go_router `errorBuilder` + auth-aware CTA wrappers
- Routed to on 403, deep-link 404

**F005 Secret Box** (commits `715bfcd`)
- One SecretBoxScreen mapped from 9 screenIds
- Three-state machine: closed → opening → revealed
- FR7 stats single-sourced via `secretBoxStateProvider` merged into `kudosStatsProvider` (no provider duplication, shared stat view)
- Reveal animation gates on `onOpeningComplete` from UI to avoid race with controller phase

**F007 Notifications** (commits `4fe90e1`)
- Notification list screen with markRead/markAllRead 
- Migrated `unreadCountProvider` off hardcoded home stub (was fixed at 3) to actual controller derivation
- Deep-link support for notification-to-screen routing
- Deleted 3 dead home screen files (stub remnants)

**F006 Profile** (commits `aefc5b7` + `1c4624c`)
- One ProfileScreen with isSelf branch logic
- ProfileData composes F003 AwardDetail + F004 KudosStats/Kudo (no duplication)
- Routes: /profile (current user) + /profile/:userId (any user)
- Tab integration on /profile

**Also Landed**
- Kudos bug-fixes: `24271bd`
- 4 blueprints (Screen stubs for future work): `823b63c`

## What We Tried

**Sequential takumi runs (instead of parallel)** — each feature locked the shared `app_router.dart` file, so running features in parallel would have caused merge hell. Ordering F008 → F005 → F007 → F006 meant one commit, then the next feature started. Accepted the slower wall-clock time to avoid git thrashing.

**Reviewer-after-tester as hard gate** — every feature went tester → reviewer → fix pass → evidence gate SEALED (hard requirement, can't move forward). This caught the bugs tests didn't.

**Provider shape preservation** — when migrating `unreadCountProvider` to derive from the new controller instead of a stub, kept its signature as `StreamProvider<int>` with `async*` re-yield. Zero edits needed at call sites. Cross-feature migration made safe.

**Animation vs controller timing** — F005 gated the revealed state UI on the animation's `onOpeningComplete` callback instead of the controller's phase. Prevents a stub controller from cutting the animation short.

## Root Cause Analysis

**Green tests were a lie because:**
1. Tests only assert scaffolding, not behavior — F007 wrapper tests asserted `find.byType(MaterialApp)` only (can't fail).
2. Integration tests don't catch routing mismatches — F007 stored route strings, deep-link resolver expected IDs; the route literal `/kudos/detail/{id}` isn't checked until tapped.
3. Tests don't catch wiring — F006 filter dropdown pointed to a stateless screen (dead code path); test never exercised it.
4. Exception handling doesn't catch Dart Error types — F005 controller stuck in opening because the exception handler was catching `Exception`, not `Error` (builtin Dart).

**Why the reviewer caught it:** reviewers read code asking "would I ship this?" — they trace execution paths by hand, spot dead branches, notice wiring mismatches. Tests don't think. Reviewers do.

**Why we didn't parallelize the full session:** `app_router.dart` is shared. Merge conflicts on router edits would have tangled the flow. One feature at a time, one commit, next feature starts.

**Why agent self-reported test counts drifted** (427 vs 412 vs 475): subagents don't re-run; they estimate or read partial output. Always re-run `fvm flutter test` yourself — reading the final count from the test runner is the only source of truth.

## Lessons Learned

1. **Reviewer-after-tester is non-negotiable.** Tests pass ≠ correct. The adversarial review pass caught 100% of real bugs; tests caught 0%. This is repeatable. Do not ship without the review gate.

2. **Fold the router into integration, not Track B logic.** Routing imports screen classes, so keeping router edits in the INT join (after both tracks finish) kept Track A and Track B import-independent. They stayed parallel-runnable at the task level.

3. **Migrate shared providers by preserving their shape.** `unreadCountProvider` stayed `StreamProvider<int>` with `async*` re-yield, so all call sites (`.valueOrNull ?? 0`) worked without edits. Risky cross-feature migration made safe by keeping the contract.

4. **Don't trust agent self-reported numbers.** Always re-run the test harness yourself and read the output. The test runner is the source of truth.

5. **Gate animation timing on UI completion, not controller phase.** F005 had the controller move fast (stub behavior), which cut the reveal animation. Tie the revealed-state view to `onOpeningComplete` (UI callback), not controller timing.

6. **Reconcile deep-link resolver expectations with stored routes.** F007 stored route strings like `/kudos/detail/{id}`, but the deep-link resolver expected entity IDs. The mismatch only surfaced in the reviewer's hand-trace. Test it by tapping the link in the app.

7. **Sequential feature commits on shared files beats merge conflicts.** `app_router.dart` touched by all 4 features. Parallel work would have tangled. One feature → one commit → next feature started. Slower wall-clock, cleaner git history, zero rework.

## Next Steps

- Branch `feat/kudos-remaining-screens` is local and not pushed. When ready to integrate to main, push the branch and open a PR.
- Search feature (F009) has no iOS design yet — hold until designs arrive.
- iOS MoMorph implementation is now feature-complete for all designed screens (8 features shipped).
- No doc updates needed; MoMorph coverage already recorded in `docs/features/`.
- Consider codifying the "reviewer-after-tester" gate as a hard rule in development-rules.md.

