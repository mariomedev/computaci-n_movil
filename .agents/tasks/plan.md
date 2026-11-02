# Implementation Plan: Register Screen

## Overview
Create a complete register screen for the Lapticon Flutter app that mirrors the visual design and patterns from LoginScreen. The screen will collect user registration data (email, password, nombre, apellido, telefono, nacionalidad) and call the existing `authStateProvider.signUp()` method.

## Design Decisions

### Field Order and Layout
Register fields will be presented in this order: nombre, apellido, email, telefono, nacionalidad, contraseña, confirmar contraseña. This groups personal info first, then credentials, following a natural registration flow.

### Password Visibility Toggle
Each password field (contraseña and confirmar contraseña) will have an inline suffixIcon toggle button to show/hide the password. This follows mobile UX best practices and matches common Flutter patterns. The obscureText boolean will be managed in component state with separate booleans for each field.

### Validation Strategy
All fields validate on form submission, not on-change, to avoid annoying users mid-typing. Validation rules:
- nombre, apellido, telefono, nacionalidad: required (non-empty after trim)
- email: required + regex pattern `^[^@]+@[^@]+\.[^@]+$`
- contraseña: required + minimum 6 characters (matching Firebase default)
- confirmar contraseña: required + must match contraseña exactly

### No Shared Widgets
The project uses inline InputDecoration throughout (LoginScreen has no shared CustomTextField). RegisterScreen will follow this pattern for consistency — inline decoration for all fields.

### Router Integration
The register route will follow the same redirect logic as login: authenticated users accessing `/register` redirect to `/dashboard`. The router's existing `redirect` function already handles this pattern for login routes; register will be treated the same way by adding it to the isLoginRoute check.

---

## Implementation Steps

- [ ] 1. Add the `/register` route constant and route definition in app_router.dart. Update the `appRouterRedirect` and `AppRouter.evaluateRedirect` functions to treat `/register` like `/login` (i.e., `isLoginRoute` check becomes `isLoginRoute || isRegisterRoute`). Update the router's `redirect` callback inside `createRouter` with the same logic.
      Files: `/Users/mariomelo/Documents/Proyectos personales/computacion_movil/lib/core/router/app_router.dart`
      Verify: Run `flutter analyze` and confirm no errors in lib/core/router/app_router.dart

- [ ] 2. Create the RegisterScreen widget in `/Users/mariomelo/Documents/Proyectos personales/computacion_movil/lib/features/auth/presentation/screens/register_screen.dart`. The widget structure mirrors LoginScreen exactly:
      - ConsumerStatefulWidget with dispose cleanup for all 7 TextEditingControllers (nombre, apellido, email, telefono, nacionalidad, password, confirmPassword)
      - initState with listenManual on authStateProvider: navigate to AppRoutes.dashboard when AuthAuthenticated
      - State booleans: _obscurePassword and _obscureConfirmPassword (both start true)
      - Form with GlobalKey, 7 TextFormField widgets (all with full InputDecoration matching LoginScreen's border/color/labelStyle/style patterns), each with validator
      - nombre: prefixIcon Icons.person_outlined, validator checks non-empty
      - apellido: prefixIcon Icons.person_outlined, validator checks non-empty
      - email: prefixIcon Icons.email_outlined, keyboardType emailAddress, validator checks non-empty + regex
      - telefono: prefixIcon Icons.phone_outlined, keyboardType phone, validator checks non-empty
      - nacionalidad: prefixIcon Icons.public_outlined, validator checks non-empty
      - contraseña: prefixIcon Icons.lock_outlined, obscureText: _obscurePassword, suffixIcon: IconButton toggles _obscurePassword, validator checks non-empty + length >= 6
      - confirmar contraseña: prefixIcon Icons.lock_outlined, obscureText: _obscureConfirmPassword, suffixIcon: IconButton toggles _obscureConfirmPassword, validator checks non-empty + matches contraseña
      - Error container (same design as LoginScreen) shows when authState is AuthError
      - ElevatedButton "Registrarse" height 50, calls _submit when not loading, shows CircularProgressIndicator when AuthLoading
      - TextButton "¿Ya tienes cuenta? Inicia sesión" navigates to AppRoutes.login
      - _ThemeToggleButton positioned top-right (copy from LoginScreen)
      - _submit method: clears error via authStateProvider.notifier.clearError(), validates form, calls authStateProvider.notifier.signUp with all 6 params
      Files: `/Users/mariomelo/Documents/Proyectos personales/computacion_movil/lib/features/auth/presentation/screens/register_screen.dart`
      Verify: Run `flutter analyze` and confirm no errors in lib/features/auth/presentation/screens/register_screen.dart

- [ ] 3. Update LoginScreen's "Regístrate" TextButton to navigate to AppRoutes.register using `context.go(AppRoutes.register)`. Remove the TODO comment.
      Files: `/Users/mariomelo/Documents/Proyectos personales/computacion_movil/lib/features/auth/presentation/screens/login_screen.dart`
      Verify: Run `flutter analyze` and confirm no errors in lib/features/auth/presentation/screens/login_screen.dart

- [ ] 4. Run final verification: `flutter analyze` on the entire project and confirm zero errors or warnings in the auth and router modules.
      Files: N/A (verification only)
      Verify: Run `cd /Users/mariomelo/Documents/Proyectos\ personales/computacion_movil && flutter analyze` and confirm output shows "No issues found!"
