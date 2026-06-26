# F006 Profile — spec draft (minimal)

> Provenance draft. Authoritative visual values come from MoMorph at implement-time
> (`momorph-implement-design`). This file is the planning-stage contract, not final spec.
> Feature code: **F006**. Data: **local stub only** (no backend), consistent with F002–F004.

## Screen refs (fileKey 9ypp4enmFmdK3YAFJLIu6C — iOS)

- Profile bản thân (self):  `hSH7L8doXB` → https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/hSH7L8doXB
- Profile người khác (other): `bEpdheM0yU` → https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/bEpdheM0yU

**Model as ONE `ProfileScreen` + `isSelf` branch** (NOT two files — DRY). Self shows edit/settings
affordances; other hides them. Confirm exact affordance diff at runtime via design fetch.

## Functional requirements (draft — confirm/extend at design-fetch time)

- FR1  Profile tab (branch 3) renders the real self profile (replaces PlaceholderScreen).
- FR2  Header: avatar, name, role/CECV, department. Avatar null → grey placeholder (keep F003/F004 pattern).
- FR3  Stats block: kudos received, kudos sent, hearts received, hero level/badges (reuse `KudosStats`).
- FR4  Awards / danh hiệu section (reuse F003 `AwardDetail` shape — compose, do not duplicate).
- FR5  Recent kudos received section (reuse F004 kudo entities; tap → existing kudo detail route).
- FR6  Self vs other differ by `isSelf`: self = edit/settings affordances visible; other = hidden.
- FR7  Entry to "other profile" from a kudo sender/recipient tap (View kudo / cards) where feasible.
- FR8  Self profile reads logged-in identity from `authStateProvider` (current `AuthUser`).
- FR9  Loading / error / empty states for each async section (mirror F004 controller pattern).
- FR10 i18n: every UI string in app_vi / app_en / app_ja ARB. Default `vi`.

## Reuse map (compose, DO NOT duplicate)

| Need | Reuse from | Notes |
|------|-----------|-------|
| Current user identity | `lib/features/auth` — `AuthUser`, `authStateProvider` | self header source |
| Kudos counts / hearts | `lib/features/kudos/domain/entities/kudos_stats.dart` (`KudosStats`) | stats block |
| Recent kudos received | `lib/features/kudos/domain/entities/` (`Kudo`, `KudoDetail`, `KudoRecipient`) | list + tap-through |
| Kudo detail route | `Routes.kudoDetailPath(id)` (`app_router.dart`) | tap recent kudo |
| Awards / danh hiệu | `lib/features/awards/domain/entities/award_detail.dart` (`AwardDetail`) | awards section |
| Stub repo pattern | `stub_kudos_stats_repository.dart` + `kudos_mock_data.dart` | profile stub source |
| Provider pattern | `kudos_providers.dart` (Provider DI + AsyncNotifier/FutureProvider) | profile providers |
| Async UI pattern | `kudos_route_wrappers.dart` (`.when` loading/error/data) | route wrapper |
| Grey-avatar fallback | F003/F004 null-S3 placeholder convention | avatars currently null |

## ProfileData aggregate (Track B contract — provisional shape)

`ProfileData { ProfileUser user; KudosStats stats; List<ProfileAward> awards; List<RecentKudo> recentKudos; }`
- `ProfileUser { id, name, role, department, avatarUrl? , heroLevel?, badges? }` — NEW (profile owns identity-for-display).
- `ProfileAward` / `RecentKudo` — prefer composing existing entities (`AwardDetail`, `Kudo`). Only add a thin
  profile-view value object if existing entities lack a field the design needs (decide at design-fetch).

## Defer list (NOT in F006)

- Real backend / persistence (stub only).
- Edit-profile form submission (affordance may render but is non-functional stub, like Write-Kudo onSubmit).
- Settings screen contents (affordance only; target is out of scope unless design shows inline).
- Follow / message / social actions on other profile (unless design mandates — confirm).
- Avatar upload, image picker.

## Open items for design-fetch (resolve before/at takumi)

- Exact self-vs-other affordance delta (edit button? settings gear? both?).
- Whether "other profile" needs a distinct userId-keyed data source or reuses kudo sender/recipient data.
- Whether hero level/badges are a distinct visual block or part of stats.
- Does design show recent-kudos-SENT in addition to received?
