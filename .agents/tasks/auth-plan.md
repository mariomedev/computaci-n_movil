# Implementation Plan: Auth Feature - Firebase/Lapticon Backend Integration

## Context Summary

### Existing Architecture
- **Pattern**: Clean Architecture with domain/infrastructure separation
- **State Management**: flutter_riverpod
- **HTTP Client**: `http` package (ApiClient stub exists but is unimplemented)
- **Error Handling**: Either<ItemError, T> using `dart_either`
- **Failure Mapping**: ItemError (infrastructure) → Failure (domain use cases)
- **DI**: GetIt (currently empty `injection_container.dart`)
- **Naming**: Simple class names without DTOs suffix (e.g., `UserMapper.fromMap`)

### Backend Details (from Postman collection)
- **Firebase Auth Login**: `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAuh64b_I2OtC7KYuubCVx9plEe2pojp2M`
- **Base URL**: `{{base_url}}` (needs to be configured in AppConfig)
- **Auth Flow**: Firebase login → get idToken → use Bearer token for API calls
- **Profile endpoint**: POST `/api/users/register` (creates/updates profile)
- **Get profile**: GET `/api/users/{{uid}}`

### Existing Supabase Implementation (DO NOT MODIFY)
- `AuthRemoteDataSourceImpl` in `infrastructure/data/` uses SupabaseClient
- Keep this file untouched - we're creating a NEW parallel implementation for Firebase/Lapticon

### Gap Analysis
1. **ApiClient** is a stub with UnimplementedError - need working HTTP client
2. **No base URL** configured in AppConfig
3. **UserEntity** is too simple - Lapticon needs nombre, apellido, telefono, nacionalidad
4. **AuthSession** exists but Firebase returns different token structure (idToken, localId, refreshToken, expiresIn)
5. **No profile management** in existing domain layer

---

## Implementation Plan

### PHASE 1: Fix GoogleFonts error and Core Infrastructure

- [ ] 1. Fix GoogleFonts import error in `app_text_styles.dart`
      **What**: The error "Undefined name 'GoogleFonts'" is caused by missing import. The google_fonts package is in pubspec.yaml but line 6 fails.
      **Files**: `/Users/mariomelo/Documents/Proyectos personales/computacion_movil/lib/core/theme/app_text_styles.dart`
      **Fix**: The import already exists at line 2. This is actually a Flutter analyzer cache issue. The code is correct.
      **Verify**: Run `flutter pub get && flutter analyze lib/core/theme/app_text_styles.dart` - should show no errors.

- [ ] 2. Implement ApiClient with http package
      **What**: Replace the stub implementation with working GET/POST/PUT methods using the `http` package. Include Authorization header support, JSON encoding/decoding, and proper error mapping to ItemError.
      **Files**: `/Users/mariomelo/Documents/Proyectos personales/computacion_movil/lib/core/network/api_client.dart`
      **Details**:
      - Constructor takes `baseUrl` and optional `http.Client`
      - GET: build URI with query params, add headers, handle response
      - POST/PUT: JSON encode body, set Content-Type: application/json
      - DELETE: similar to GET but DELETE method
      - Error handling: catch SocketException → NetworkFailure, TimeoutException → timeout error, non-200 status → ServerFailure with response body
      - Parse JSON response and call `fromJson` if provided
      - Return Either<ItemError, T>
      **Verify**: Create a simple test in `test/core/network/api_client_test.dart` that mocks http.Client and verifies GET returns Right with parsed data. Run `flutter test test/core/network/api_client_test.dart`.

- [ ] 3. Add base URL and Firebase API key to AppConfig
      **What**: Add static constants for Lapticon backend base URL and Firebase Web API key (from google-services.json).
      **Files**: `/Users/mariomelo/Documents/Proyectos personales/computacion_movil/lib/core/config/app_config.dart`
      **Details**:
      ```dart
      class AppConfig {
        AppConfig._();
        
        // Firebase
        static const String firebaseApiKey = 'AIzaSyAuh64b_I2OtC7KYuubCVx9plEe2pojp2M';
        static const String firebaseAuthUrl = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword';
        
        // Lapticon Backend
        static const String lapticonBaseUrl = 'https://your-backend-url.com'; // TODO: Replace with actual URL
        
        // Supabase (existing)
        static const String supabaseUrl = 'https://...'; // Keep existing if present
        static const String supabaseAnonKey = '...'; // Keep existing if present
      }
      ```
      **Verify**: Run `flutter analyze lib/core/config/app_config.dart` - should compile without errors.

