# User Stories — SAA 2025 Flutter App

> Derived from implemented source (F001 auth, F002 Home). No fabricated behavior.
> Actor: **Sunner** (Sun* employee using the SAA 2025 app).

---

## F001 — Login / Auth

### US001 Sign in with Google
As a Sunner, I want to tap "Sign in with Google" so that I can authenticate with my Sun* Google account and access the app.

### US002 Auto-login on relaunch
As a Sunner, I want the app to restore my session automatically when I relaunch it so that I do not have to sign in again after a previous login.

### US003 See loading state during sign-in
As a Sunner, I want to see a loading indicator while Google sign-in is in progress so that I know the app is working.

### US004 See error on sign-in failure
As a Sunner, I want to see a localized error message when sign-in fails (network error, disabled account, or unknown error) so that I understand why I could not log in.

### US005 Double-tap prevention on login button
As a Sunner, I want the login button to be locked while a sign-in is in progress so that I cannot trigger duplicate sign-in requests.

### US006 Sign out
As a Sunner, I want to sign out so that my session is cleared and I am returned to the login screen.

### US007 Switch display language
As a Sunner, I want to switch the app language between Vietnamese, English, and Japanese so that I can use the app in my preferred language.

### US008 Persist language choice
As a Sunner, I want my language preference to be saved so that my chosen language is still active the next time I open the app.

### US009 Default language Vietnamese
As a Sunner who has not set a language preference, I want the app to default to Vietnamese so that the most common use case works without any setup.

### US010 Redirect to login when unauthenticated
As a Sunner who is not logged in, I want any attempt to access a protected screen to redirect me to the login screen so that my data is not exposed.

### US011 Redirect to access-denied on 403
As a Sunner whose account has an authorization error (403), I want to be shown an access-denied screen so that I understand why I cannot proceed.

---

## F002 — Home

### US012 View event hero with countdown
As a Sunner, I want to see the SAA 2025 key visual, event date, venue, and a real-time countdown (days/hours/minutes) so that I know how much time remains until the event.

### US013 See elapsed state when countdown is past
As a Sunner viewing the app after 26 December 2025, I want to see an "event ended" indicator with zeroed countdown values so that the app does not show negative or incorrect time remaining.

### US014 Browse awards carousel
As a Sunner, I want to scroll horizontally through the SAA 2025 award cards so that I can see which awards are available.

### US015 See loading state for awards
As a Sunner, I want to see a loading indicator while awards data is being fetched so that I know the app is working.

### US016 See empty state for awards
As a Sunner, I want to see an empty-state message when no awards are available so that I understand the list is not broken.

### US017 Retry after awards error
As a Sunner, I want to see an error message with a Retry button when awards fail to load so that I can attempt to reload without restarting the app.

### US018 View Kudos highlight
As a Sunner, I want to see the Sun* Kudos section on the Home screen (when the feature is enabled) so that I can learn about the Kudos recognition program.

### US019 Kudos section hidden when unavailable
As a Sunner, I want the Kudos section to be completely hidden when the Kudos feature is disabled so that I am not shown an empty or broken block.

### US020 See notification badge
As a Sunner with unread notifications, I want to see a badge dot on the bell icon so that I know there are new notifications.

### US021 Open Kudos detail via Home
As a Sunner, I want to tap "Chi tiết" in the Kudos section so that I am taken to the Kudos detail screen.

### US022 Open award detail via carousel
As a Sunner, I want to tap "Chi tiết →" on an award card so that I am taken to the Award Detail screen.

### US023 Navigate via bottom navigation bar
As a Sunner, I want to tap the SAA 2025 / Awards / Kudos / Profile tabs in the bottom navigation bar so that I can switch between the main sections of the app.

### US024 Open search from header
As a Sunner, I want to tap the search icon in the header so that I can navigate to the Search screen.

### US025 Open notifications from header
As a Sunner, I want to tap the bell icon in the header so that I can navigate to the Notifications screen.

### US026 Send Kudos via FAB
As a Sunner, I want to tap the FAB pencil button so that I am taken to the Write Kudo screen.

### US027 Navigate to Kudos feed via FAB
As a Sunner, I want to tap the FAB Kudos button so that I am taken to the Kudos feed.

### US028 FAB double-tap prevention
As a Sunner, I want rapid double-taps on the FAB to be ignored so that I do not accidentally open the destination screen twice.

### US029 Open About Award
As a Sunner, I want to tap the "ABOUT AWARD" button in the hero section so that I can learn more about the awards program.

### US030 Open About Kudos
As a Sunner, I want to tap the "ABOUT KUDOS" button in the hero section so that I can learn more about the Kudos program.

### US031 Switch language from Home header
As a Sunner, I want to use the language switcher in the Home header so that I can change the display language without leaving the Home screen.
