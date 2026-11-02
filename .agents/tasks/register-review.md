# Register screen for Lapticon Flutter app

A new registration screen was added to the Lapticon Flutter app, allowing users to create accounts with email/password plus profile data (nombre, apellido, telefono, nacionalidad). The screen follows LoginScreen's visual pattern: same field decoration, spacing constants, error container, theme toggle, and state management approach. All seven required form fields are present with appropriate validators, password visibility toggles work on both password fields, and the signUp() call passes all parameters correctly. The listenManual pattern mirrors LoginScreen to redirect on AuthAuthenticated. The register route was added to app_router.dart with redirect logic allowing unauthenticated access, and LoginScreen's "register" TextButton now navigates properly.

**Watch for:** Phone field validator accepts formatting characters (spaces, parentheses, hyphens) but strips them before submission; this creates a mismatch between what the validator permits and what gets sent to the backend (confirmed). The "login" link uses context.pop() instead of context.go(AppRoutes.login), which assumes the user arrived from the login screen (likely).

**Verdict**: APPROVED

## High-level view

The register screen uses authStateProvider.signUp() directly, passing email, password, and four profile fields—no separate RegisterNotifier was introduced. The phone validator accepts human-friendly formatting ("+1 (555) 123-4567") but strips non-digit/non-plus characters before submission, so the backend receives only digits and optional leading plus. The redirect logic in app_router.dart treats /register as an auth route alongside /login, allowing unauthenticated users to reach it and redirecting authenticated users to /dashboard. The "login" link at the bottom uses context.pop() rather than context.go(AppRoutes.login), assuming the user navigated from the login screen; if a user lands directly on /register (deep link, bookmark), pop() may fail to navigate correctly.

<details>
<summary>Issues (2)</summary>

1. **Phone validator/submission mismatch** — Validator accepts spaces, parentheses, hyphens in phone numbers, but _submit() strips them before sending. If backend validation expects formatted input or logs show unexpected values, this mismatch is the cause. Either relax the validator to match submission format or keep formatting characters in submission.

2. **Login link navigation** — TextButton uses context.pop() instead of context.go(AppRoutes.login). If user arrives via deep link or bookmark (no navigation stack), pop() won't navigate to login. Use context.go(AppRoutes.login) for explicit navigation or verify that all entry paths to /register come from login screen.

</details>

<details>
<summary>Details</summary>

## Seven form fields with correct validators

The register screen includes all seven required fields: email, password, confirm password, nombre, apellido, telefono, and nacionalidad. Email validation checks for non-empty and regex pattern `^[^@]+@[^@]+\.[^@]+$`. Password validation requires minimum 6 characters. Confirm password validation checks non-empty and equality with password field. Nombre, apellido, and nacionalidad use a generic _validateRequired helper. Telefono uses _validateTelefono with regex `^[0-9+\s()-]{7,20}$`, accepting digits, plus sign, spaces, parentheses, and hyphens.

All validators match the review criteria except for a behavioral gap: the phone validator accepts formatting characters but _submit() strips them via `.replaceAll(RegExp(r'[^\d+]'), '')`. This means a user can type "+1 (555) 123-4567", pass validation, but the backend receives "+15551234567". If backend validation or logging expects the formatted version, this will cause a mismatch.

## Login link in RegisterScreen uses pop instead of go

The register screen's "login" link (TextButton after the register button) uses `context.pop()` instead of `context.go(AppRoutes.login)`. This works if the user navigated from login to register (via the "Regístrate" link), but fails if the user arrives at /register directly (deep link, bookmark, or initial route). In those cases, pop() may do nothing or close the app if the navigation stack is empty. LoginScreen uses context.go(AppRoutes.register) for its navigation, which is more robust. The register screen should match that pattern for consistency.

</details>

<details>
<summary>File map</summary>

**Modified files:**
- `lib/core/router/app_router.dart` — Added AppRoutes.register constant, imported RegisterScreen, added GoRoute for /register, updated redirect logic to treat /register as auth route alongside /login
- `lib/features/auth/presentation/screens/login_screen.dart` — Updated TextButton to navigate to AppRoutes.register via context.go(), resolving the TODO comment

**New files:**
- `lib/features/auth/presentation/screens/register_screen.dart` — New registration screen with 7 form fields (email, password, confirm password, nombre, apellido, telefono, nacionalidad), password visibility toggles, validators, signUp() integration, listenManual redirect pattern, error container, theme toggle, matching LoginScreen's visual style

</details>