---

### PHASE 2: Domain Layer - New Entities for Lapticon

- [ ] 4. Create FirebaseAuthToken entity for Firebase Auth response
      **What**: Entity to hold Firebase authentication token data (idToken, localId, refreshToken, expiresIn).
      **Files**: `/Users/mariomelo/Documents/Proyectos personales/computacion_movil/lib/features/auth/domain/entities/firebase_auth_token.dart`
      **Details**:
      ```dart
      class FirebaseAuthToken {
        final String idToken;
        final String localId;
        final String refreshToken;
        final int expiresIn;
        
        const FirebaseAuthToken({
          required this.idToken,
          required this.localId,
          required this.refreshToken,
          required this.expiresIn,
        });
        
        DateTime get expiresAt => DateTime.now().add(Duration(seconds: expiresIn));
        bool get isExpired => DateTime.now().isAfter(expiresAt);
        
        FirebaseAuthToken copyWith({...});
      }
      ```
      **Verify**: Import in a test file and instantiate - should compile.

- [ ] 5. Create LapticonUser entity with full profile fields
      **What**: Entity matching Lapticon's user profile schema (uid, email, nombre, apellido, telefono, nacionalidad).
      **Files**: `/Users/mariomelo/Documents/Proyectos personales/computacion_movil/lib/features/auth/domain/entities/lapticon_user.dart`
      **Details**:
      ```dart
      class LapticonUser {
        final String uid;
        final String email;
        final String nombre;
        final String apellido;
        final String telefono;
        final String nacionalidad;
        
        const LapticonUser({
          required this.uid,
          required this.email,
          required this.nombre,
          required this.apellido,
          required this.telefono,
          required this.nacionalidad,
        });
        
        LapticonUser copyWith({...});
        
        @override
        bool operator ==(Object other) => identical(this, other) || 
          other is LapticonUser && other.uid == uid;
        
        @override
        int get hashCode => uid.hashCode;
      }
      ```
      **Verify**: Run `flutter analyze lib/features/auth/domain/entities/lapticon_user.dart`.

- [ ] 6. Create RegisterProfileParams for profile registration
      **What**: Parameters for POST /api/users/register endpoint.
      **Files**: `/Users/mariomelo/Documents/Proyectos personales/computacion_movil/lib/features/auth/domain/entities/register_profile_params.dart`
      **Details**:
      ```dart
      class RegisterProfileParams {
        final String nombre;
        final String apellido;
        final String telefono;
        final String nacionalidad;
        
        const RegisterProfileParams({
          required this.nombre,
          required this.apellido,
          required this.telefono,
          required this.nacionalidad,
        });
        
        RegisterProfileParams copyWith({...});
      }
      ```
      **Verify**: Compile check with `flutter analyze`.

- [ ] 7. Update entities barrel file to export new entities
      **What**: Add exports for FirebaseAuthToken, LapticonUser, and RegisterProfileParams to the existing entities.dart barrel file.
      **Files**: `/Users/mariomelo/Documents/Proyectos personales/computacion_movil/lib/features/auth/domain/entities/entities.dart`
      **Details**: Append these lines:
      ```dart
      export 'firebase_auth_token.dart';
      export 'lapticon_user.dart';
      export 'register_profile_params.dart';
      ```
      **Verify**: Run `flutter analyze lib/features/auth/domain/entities/entities.dart`.

---

### PHASE 3: Domain Layer - Repository Interface

- [ ] 8. Create LapticonAuthRepository interface
      **What**: New repository interface specifically for Firebase/Lapticon auth flow, separate from existing AuthRepository.
      **Files**: `/Users/mariomelo/Documents/Proyectos personales/computacion_movil/lib/features/auth/domain/repositories/lapticon_auth_repository.dart`
      **Details**:
      ```dart
      import 'package:dart_either/dart_either.dart';
      import 'package:computacion_movil/core/errors/item_error.dart';
      import 'package:computacion_movil/features/auth/domain/entities/entities.dart';
      
      abstract class LapticonAuthRepository {
        /// Sign in with Firebase Auth
        Future<Either<ItemError, FirebaseAuthToken>> signInWithEmailPassword(LoginParams params);
        
        /// Register or update user profile in Lapticon backend
        Future<Either<ItemError, LapticonUser>> registerProfile(
          String idToken,
          RegisterProfileParams params,
        );
        
        /// Get user profile from Lapticon backend
        Future<Either<ItemError, LapticonUser>> getProfile(String idToken, String uid);
        
        /// Sign out (clear local session)
        Future<Either<ItemError, bool>> signOut();
        
        /// Get current cached token
        Future<Either<ItemError, FirebaseAuthToken?>> getCurrentToken();
      }
      ```
      **Verify**: Run `flutter analyze lib/features/auth/domain/repositories/lapticon_auth_repository.dart`.

