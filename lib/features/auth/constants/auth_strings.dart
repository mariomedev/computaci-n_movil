class AuthStrings {
  const AuthStrings._();

  static const appName = 'Lapticon';

  static const loginSubtitle = 'Inicia sesión para continuar';
  static const loginButton = 'Iniciar sesión';
  static const noAccountQuestion = '¿No tienes cuenta? Regístrate';

  static const registerSubtitle = 'Crea tu cuenta';
  static const registerButton = 'Registrarse';
  static const hasAccountQuestion = '¿Ya tienes cuenta? Inicia sesión';

  static const emailLabel = 'Email';
  static const passwordLabel = 'Contraseña';
  static const confirmPasswordLabel = 'Confirmar contraseña';
  static const nombreLabel = 'Nombre';
  static const apellidoLabel = 'Apellido';
  static const telefonoLabel = 'Teléfono';
  static const nacionalidadLabel = 'Nacionalidad';

  static const themeLightTooltip = 'Cambiar a modo claro';
  static const themeDarkTooltip = 'Cambiar a modo oscuro';

  static const emailRequired = 'Email es requerido';
  static const emailInvalidFormat = 'Email debe tener formato válido (ejemplo@dominio.com)';

  static const passwordRequired = 'Contraseña es requerida';
  static const passwordMinLength = 'Contraseña debe tener al menos 6 caracteres';

  static const confirmPasswordRequired = 'Confirmar contraseña es requerido';
  static const passwordsNotMatch = 'Las contraseñas no coinciden';

  static const phoneRequired = 'Teléfono es requerido';
  static const phoneInvalidFormat = 'Teléfono debe tener formato válido';

  static String fieldRequired(String fieldName) => '$fieldName es requerido';
}
