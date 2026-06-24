# Business Rules — SAA 2025 Flutter App

> Source: implemented code only. No fabricated rules.
> Each rule carries: ID, rule statement, rationale, source file(s).

---

## BR001 — Countdown Elapsed Clamp

**Rule:** When the current time is at or past the event target (2025-12-26 00:00:00 local), the
countdown displays `0` for days, hours, and minutes, and `isElapsed = true`. Negative values
never reach the UI. The 1-second timer stops once elapsed; it does not restart.

**Rationale:** The event date is in the past at the time of writing. The UI must degrade
gracefully — showing zeros and an "event ended" state — rather than crashing or showing
nonsensical negative numbers.

**Source:** `lib/features/home/domain/usecases/compute_countdown.dart` (diff clamp),
`lib/features/home/presentation/providers/countdown_controller.dart` (timer cancel on elapsed).

---

## BR002 — Awards Loading / Empty / Error States

**Rule:** The awards list must handle four distinct states: loading (spinner shown), data
(carousel rendered), empty (empty-state message shown, no error), and error (error message +
Retry button shown). Tapping Retry calls `AwardsController.refresh()`, which sets
`AsyncLoading` then re-fetches.

**Rationale:** Network and stub failures are expected; the user must be able to recover
without restarting the app.

**Source:** `lib/features/home/presentation/providers/home_providers.dart`
(`AwardsController`), `lib/features/home/presentation/widgets/awards_carousel.dart`.

---

## BR003 — Kudos Feature Flag

**Rule:** The Kudos section on Home is **entirely hidden** (not collapsed, not greyed out)
when `kudosAvailableProvider` returns `false`. No placeholder or empty block is shown in its
place. When `true`, the full Kudos section (header, banner, badge, description, detail button)
is rendered.

**Rationale:** Kudos is a new capability for SAA 2025; its availability is controlled server-
side. Showing a broken or empty block when it is off degrades the Home screen without purpose.

**Source:** `lib/features/home/presentation/providers/home_providers.dart`
(`kudosAvailableProvider`), `lib/features/home/presentation/home_screen.dart` (conditional
render), `lib/features/home/presentation/widgets/kudos_section.dart`.

---

## BR004 — Notification Badge Visibility

**Rule:** A badge dot is shown on the bell icon in the Home header **only when** the unread
notification count is greater than 0. When the count is 0 (or the stream has not yet emitted),
no badge is shown.

**Rationale:** A persistent badge with a zero count creates noise; the badge must carry signal.

**Source:** `lib/features/home/presentation/providers/home_providers.dart`
(`unreadCountProvider`), `lib/features/home/presentation/widgets/home_header.dart`.

---

## BR005 — Single Sign-In Method (Google Only)

**Rule:** The app exposes exactly one authentication path: Google OAuth via Supabase. No
email/password login, no other OAuth providers, no anonymous access. The login screen renders
a single "Sign in with Google" button.

**Rationale:** Sun* employees authenticate via their corporate Google accounts; no other
identity provider is in scope for SAA 2025.

**Source:** `lib/features/auth/presentation/providers/auth_providers.dart`
(`authRepositoryProvider`), `lib/features/auth/presentation/screens/login_screen.dart`.

---

## BR006 — FAB Double-Tap Prevention

**Rule:** While a FAB-triggered navigation is in flight (`_fabBusy = true`), subsequent taps
on either FAB button are ignored. The flag resets to `false` once the pushed route is popped
(i.e., the user returns to Home). The same in-flight guard applies to the login button
(`LoginController.signInWithGoogle` returns early if `state.isLoading`).

**Rationale:** Rapid taps would push duplicate routes onto the navigation stack, creating
duplicate screens and broken back-stack state.

**Source:** `lib/features/home/presentation/home_screen.dart` (`_guardedPush`),
`lib/features/auth/presentation/providers/auth_providers.dart` (`LoginController`).

---

## BR007 — Default Language Vietnamese; Supported Languages vi/en/ja Only

**Rule:** The default locale is Vietnamese (`vi`). On first launch (no persisted preference),
all UI strings render in Vietnamese. The only accepted locale codes are `vi`, `en`, and `ja`.
Any attempt to set an unsupported locale is silently ignored — the current locale is
unchanged. The chosen locale is persisted in `SharedPreferences` and restored on next launch.

**Rationale:** The primary user base is Vietnamese-speaking Sun* employees. Restricting to
three locales keeps the ARB translation surface manageable.

**Source:** `lib/core/l10n/locale_controller.dart` (`kSupportedLocales`, `kDefaultLocale`,
`setLocale` guard).

---

## BR008 — Error Messages Must Be Localized

**Rule:** Auth failure messages shown to the user must be drawn from the ARB localization
files, not raw exception strings. The domain `Failure` types (`AuthCancelled`,
`NetworkFailure`, `AccountDisabled`, `UnknownFailure`) are mapped in the presentation layer
to localized strings. The raw `Failure.message` field is a non-localized diagnostic string
and must never be shown directly in the UI.

**Rationale:** Users may be running in any of the three supported locales; showing raw
exception text would be confusing and unprofessional.

**Source:** `lib/core/error/failures.dart` (Failure types),
`lib/features/auth/presentation/screens/login_screen.dart` (error mapping to l10n strings).
