/// Endpoints de la API Lapticon
class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - debe configurarse desde .env
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://lapticon-backend.onrender.com',
  );

  // ========== Authentication ==========
  // Firebase Auth (no se llama directo desde la app, solo referencia)
  static const String firebaseAuth =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword';

  // ========== Users ==========
  static const String registerUser = '/api/users/register';
  static String getUser(String uid) => '/api/users/$uid';
  static String updateUser(String uid) => '/api/users/$uid';

  // ========== Trips (Viajes) ==========
  static const String createTrip = '/api/viajes';
  static const String getMyTrips = '/api/viajes';
  static const String getAvailableTrip = '/api/viajes/disponible';
  static const String searchTravelers = '/api/viajes/buscar';

  // ========== Packages (Encomiendas) ==========
  static const String createPackage = '/api/encomiendas';
  static const String getMyPackages = '/api/encomiendas';
  static const String getAvailablePackages = '/api/encomiendas/disponibles';
  static String updatePackageStatus(String packageId) =>
      '/api/encomiendas/$packageId/estado';

  // ========== Ratings ==========
  static const String createRating = '/api/ratings';
  static String getUserRatings(String uid) => '/api/ratings/$uid';

  // ========== Chats ==========
  static String getChatStatus(String chatId) => '/api/chats/estado/$chatId';

  // ========== Cities (públicas, sin token) ==========
  static const String getCountries = '/api/ciudades/paises';
  static const String getCities = '/api/ciudades/ciudades';

  // ========== Chatbot ==========
  static const String sendChatbotMessage = '/api/chatbot';
}