---

### PHASE 4: Domain Layer - Use Cases

- [ ] 9. Create SignInWithFirebaseUseCase
      **What**: Use case that validates credentials and calls repository.signInWithEmailPassword.
      **Files**: `/Users/mariomelo/Documents/Proyectos personales/computacion_movil/lib/features/auth/domain/usecases/sign_in_with_firebase_use_case.dart`
      **Details**:
      ```dart
      import 'package:dart_either/dart_either.dart';
      import 'package:computacion_movil/core/errors/failures.dart';
      import 'package:computacion_movil/features/auth/domain/entities/entities.dart';
      import 'package:computacion_movil/features/auth/domain/repositories/lapticon_auth_repository.dart';
      
      class SignInWithFirebaseUseCase {
        final LapticonAuthRepository _repository;
        
        const SignInWithFirebaseUseCase({required LapticonAuthRepository repository})
          : _repository = repository;
        
        Future<Either<Failure, FirebaseAuthToken>> execute(LoginParams params) async {
          // Validate email format
          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
          if (!emailRegex.hasMatch(params.username)) {
            return const Left(
              ValidationFailure(message: 'Email debe tener formato válido'),
            );
          }
          
          // Validate password not empty
          if (params.password.trim().isEmpty) {
            return const Left(
              ValidationFailure(message: 'Contraseña es requerida'),
            );
          }
          
          final result = await _repository.signInWithEmailPassword(params);
          return result.fold(
            ifLeft: (error) => Left(toServerFailure(error)),
            ifRight: (token) => Right(token),
          );
        }
      }
      ```
      **Verify**: Run `flutter analyze lib/features/auth/domain/usecases/sign_in_with_firebase_use_case.dart`.

- [ ] 10. Create RegisterProfileUseCase
      **What**: Use case to register/update user profile after Firebase login.
      **Files**: `/Users/mariomelo/Documents/Proyectos personales/computacion_movil/lib/features/auth/domain/usecases/register_profile_use_case.dart`
      **Details**:
      ```dart
      import 'package:dart_either/dart_either.dart';
      import 'package:computacion_movil/core/errors/failures.dart';
      import 'package:computacion_movil/features/auth/domain/entities/entities.dart';
      import 'package:computacion_movil/features/auth/domain/repositories/lapticon_auth_repository.dart';
      
      class RegisterProfileUseCase {
        final LapticonAuthRepository _repository;
        
        const RegisterProfileUseCase({required LapticonAuthRepository repository})
          : _repository = repository;
        
        Future<Either<Failure, LapticonUser>> execute({
          required String idToken,
          required RegisterProfileParams params,
        }) async {
          // Validate fields not empty
          if (params.nombre.trim().isEmpty) {
            return const Left(ValidationFailure(message: 'Nombre es requerido'));
          }
          if (params.apellido.trim().isEmpty) {
            return const Left(ValidationFailure(message: 'Apellido es requerido'));
          }
          if (params.telefono.trim().isEmpty) {
            return const Left(ValidationFailure(message: 'Teléfono es requerido'));
          }
          if (params.nacionalidad.trim().isEmpty) {
            return const Left(ValidationFailure(message: 'Nacionalidad es requerida'));
          }
          
          final result = await _repository.registerProfile(idToken, params);
          return result.fold(
            ifLeft: (error) => Left(toServerFailure(error)),
            ifRight: (user) => Right(user),
          );
        }
      }
      ```
      **Verify**: Run `flutter analyze lib/features/auth/domain/usecases/register_profile_use_case.dart`.

- [ ] 11. Create GetProfileUseCase
      **What**: Use case to fetch user profile from Lapticon backend.
      **Files**: `/Users/mariomelo/Documents/Proyectos personales/computacion_movil/lib/features/auth/domain/usecases/get_profile_use_case.dart`
      **Details**:
      ```dart
      import 'package:dart_either/dart_either.dart';
      import 'package:computacion_movil/core/errors/failures.dart';
      import 'package:computacion_movil/features/auth/domain/entities/entities.dart';
      import 'package:computacion_movil/features/auth/domain/repositories/lapticon_auth_repository.dart';
      
      class GetProfileUseCase {
        final LapticonAuthRepository _repository;
        
        const GetProfileUseCase({required LapticonAuthRepository repository})
          : _repository = repository;
        
        Future<Either<Failure, LapticonUser>> execute({
          required String idToken,
          required String uid,
        }) async {
          final result = await _repository.getProfile(idToken, uid);
          return result.fold(
            ifLeft: (error) => Left(toServerFailure(error)),
            ifRight: (user) => Right(user),
          );
        }
      }
      ```
      **Verify**: Run `flutter analyze lib/features/auth/domain/usecases/get_profile_use_case.dart`.

