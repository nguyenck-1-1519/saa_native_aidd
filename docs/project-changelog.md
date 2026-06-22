# Changelog — SAA 2025

Định dạng: [Conventional Commits](https://www.conventionalcommits.org/). Mới nhất ở trên.

---

## [1.0.0+1] — 2026-06-22

### feat: bootstrap Flutter MVP + Login (Supabase Google OAuth, Clean Architecture, iOS-first, i18n VN/EN/JA, VSCode multi-env, 49 tests)

**Chi tiết:**

- Khởi tạo project Flutter `saa_2025` (SDK ^3.8.1, FVM).
- Clean Architecture: `core/` + `features/auth/{domain,data,presentation}` + `features/home/` placeholder.
- F001 — Login via Google OAuth:
  - `google_sign_in` (native) → `supabase.auth.signInWithIdToken`.
  - Auto-login (session persist), loading state, double-click prevention.
  - Error handling: `NetworkFailure`, `AuthCancelled`, `AccountDisabled`, `UnknownFailure`.
- go_router auth guard: redirect `/login` ↔ `/home` theo `authStateProvider`.
- Riverpod: `authStateProvider` (stream), `loginControllerProvider` (AsyncNotifier), `localeControllerProvider`.
- i18n: flutter gen-l10n, ARB cho vi/en/ja, persist lựa chọn (SharedPreferences).
- Multi-env: `config/{development,staging,production}.json` + `.env` (gitignored).
- VSCode: 4 launch configs (`SAA · Debug (dev)`, `SAA · Staging (profile)`, `SAA · Production (release)`, `SAA · Staging (debug attach)`).
- `FakeAuthRepository`: chạy offline, không cần credentials thật.
- Test suite: 49 tests (unit + widget + e2e), `fvm flutter analyze` → no issues.
- iOS deployment target: 15.0.
