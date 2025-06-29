# Système de Gestion des Messages et Erreurs

Ce système fournit une gestion centralisée et cohérente des messages d'erreur et de succès dans l'application.

## 📁 Fichiers

- `message_manager.dart` - Gestionnaire principal des messages
- `error_handler.dart` - Gestionnaire des erreurs HTTP et réseau
- `message_test.dart` - Widget de test pour démontrer les fonctionnalités

## 🎨 Design des Messages

### Caractéristiques
- **Position** : En haut de l'écran
- **Couleurs** : 
  - ✅ Succès : Vert (`#2E7D32`)
  - ❌ Erreur : Rouge (`#D32F2F`)
  - ⚠️ Avertissement : Orange (`#F57C00`)
  - ℹ️ Info : Bleu (`#1976D2`)
- **Background** : Blanc avec bordure colorée
- **Auto-disparition** : 4 secondes par défaut
- **Fermeture manuelle** : Balayage horizontal
- **Animations** : Entrée/sortie fluides

### Types de Messages

#### 1. Messages de Succès
```dart
MessageManager.showSuccess(
  title: 'Succès',
  message: 'Opération réussie !',
);
```

#### 2. Messages d'Erreur par Type

**Erreur de validation :**
```dart
MessageManager.showValidationError(
  title: 'Erreur de validation',
  message: 'Format d\'email invalide',
);
```

**Erreur réseau :**
```dart
MessageManager.showNetworkError(
  title: 'Erreur réseau',
  message: 'Aucune connexion internet',
);
```

**Erreur serveur :**
```dart
MessageManager.showServerError(
  title: 'Erreur serveur',
  message: 'Serveur en maintenance',
);
```

**Erreur d'authentification :**
```dart
MessageManager.showAuthError(
  title: 'Authentification échouée',
  message: 'Identifiants invalides',
);
```

## 🔧 Gestion des Erreurs

### ErrorHandler

Le `ErrorHandler` traite automatiquement les erreurs Dio et HTTP :

```dart
try {
  // Appel API
} on DioException catch (error) {
  ErrorHandler.handleDioError(error);
} catch (error) {
  ErrorHandler.logError('context', error);
}
```

### Codes d'Erreur HTTP Gérés

- **400** : Données invalides → Message de validation
- **401** : Authentification échouée → Message d'auth
- **403** : Accès refusé → Message d'auth
- **404** : Ressource non trouvée → Message serveur
- **409** : Conflit (ex: email déjà utilisé) → Message de validation
- **422** : Données de validation incorrectes → Message de validation
- **500** : Erreur serveur → Message serveur
- **502/503/504** : Serveur indisponible → Message serveur

### Erreurs Réseau

- **Timeout** : Délai d'attente dépassé
- **Connection Error** : Aucune connexion internet
- **Unknown** : Erreur inconnue

## 📝 Messages Prédéfinis

### MessageTexts

Messages centralisés dans `MessageTexts` :

```dart
// Erreurs de validation
MessageTexts.invalidEmail
MessageTexts.invalidPassword
MessageTexts.invalidPhone
MessageTexts.passwordMismatch
MessageTexts.requiredField
MessageTexts.invalidName

// Erreurs réseau
MessageTexts.networkError
MessageTexts.noInternet
MessageTexts.timeoutError

// Erreurs serveur
MessageTexts.serverError
MessageTexts.maintenanceError
MessageTexts.unknownError

// Erreurs d'authentification
MessageTexts.invalidCredentials
MessageTexts.userNotFound
MessageTexts.accountLocked
MessageTexts.sessionExpired
MessageTexts.accessDenied

// Messages de succès
MessageTexts.logoutSuccess
```

## 🔍 Logs de Debugging

Le système génère automatiquement des logs détaillés :

```
📱 [2024-01-15T10:30:45.123Z] MESSAGE [ERROR] [AUTHENTICATION]
   📋 Titre: Authentification échouée
   💬 Message: Identifiants invalides
   ──────────────────────────────────────────────
```

## 🚀 Utilisation dans l'Application

### Dans les Controllers

```dart
class AuthController extends GetxController {
  Future<void> loginAdmin(String email, String password) async {
    try {
      final userData = await _adminRepo.login(email, password);
      if (userData != null) {
        // Succès - pas de message (redirection automatique)
      } else {
        MessageManager.showAuthError(
          title: 'Échec de connexion',
          message: MessageTexts.invalidCredentials,
        );
      }
    } catch (error) {
      ErrorHandler.logError('loginAdmin', error);
      MessageManager.showNetworkError(
        title: 'Erreur de connexion',
        message: MessageTexts.networkError,
      );
    }
  }
}
```

### Dans les Services

```dart
class AuthApi {
  Future<User> login(String email, String password) async {
    try {
      final resp = await _client.post('/auth/login', data: {...});
      // Traitement de la réponse
    } on DioException catch (error) {
      ErrorHandler.handleDioError(error);
      rethrow;
    } catch (error) {
      ErrorHandler.logError('AuthApi.login', error);
      rethrow;
    }
  }
}
```

## 🧪 Test du Système

Utilisez le widget `MessageTestWidget` pour tester tous les types de messages :

```dart
Get.to(() => const MessageTestWidget());
```

## 📋 Bonnes Pratiques

1. **Utilisez les messages prédéfinis** quand possible
2. **Loggez toujours les erreurs** avec `ErrorHandler.logError()`
3. **Ne pas afficher de messages de succès** pour les connexions (redirection automatique)
4. **Afficher des messages de succès** pour les déconnexions
5. **Utilisez les types d'erreur appropriés** pour une meilleure UX
6. **Testez les messages** avec le widget de test

## 🔄 Mise à Jour

Pour ajouter de nouveaux types de messages :

1. Ajoutez l'enum dans `MessageType` ou `ErrorType`
2. Ajoutez la méthode correspondante dans `MessageManager`
3. Ajoutez les couleurs et icônes appropriées
4. Ajoutez les messages dans `MessageTexts`
5. Testez avec le widget de test 