- [ ] 12. Create SignOutUseCase
      **What**: Use case to sign out (clear local session/token).
      **Files**: `/Users/mariomelo/Documents/Proyectos personales/computacion_movil/lib/features/auth/domain/usecases/sign_out_use_case.dart`
      **Details**:
      ```dart
      import 'package:dart_either/dart_either.dart';
      import 'package:computacion_movil/core/errors/failures.dart';
      import 'package:computacion_movil/features/auth/domain/repositories/lapticon_auth_repository.dart';
      
      class SignOutUseCase {
        final LapticonAuthRepository _repository;
        
        const SignOutUseCase({required LapticonAuthRepository repository})
          : _repository = repository;
        
        Future<Either<Failure, bool>> execute() async {
          final result = await _repository.signOut();
          return result.fold(
            ifLeft: (error) => Left(toServerFailure(error)),
            ifRight: (success) => Right(success),
          );
        }
      }
      ```
      **Verify**: Run `flutter analyze lib/features/auth/domain/usecases/sign_out_use_case.dart`.

---

### PHASE 5: Infrastructure Layer - Data Models

- [ ] 13. Create FirebaseAuthTokenModel (DTO)
      **What**: JSON serializable model for Firebase Auth API response.
      **Files**: `/Users/mariomelo/Documents/Proyectos personales/computacion_movil/lib/features/auth/infrastructure/models/firebase_auth_token_model.dart`
      **Details**:
      ```dart
      import 'package:computacion_movil/features/auth/domain/entities/entities.dart';
      
      class FirebaseAuthTokenModel {
        final String idToken;
        final String localId;
        final String refreshToken;
        final String expiresIn; // Note: comes as String from API
        
        const FirebaseAuthTokenModel({
          required this.idToken,
          required this.localId,
          required this.refreshToken,
          required this.expiresIn,
        });
        
        factory FirebaseAuthTokenModel.fromJson(Map<String, dynamic> json) {
          return FirebaseAuthTokenModel(
            idToken: json['idToken'] as String,
            localId: json['localId'] as String,
            refreshToken: json['refreshToken'] as String,
            expiresIn: json['expiresIn'] as String,
          );
        }
        
        Map<String, dynamic> toJson() {
          return {
            'idToken': idToken,
            'localId': localId,
            'refreshToken': refreshToken,
            'expiresIn': expiresIn,
          };
        }
        
        FirebaseAuthToken toEntity() {
          return FirebaseAuthToken(
            idToken: idToken,
            localId: localId,
            refreshToken: refreshToken,
            expiresIn: int.parse(expiresIn),
          );
        }
      }
      ```
      **Verify**: Run `flutter analyze lib/features/auth/infrastructure/models/firebase_auth_token_model.dart`.

- [ ] 14. Create LapticonUserModel (DTO)
      **What**: JSON serializable model for Lapticon user profile API responses.
      **Files**: `/Users/mariomelo/Documents/Proyectos personales/computacion_movil/lib/features/auth/infrastructure/models/lapticon_user_model.dart`
      **Details**:
      ```dart
      import 'package:computacion_movil/features/auth/domain/entities/entities.dart';
      
      class LapticonUserModel {
        final String uid;
        final String email;
        final String nombre;
        final String apellido;
        final String telefono;
        final String nacionalidad;
        
        const LapticonUserModel({
          required this.uid,
          required this.email,
          required this.nombre,
          required this.apellido,
          required this.telefono,
          required this.nacionalidad,
        });
        
        factory LapticonUserModel.fromJson(Map<String, dynamic> json) {
          return LapticonUserModel(
            uid: json['uid'] as String? ?? json['_id'] as String,
            email: json['email'] as String,
            nombre: json['nombre'] as String,
            apellido: json['apellido'] as String,
            telefono: json['telefono'] as String,
            nacionalidad: json['nacionalidad'] as String,
          );
        }
        
        Map<String, dynamic> toJson() {
          return {
            'nombre': nombre,
            'apellido': apellido,
            'telefono': telefono,
            'nacionalidad': nacionalidad,
          };
        }
        
        LapticonUser toEntity() {
          return LapticonUser(
            uid: uid,
            email: email,
            nombre: nombre,
            apellido: apellido,
            telefono: telefono,
            nacionalidad: nacionalidad,
          );
        }
      }
      ```
      **Verify**: Run `flutter analyze lib/features/auth/infrastructure/models/lapticon_user_model.dart`.

