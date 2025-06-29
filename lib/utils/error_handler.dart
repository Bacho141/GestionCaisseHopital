import 'package:dio/dio.dart';
import 'package:migo/utils/message_manager.dart';

class ErrorHandler {
  /// Traite les erreurs Dio et retourne un message approprié
  static String handleDioError(DioException error) {
    print('🔍 ERROR_HANDLER - Type: ${error.type}');
    print('🔍 ERROR_HANDLER - Status: ${error.response?.statusCode}');
    print('🔍 ERROR_HANDLER - Message: ${error.message}');
    print('🔍 ERROR_HANDLER - Response: ${error.response?.data}');

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        MessageManager.showNetworkError(
          title: 'Erreur de connexion',
          message: MessageTexts.timeoutError,
        );
        return MessageTexts.timeoutError;

      case DioExceptionType.connectionError:
        MessageManager.showNetworkError(
          title: 'Erreur réseau',
          message: MessageTexts.noInternet,
        );
        return MessageTexts.noInternet;

      case DioExceptionType.badResponse:
        return _handleHttpError(error.response?.statusCode, error.response?.data);

      case DioExceptionType.cancel:
        return 'Requête annulée';

      case DioExceptionType.unknown:
      default:
        MessageManager.showServerError(
          title: 'Erreur inconnue',
          message: MessageTexts.unknownError,
        );
        return MessageTexts.unknownError;
    }
  }

  /// Traite les erreurs HTTP selon le code de statut
  static String _handleHttpError(int? statusCode, dynamic responseData) {
    String message;
    String title;

    switch (statusCode) {
      case 400:
        title = 'Données invalides';
        message = _extractMessage(responseData) ?? 'Requête mal formée';
        MessageManager.showValidationError(title: title, message: message);
        break;

      case 401:
        title = 'Authentification échouée';
        message = _extractMessage(responseData) ?? MessageTexts.invalidCredentials;
        MessageManager.showAuthError(title: title, message: message);
        break;

      case 403:
        title = 'Accès refusé';
        message = _extractMessage(responseData) ?? MessageTexts.accessDenied;
        MessageManager.showAuthError(title: title, message: message);
        break;

      case 404:
        title = 'Ressource non trouvée';
        message = _extractMessage(responseData) ?? MessageTexts.userNotFound;
        MessageManager.showServerError(title: title, message: message);
        break;

      case 409:
        title = 'Conflit';
        message = _extractMessage(responseData) ?? 'Email déjà utilisé';
        MessageManager.showValidationError(title: title, message: message);
        break;

      case 422:
        title = 'Données invalides';
        message = _extractMessage(responseData) ?? 'Données de validation incorrectes';
        MessageManager.showValidationError(title: title, message: message);
        break;

      case 500:
        title = 'Erreur serveur';
        message = _extractMessage(responseData) ?? MessageTexts.serverError;
        MessageManager.showServerError(title: title, message: message);
        break;

      case 502:
      case 503:
      case 504:
        title = 'Serveur indisponible';
        message = _extractMessage(responseData) ?? MessageTexts.maintenanceError;
        MessageManager.showServerError(title: title, message: message);
        break;

      default:
        title = 'Erreur serveur';
        message = _extractMessage(responseData) ?? 'Erreur ${statusCode ?? 'inconnue'}';
        MessageManager.showServerError(title: title, message: message);
    }

    return message;
  }

  /// Extrait le message d'erreur de la réponse du serveur
  static String? _extractMessage(dynamic responseData) {
    if (responseData == null) return null;

    if (responseData is Map<String, dynamic>) {
      // Priorité au message principal
      if (responseData['message'] != null) {
        return responseData['message'].toString();
      }
      
      // Fallback sur error
      if (responseData['error'] != null) {
        return responseData['error'].toString();
      }
      
      // Fallback sur msg
      if (responseData['msg'] != null) {
        return responseData['msg'].toString();
      }
    }

    return responseData.toString();
  }

  /// Traite les erreurs de validation de formulaire
  static void handleValidationError(String field, String error) {
    MessageManager.showValidationError(
      title: 'Erreur de validation',
      message: '$field: $error',
    );
  }

  /// Traite les erreurs générales
  static void handleGeneralError(String title, String message) {
    MessageManager.showError(
      title: title,
      message: message,
      errorType: ErrorType.unknown,
    );
  }

  /// Log détaillé des erreurs pour debugging
  static void logError(String context, dynamic error, [StackTrace? stackTrace]) {
    final timestamp = DateTime.now().toIso8601String();
    
    print('🚨 [$timestamp] ERROR in $context');
    print('   📍 Type: ${error.runtimeType}');
    print('   💬 Message: $error');
    
    if (stackTrace != null) {
      print('   📚 Stack Trace:');
      print('   $stackTrace');
    }
    
    print('   ──────────────────────────────────────────────');
  }
} 