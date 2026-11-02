# Lapticon - Aplicación Móvil

Aplicación móvil de Lapticon desarrollada con Flutter, implementando Clean Architecture y autenticación con Firebase.

## 📋 Requisitos Previos

- **Flutter SDK**: 3.13.2 o superior
- **Dart SDK**: 3.13.2 o superior
- **Android Studio** (para desarrollo Android)
- **Xcode** (para desarrollo iOS - solo macOS)
- **Git**

### Verificar instalación de Flutter

```bash
flutter --version
flutter doctor
```

## 🚀 Instalación

### 1. Clonar el repositorio

```bash
git clone <repository-url>
cd computacion_movil
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Configurar variables de entorno

Crea un archivo `.env` en la raíz del proyecto con las siguientes variables:

```env
# Firebase Configuration
FIREBASE_API_KEY=your_firebase_api_key
FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_STORAGE_BUCKET=your_project.appspot.com
FIREBASE_MESSAGING_SENDER_ID=your_sender_id
FIREBASE_APP_ID=your_app_id

# Supabase Configuration
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key

# Backend API
API_BASE_URL=your_backend_url
```

### 4. Configurar Firebase

#### Android
1. Descarga el archivo `google-services.json` desde Firebase Console
2. Colócalo en `android/app/google-services.json`

#### iOS
1. Descarga el archivo `GoogleService-Info.plist` desde Firebase Console
2. Colócalo en `ios/Runner/GoogleService-Info.plist`

## 🏃‍♂️ Ejecución del Proyecto

### Modo Desarrollo

#### Android
```bash
flutter run --debug
```

#### iOS
```bash
flutter run --debug
```

### Seleccionar dispositivo específico
```bash
# Listar dispositivos disponibles
flutter devices

# Ejecutar en dispositivo específico
flutter run -d <device_id>
```

### Hot Reload
Durante la ejecución, puedes usar:
- `r` - Hot reload
- `R` - Hot restart
- `q` - Quit

## 🔨 Build

### Android

#### Debug APK
```bash
flutter build apk --debug
```

#### Release APK
```bash
flutter build apk --release
```

#### Android App Bundle (para Google Play)
```bash
flutter build appbundle --release
```

Los archivos generados estarán en:
- APK: `build/app/outputs/flutter-apk/`
- AAB: `build/app/outputs/bundle/release/`

### iOS

```bash
flutter build ios --release
```

## 🧪 Testing

### Ejecutar todos los tests
```bash
flutter test
```

### Ejecutar tests con coverage
```bash
flutter test --coverage
```

### Análisis de código
```bash
flutter analyze
```

## 📁 Estructura del Proyecto

```
lib/
├── core/                      # Funcionalidades compartidas
│   ├── config/               # Configuración de la app
│   ├── errors/               # Manejo de errores
│   ├── network/              # Cliente HTTP
│   ├── router/               # Configuración de rutas
│   └── theme/                # Tema y estilos
├── features/                  # Características de la app
│   ├── auth/                 # Autenticación
│   │   ├── domain/          # Entidades, repositorios, casos de uso
│   │   ├── infrastructure/  # Implementación de datos
│   │   └── presentation/    # UI y estado
│   └── [other features]/
├── app.dart                   # Configuración principal de la app
└── main.dart                  # Punto de entrada
```

## 🏗️ Arquitectura

El proyecto implementa **Clean Architecture** con las siguientes capas:

- **Domain**: Entidades, casos de uso y contratos de repositorios
- **Infrastructure**: Implementación de repositorios, modelos y fuentes de datos
- **Presentation**: UI, providers (Riverpod) y manejo de estado

### Patrones Utilizados

- **State Management**: Riverpod
- **Routing**: go_router
- **Error Handling**: Either (dart_either)
- **Dependency Injection**: GetIt
- **HTTP Client**: http / dio

## 🔐 Autenticación

La aplicación soporta múltiples métodos de autenticación:

1. **Firebase Authentication**
   - Email y contraseña
   - Gestión de tokens (idToken, refreshToken)

2. **Supabase** (implementación alternativa)

### Flujo de Autenticación

1. Usuario ingresa credenciales en Login/Register
2. Firebase valida y retorna token
3. Token se usa para llamadas al backend de Lapticon
4. Redirección automática al Dashboard

## 📱 Funcionalidades

### ✅ Implementadas

- [x] Pantalla de Login
- [x] Pantalla de Registro
- [x] Autenticación con Firebase
- [x] Navegación con go_router
- [x] Tema claro/oscuro
- [x] Validación de formularios
- [x] Manejo de errores

## 🛠️ Dependencias Principales

| Paquete | Versión | Propósito |
|---------|---------|-----------|
| flutter_riverpod | ^2.6.1 | State management |
| go_router | ^14.6.2 | Routing |
| firebase_core | ^3.15.2 | Firebase core |
| firebase_auth | ^5.3.3 | Firebase authentication |
| supabase_flutter | ^2.9.1 | Supabase integration |
| dart_either | ^1.0.0 | Error handling |
| http | ^1.6.0 | HTTP client |
| google_fonts | ^6.2.1 | Typography |
| get_it | ^9.3.0 | Dependency injection |

## 🐛 Troubleshooting

### Error: "No Firebase App '[DEFAULT]' has been created"
```bash
# Verifica que google-services.json esté en android/app/
# Ejecuta flutter clean y rebuild
flutter clean
flutter pub get
flutter run
```

### Error: "CocoaPods not installed"
```bash
# macOS - Instalar CocoaPods
sudo gem install cocoapods
cd ios
pod install
cd ..
```

### Error de compilación en Android
```bash
# Limpiar build
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

## 📄 Licencia

Este proyecto es privado y confidencial.

## 👥 Equipo

- Desarrollo: [Adamarys]

## 📞 Contacto

Para preguntas o soporte: [tu-email@ejemplo.com]

---

**Última actualización**: Octubre 2026