---

### PHASE 6: Infrastructure Layer - Data Sources

- [ ] 15. Create LapticonAuthDataSource interface
      **What**: Abstract interface for auth data source operations.
      **Files**: `/Users/mariomelo/Documents/Proyectos personales/computacion_movil/lib/features/auth/infrastructure/datasources/lapticon_auth_data_source.dart`
      **Details**:
      ```dart
      import 'package:dart_either/dart_either.dart';
      import 'package:computacion_movil/core/errors/item_error.dart';
      import 'package:computacion_movil/features/auth/domain/entities/entities.dart';
      import 'package:computacion_movil/features/auth/infrastructure/models/firebase_auth_token_model.dart';
      import 'package:computacion_movil/features/auth/infrastructure/models/lapticon_user_model.dart';
      
      abstract class LapticonAuthDataSource {
        Future<Either<ItemError, FirebaseAuthTokenModel>> signInWithFirebase(
          String email,
          String password,
        );
        
        Future<Either<ItemError, LapticonUserModel>> registerProfile(
          String idToken,
          RegisterProfileParams params,
        );
        
        Future<Either<ItemError, LapticonUserModel>> getProfile(
          String idToken,
          String uid,
        );
        
        Future<Either<ItemError, bool>> clearSession();
        
        Future<Either<ItemError, FirebaseAuthTokenModel?>> getCachedToken();
        
        Future<Either<ItemError, bool>> cacheToken(FirebaseAuthTokenModel token);
      }
      ```
      **Verify**: Run `flutter analyze lib/features/auth/infrastructure/datasources/lapticon_auth_data_source.dart`.

