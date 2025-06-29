import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum MessageType {
  success,
  error,
  warning,
  info,
}

enum ErrorType {
  validation,
  network,
  server,
  authentication,
  unknown,
}

class MessageManager {
  static const Duration _defaultDuration = Duration(seconds: 4);
  static const Duration _animationDuration = Duration(milliseconds: 300);

  /// Affiche un message de succès
  static void showSuccess({
    required String title,
    required String message,
    Duration? duration,
  }) {
    _showMessage(
      type: MessageType.success,
      title: title,
      message: message,
      duration: duration ?? _defaultDuration,
    );
  }

  /// Affiche un message d'erreur avec type spécifique
  static void showError({
    required String title,
    required String message,
    ErrorType errorType = ErrorType.unknown,
    Duration? duration,
  }) {
    _showMessage(
      type: MessageType.error,
      title: title,
      message: message,
      errorType: errorType,
      duration: duration ?? _defaultDuration,
    );
  }

  /// Affiche un message d'erreur de validation
  static void showValidationError({
    required String title,
    required String message,
    Duration? duration,
  }) {
    showError(
      title: title,
      message: message,
      errorType: ErrorType.validation,
      duration: duration,
    );
  }

  /// Affiche un message d'erreur réseau
  static void showNetworkError({
    required String title,
    required String message,
    Duration? duration,
  }) {
    showError(
      title: title,
      message: message,
      errorType: ErrorType.network,
      duration: duration,
    );
  }

  /// Affiche un message d'erreur serveur
  static void showServerError({
    required String title,
    required String message,
    Duration? duration,
  }) {
    showError(
      title: title,
      message: message,
      errorType: ErrorType.server,
      duration: duration,
    );
  }

  /// Affiche un message d'erreur d'authentification
  static void showAuthError({
    required String title,
    required String message,
    Duration? duration,
  }) {
    showError(
      title: title,
      message: message,
      errorType: ErrorType.authentication,
      duration: duration,
    );
  }

  /// Méthode privée pour afficher les messages
  static void _showMessage({
    required MessageType type,
    required String title,
    required String message,
    ErrorType? errorType,
    required Duration duration,
  }) {
    // Log pour debugging
    _logMessage(type, title, message, errorType);

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      colorText: _getTextColor(type),
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      borderColor: _getBorderColor(type),
      borderWidth: 1,
      icon: _getIcon(type),
      shouldIconPulse: false,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      animationDuration: _animationDuration,
      barBlur: 0,
      overlayBlur: 0,
      snackStyle: SnackStyle.FLOATING,
      titleText: Text(
        title,
        style: TextStyle(
          color: _getTextColor(type),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          color: _getTextColor(type),
          fontSize: 14,
        ),
      ),
    );
  }

  /// Couleur du texte selon le type de message
  static Color _getTextColor(MessageType type) {
    switch (type) {
      case MessageType.success:
        return const Color(0xFF2E7D32); // Vert foncé
      case MessageType.error:
        return const Color(0xFFD32F2F); // Rouge foncé
      case MessageType.warning:
        return const Color(0xFFF57C00); // Orange
      case MessageType.info:
        return const Color(0xFF1976D2); // Bleu
    }
  }

  /// Couleur de la bordure selon le type de message
  static Color _getBorderColor(MessageType type) {
    switch (type) {
      case MessageType.success:
        return const Color(0xFF4CAF50); // Vert
      case MessageType.error:
        return const Color(0xFFF44336); // Rouge
      case MessageType.warning:
        return const Color(0xFFFF9800); // Orange
      case MessageType.info:
        return const Color(0xFF2196F3); // Bleu
    }
  }

  /// Icône selon le type de message
  static Widget _getIcon(MessageType type) {
    IconData iconData;
    Color iconColor = _getTextColor(type);

    switch (type) {
      case MessageType.success:
        iconData = Icons.check_circle;
        break;
      case MessageType.error:
        iconData = Icons.error;
        break;
      case MessageType.warning:
        iconData = Icons.warning;
        break;
      case MessageType.info:
        iconData = Icons.info;
        break;
    }

    return Icon(
      iconData,
      color: iconColor,
      size: 24,
    );
  }

  /// Log des messages pour debugging
  static void _logMessage(
    MessageType type,
    String title,
    String message,
    ErrorType? errorType,
  ) {
    final timestamp = DateTime.now().toIso8601String();
    final typeStr = type.name.toUpperCase();
    final errorTypeStr = errorType?.name.toUpperCase() ?? 'N/A';

    print('📱 [$timestamp] MESSAGE [$typeStr] [$errorTypeStr]');
    print('   📋 Titre: $title');
    print('   💬 Message: $message');
    print('   ──────────────────────────────────────────────');
  }
}

/// Messages d'erreur prédéfinis pour les cas courants
class MessageTexts {
  // Erreurs de validation
  static const String invalidEmail = 'Format d\'email invalide';
  static const String invalidPassword =
      'Mot de passe trop court (min 6 caractères)';
  static const String invalidPhone = 'Format de téléphone invalide';
  static const String passwordMismatch =
      'Les mots de passe ne correspondent pas';
  static const String requiredField = 'Ce champ est obligatoire';
  static const String invalidName =
      'Le nom doit contenir au moins 4 caractères';

  // Erreurs réseau
  static const String networkError = 'Erreur de connexion réseau';
  static const String noInternet = 'Aucune connexion internet';
  static const String timeoutError = 'Délai d\'attente dépassé';

  // Erreurs serveur
  static const String serverError = 'Erreur serveur';
  static const String maintenanceError = 'Serveur en maintenance';
  static const String unknownError = 'Erreur inconnue';

  // Erreurs d'authentification
  static const String invalidCredentials = 'Identifiants invalides';
  static const String userNotFound = 'Utilisateur non trouvé';
  static const String accountLocked = 'Compte verrouillé';
  static const String sessionExpired = 'Session expirée';
  static const String accessDenied = 'Accès refusé';

  // Messages de succès
  static const String logoutSuccess = 'Déconnexion réussie';
}
