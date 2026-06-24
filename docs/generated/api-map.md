# SAA 2025 — External API Map

All external I/O runs through the auth feature's data layer. No other feature has live network calls today — awards, notifications, and kudos are served from in-memory stub repositories.

---

## Live APIs

### Google Sign-In (native iOS SDK)

**Package:** `google_sign_in ^6.2.2`
**Datasource:** `lib/features/auth/data/datasources/google_sign_in_data_source.dart`
**Repository:** `AuthRepositoryImpl` → `signInWithGoogle()`

| Operation | Call | Returns | Error path |
|---|---|---|---|
| Interactive sign-in | `GoogleSignIn.signIn()` → `account.authentication` | `GoogleTokens{idToken, accessToken?}` | `account == null` → `AuthCancelled`; `idToken == null` → `UnknownFailure`; no client id configured → `UnknownFailure` (guard prevents native crash on iOS) |
| Sign-out | `GoogleSignIn.signOut()` | `void` | Ignored (best-effort; Supabase session is authoritative) |

**Client ID config:**
- `iosClientId` → `Env.googleIosClientId` (from `--dart-define` / `.env` `GOOGLE_IOS_CLIENT_ID`; also set in `Info.plist` as `GIDClientID`)
- `serverClientId` → `Env.googleWebClientId` (from `GOOGLE_CLIENT_ID`; audience accepted by Supabase)
- Scopes requested: `['email', 'profile']`

---

### Supabase Auth

**Package:** `supabase_flutter ^2.8.0`
**Datasource:** `lib/features/auth/data/datasources/supabase_auth_data_source.dart`
**Repository:** `AuthRepositoryImpl` (live) / `FakeAuthRepository` (demo/test)

| Operation | Supabase call | Returns | Error path |
|---|---|---|---|
| Sign in with Google idToken | `GoTrueClient.signInWithIdToken(provider: google, idToken, accessToken?)` | `AuthUser` (via `AuthUserModel.fromSupabase`) | `res.user == null` → `AuthException`; `AuthApiException` 400/403 → `AccountDisabled`; `SocketException` → `NetworkFailure`; other → `UnknownFailure` |
| Sign out | `GoTrueClient.signOut()` | `void` | Propagates as `UnknownFailure` if thrown |
| Watch auth state (stream) | `GoTrueClient.onAuthStateChange` | `Stream<AuthUser?>` — null on sign-out | Stream errors propagate to `authStateProvider.hasError` → router redirects to `/login` |
| Session restore (cold start) | Handled by `supabase_flutter` internally on `Supabase.initialize()` with `SecureSessionStorage` | Triggers `onAuthStateChange` emit | Transparent; `watchAuthState()` yields the restored user |

**Endpoint config:**
- URL: `Env.supabaseUrl` (`SUPABASE_URL`)
- Publishable key: `Env.supabasePublishableKey` (`SUPABASE_PUBLISHABLE_KEY`)
- Session storage: `SecureSessionStorage` (Keychain, key `supabase.session`)

---

## Stub / Mock APIs (no live endpoint)

These repository interfaces exist in domain but have no real HTTP implementation yet.

| Repository interface | Current implementation | Data source | Status |
|---|---|---|---|
| `AwardsRepository` | `StubAwardsRepository` / `FakeAwardsRepository` | `HomeMockData.awards` (static list in `home_mock_data.dart`) | Stub — no live endpoint |
| `NotificationRepository` | `StubNotificationRepository` | In-memory `Stream<int>` (periodic unread count) | Stub — no live endpoint |
| `KudosConfigRepository` | `StubKudosConfigRepository` | Hardcoded `bool` flag | Stub — no live endpoint |

When real backends for awards/notifications/kudos are ready, only the `data/repositories/` implementations need replacing — domain interfaces and presentation providers are unchanged.

---

## Fallback (demo / CI mode)

When `SupabaseInit.isInitialized == false` OR `Env.hasGoogleConfig == false`, `authRepositoryProvider` returns `FakeAuthRepository`. No external network calls are made. The login button succeeds immediately with a hardcoded fake user (`sunner@sun-asterisk.com`). This path is used in all 91 offline tests and in credential-free local runs.