- [ ] 16. Implement LapticonAuthDataSourceImpl with http calls
      **What**: Concrete implementation that calls Firebase Auth API and Lapticon backend using http package directly (ApiClient may not be ready). Include in-memory token caching.
      **Files**: `/Users/mariomelo/Documents/Proyectos personales/computacion_movil/lib/features/auth/infrastructure/datasources/lapticon_auth_data_source_impl.dart`
      **Details**:
      ```dart
      import 'dart:convert';
      import 'package:http/http.dart' as http;
      import 'package:dart_either/dart_either.dart';
      import 'package:computacion_movil/core/config/app_config.dart';
      import 'package:computacion_movil/core/errors/item_error.dart';
      import 'package:computacion_movil/features/auth/domain/entities/entities.dart';
      import 'package:computacion_movil/features/auth/infrastructure/datasources/lapticon_auth_data_source.dart';
      import 'package:computacion_movil/features/auth/infrastructure/models/firebase_auth_token_model.dart';
      import 'package:computacion_movil/features/auth/infrastructure/models/lapticon_user_model.dart';
      
      class LapticonAuthDataSourceImpl implements LapticonAuthDataSource {
        final http.Client _httpClient;
        final String _baseUrl;
        FirebaseAuthTokenModel? _cachedToken;
        
        LapticonAuthDataSourceImpl({
          required http.Client httpClient,
          String? baseUrl,
        })  : _httpClient = httpClient,
              _baseUrl = baseUrl ?? AppConfig.lapticonBaseUrl;
        
        @override
        Future<Either<ItemError, FirebaseAuthTokenModel>> signInWithFirebase(
          String email,
          String password,
        ) async {
          try {
            final url = Uri.parse(
              '${AppConfig.firebaseAuthUrl}?key=${AppConfig.firebaseApiKey}',
            );
            
            final response = await _httpClient.post(
              url,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'email': email,
                'password': password,
                'returnSecureToken': true,
              }),
            );
            
            if (response.statusCode == 200) {
              final json = jsonDecode(response.body) as Map<String, dynamic>;
              final model = FirebaseAuthTokenModel.fromJson(json);
              _cachedToken = model;
              return Right(model);
            } else {
              final errorJson = jsonDecode(response.body);
              final errorMessage = errorJson['error']?['message'] ?? 'Error de autenticación';
              return Left(ItemError(message: errorMessage, code: '${response.statusCode}'));
            }
          } catch (e) {
            return Left(ItemError(message: 'Error de conexión: $e'));
          }
        }
        
        @override
        Future<Either<ItemError, LapticonUserModel>> registerProfile(
          String idToken,
          RegisterProfileParams params,
        ) async {
          try {
            final url = Uri.parse('$_baseUrl/api/users/register');
            
            final response = await _httpClient.post(
              url,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $idToken',
              },
              body: jsonEncode({
                'nombre': params.nombre,
                'apellido': params.apellido,
                'telefono': params.telefono,
                'nacionalidad': params.nacionalidad,
              }),
            );
            
            if (response.statusCode == 200 || response.statusCode == 201) {
              final json = jsonDecode(response.body) as Map<String, dynamic>;
              return Right(LapticonUserModel.fromJson(json));
            } else {
              return Left(
                ItemError(
                  message: 'Error al registrar perfil: ${response.body}',
                  code: '${response.statusCode}',
                ),
              );
            }
          } catch (e) {
            return Left(ItemError(message: 'Error de conexión: $e'));
          }
        }
        
        @override
        Future<Either<ItemError, LapticonUserModel>> getProfile(
          String idToken,
          String uid,
        ) async {
          try {
            final url = Uri.parse('$_baseUrl/api/users/$uid');
            
            final response = await _httpClient.get(
              url,
              headers: {'Authorization': 'Bearer $idToken'},
            );
            
            if (response.statusCode == 200) {
              final json = jsonDecode(response.body) as Map<String, dynamic>;
              return Right(LapticonUserModel.fromJson(json));
            } else {
              return Left(
                ItemError(
                  message: 'Error al obtener perfil: ${response.body}',
                  code: '${response.statusCode}',
                ),
              );
            }
          } catch (e) {
            return Left(ItemError(message: 'Error de conexión: $e'));
          }
        }
        
        @override
        Future<Either<ItemError, bool>> clearSession() async {
          _cachedToken = null;
          return const Right(true);
        }
        
        @override
        Future<Either<ItemError, FirebaseAuthTokenModel?>> getCachedToken() async {
          return Right(_cachedToken);
        }
        
        @override
        Future<Either<ItemError, bool>> cacheToken(FirebaseAuthTokenModel token) async {
          _cachedToken = token;
          return const Right(true);
        }
      }
      ```
      **Verify**: Run `flutter analyze lib/features/auth/infrastructure/datasources/lapticon_auth_data_source_impl.dart`.

---

### PHASE 7: Infrastructure Layer - Repository Implementation

- [ ] 17. Implement LapticonAuthRepositoryImpl
      **What**: Repository implementation that delegates to data source and converts models to entities.
      **Files**: `/Users/mariomelo/Documents/Proyectos personales/computacion_movil/lib/features/auth/infrastructure/repositories/lapticon_auth_repository_impl.dart`
      **Details**:
      ```dart
      import 'package:dart_either/dart_either.dart';
      import 'package:computacion_movil/core/errors/item_error.dart';
      import 'package:computacion_movil/features/auth/domain/entities/entities.dart';
      import 'package:computacion_movil/features/auth/domain/repositories/lapticon_auth_repository.dart';
      import 'package:computacion_movil/features/auth/infrastructure/datasources/lapticon_auth_data_source.dart';
      
      class LapticonAuthRepositoryImpl implements LapticonAuthRepository {
        final LapticonAuthDataSource _dataSource;
        
        const LapticonAuthRepositoryImpl({
          required LapticonAuthDataSource dataSource,
        }) : _dataSource = dataSource;
        
        @override
        Future<Either<ItemError, FirebaseAuthToken>> signInWithEmailPassword(
          LoginParams params,
        ) async {
          final result = await _dataSource.signInWithFirebase(
            params.username,
            params.password,
          );
          
          return result.fold(
            ifLeft: (error) => Left(error),
            ifRight: (model) => Right(model.toEntity()),
          );
        }
        
        @override
        Future<Either<ItemError, LapticonUser>> registerProfile(
          String idToken,
          RegisterProfileParams params,
        ) async {
          final result = await _dataSource.registerProfile(idToken, params);
          
          return result.fold(
            ifLeft: (error) => Left(error),
            ifRight: (model) => Right(model.toEntity()),
          );
        }
        
        @override
        Future<Either<ItemError, LapticonUser>> getProfile(
          String idToken,
          String uid,
        ) async {
          final result = await _dataSource.getProfile(idToken, uid);
          
          return result.fold(
            ifLeft: (error) => Left(error),
            ifRight: (model) => Right(model.toEntity()),
          );
        }
        
        @override
        Future<Either<ItemError, bool>> signOut() async {
          return _dataSource.clearSession();
        }
        
        @override
        Future<Either<ItemError, FirebaseAuthToken?>> getCurrentToken() async {
          final result = await _dataSource.getCachedToken();
          
          return result.fold(
            ifLeft: (error) => Left(error),
            ifRight: (model) => Right(model?.toEntity()),
          );
        }
      }
      ```
      **Verify**: Run `flutter analyze lib/features/auth/infrastructure/repositories/lapticon_auth_repository_impl.dart`.

---

### PHASE 8: Dependency Injection Setup

- [ ] 18. Update injection_container.dart with Lapticon auth dependencies
      **What**: Register all new dependencies in GetIt container.
      **Files**: `/Users/mariomelo/Documents/Proyectos personales/computacion_movil/lib/core/di/injection_container.dart`
      **Details**:
      ```dart
      import 'package:get_it/get_it.dart';
      import 'package:http/http.dart' as http;
      import 'package:computacion_movil/features/auth/domain/repositories/lapticon_auth_repository.dart';
      import 'package:computacion_movil/features/auth/domain/usecases/sign_in_with_firebase_use_case.dart';
      import 'package:computacion_movil/features/auth/domain/usecases/register_profile_use_case.dart';
      import 'package:computacion_movil/features/auth/domain/usecases/get_profile_use_case.dart';
      import 'package:computacion_movil/features/auth/domain/usecases/sign_out_use_case.dart';
      import 'package:computacion_movil/features/auth/infrastructure/datasources/lapticon_auth_data_source.dart';
      import 'package:computacion_movil/features/auth/infrastructure/datasources/lapticon_auth_data_source_impl.dart';
      import 'package:computacion_movil/features/auth/infrastructure/repositories/lapticon_auth_repository_impl.dart';
      
      final sl = GetIt.instance;
      
      Future<void> initDependencies() async {
        // Core - HTTP Client
        sl.registerLazySingleton<http.Client>(() => http.Client());
        
        // Auth Feature - Data Sources
        sl.registerLazySingleton<LapticonAuthDataSource>(
          () => LapticonAuthDataSourceImpl(
            httpClient: sl<http.Client>(),
          ),
        );
        
        // Auth Feature - Repositories
        sl.registerLazySingleton<LapticonAuthRepository>(
          () => LapticonAuthRepositoryImpl(
            dataSource: sl<LapticonAuthDataSource>(),
          ),
        );
        
        // Auth Feature - Use Cases
        sl.registerFactory(
          () => SignInWithFirebaseUseCase(
            repository: sl<LapticonAuthRepository>(),
          ),
        );
        sl.registerFactory(
          () => RegisterProfileUseCase(
            repository: sl<LapticonAuthRepository>(),
          ),
        );
        sl.registerFactory(
          () => GetProfileUseCase(
            repository: sl<LapticonAuthRepository>(),
          ),
        );
        sl.registerFactory(
          () => SignOutUseCase(
            repository: sl<LapticonAuthRepository>(),
          ),
        );
      }
      ```
      **Verify**: Run `flutter analyze lib/core/di/injection_container.dart`.

---

### PHASE 9: Final Verification

- [ ] 19. Run full project analysis and fix any import issues
      **What**: Ensure all files compile, no missing imports, no analyzer warnings in the new auth code.
      **Command**: `flutter analyze lib/features/auth lib/core`
      **Expected**: No errors, zero warnings related to new auth implementation.
      **Files**: All files created in previous steps
      **Verify**: Exit code 0 from flutter analyze.

- [ ] 20. Create a simple smoke test for the auth flow
      **What**: Write an integration test stub that verifies DI container can instantiate all use cases.
      **Files**: `/Users/mariomelo/Documents/Proyectos personales/computacion_movil/test/features/auth/lapticon_auth_smoke_test.dart`
      **Details**:
      ```dart
      import 'package:flutter_test/flutter_test.dart';
      import 'package:computacion_movil/core/di/injection_container.dart';
      import 'package:computacion_movil/features/auth/domain/usecases/sign_in_with_firebase_use_case.dart';
      import 'package:computacion_movil/features/auth/domain/usecases/register_profile_use_case.dart';
      import 'package:computacion_movil/features/auth/domain/usecases/get_profile_use_case.dart';
      import 'package:computacion_movil/features/auth/domain/usecases/sign_out_use_case.dart';
      
      void main() {
        setUpAll(() async {
          await initDependencies();
        });
        
        test('DI container can resolve all Lapticon auth use cases', () {
          expect(() => sl<SignInWithFirebaseUseCase>(), returnsNormally);
          expect(() => sl<RegisterProfileUseCase>(), returnsNormally);
          expect(() => sl<GetProfileUseCase>(), returnsNormally);
          expect(() => sl<SignOutUseCase>(), returnsNormally);
        });
      }
      ```
      **Verify**: Run `flutter test test/features/auth/lapticon_auth_smoke_test.dart` - should pass.

---

## Summary of Files Created

### Domain Layer (9 files)
1. `/lib/features/auth/domain/entities/firebase_auth_token.dart`
2. `/lib/features/auth/domain/entities/lapticon_user.dart`
3. `/lib/features/auth/domain/entities/register_profile_params.dart`
4. `/lib/features/auth/domain/repositories/lapticon_auth_repository.dart`
5. `/lib/features/auth/domain/usecases/sign_in_with_firebase_use_case.dart`
6. `/lib/features/auth/domain/usecases/register_profile_use_case.dart`
7. `/lib/features/auth/domain/usecases/get_profile_use_case.dart`
8. `/lib/features/auth/domain/usecases/sign_out_use_case.dart`
9. Updated: `/lib/features/auth/domain/entities/entities.dart` (barrel file)

### Infrastructure Layer (5 files)
10. `/lib/features/auth/infrastructure/models/firebase_auth_token_model.dart`
11. `/lib/features/auth/infrastructure/models/lapticon_user_model.dart`
12. `/lib/features/auth/infrastructure/datasources/lapticon_auth_data_source.dart`
13. `/lib/features/auth/infrastructure/datasources/lapticon_auth_data_source_impl.dart`
14. `/lib/features/auth/infrastructure/repositories/lapticon_auth_repository_impl.dart`

### Core Layer (2 files modified, 1 test created)
15. Modified: `/lib/core/network/api_client.dart` (implement http methods)
16. Modified: `/lib/core/config/app_config.dart` (add Firebase API key and base URL)
17. Modified: `/lib/core/di/injection_container.dart` (register dependencies)
18. Created: `/test/core/network/api_client_test.dart`

### Test Layer (1 file)
19. `/test/features/auth/lapticon_auth_smoke_test.dart`

---

## Architecture Notes

### Design Decisions

1. **Separate from Supabase**: Created entirely new classes (LapticonAuthRepository, LapticonUser, etc.) instead of modifying existing Supabase implementation. This allows both backends to coexist during migration.

2. **Direct HTTP calls**: Since ApiClient was a stub, LapticonAuthDataSourceImpl uses `http` package directly. This is acceptable for a focused feature and avoids blocking on ApiClient implementation.

3. **In-memory token caching**: Simple `_cachedToken` field in data source. For production, this should be replaced with secure storage (flutter_secure_storage or shared_preferences).

4. **Entity/Model separation**: Followed existing pattern where infrastructure models have toJson/fromJson and toEntity() methods, while domain entities are pure Dart classes.

5. **Use case validation**: Each use case performs input validation before calling repository, following the existing LoginUseCase pattern.

### Dependencies Between Steps
- Steps 1-3 (core infrastructure) can be done first and in parallel
- Steps 4-7 (domain entities) depend on step 3 (AppConfig)
- Steps 8-12 (domain layer) depend on steps 4-7
- Steps 13-14 (models) depend on steps 4-7 (entities)
- Steps 15-16 (data sources) depend on steps 13-14 (models) and step 3 (AppConfig)
- Step 17 (repository) depends on steps 15-16 (data sources) and step 8 (repository interface)
- Step 18 (DI) depends on all previous implementation steps
- Steps 19-20 (verification) depend on step 18

### Next Steps (Not in This Plan)
After this implementation is complete, the following work remains:
- Create Riverpod providers for auth state management
- Create UI screens for login and profile registration
- Integrate with existing router and navigation
- Add persistent token storage with flutter_secure_storage
- Handle token refresh logic
- Add unit tests for each use case and repository
- Add integration tests for full auth flow
- Update existing Supabase code to use new Lapticon backend (if migrating completely)

### Base URL Configuration
**⚠️ IMPORTANT**: Step 3 adds a placeholder base URL. Before running the app, update `AppConfig.lapticonBaseUrl` with the actual backend URL from the Postman collection's `{{base_url}}` environment variable.
