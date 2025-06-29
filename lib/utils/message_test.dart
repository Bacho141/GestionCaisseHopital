import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:migo/utils/message_manager.dart';
import 'package:migo/utils/error_handler.dart';

/// Widget de test pour démontrer le système de gestion des messages
class MessageTestWidget extends StatelessWidget {
  const MessageTestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test des Messages'),
        backgroundColor: const Color(0xFF667eea),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Test du système de gestion des messages',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Messages de succès
            const Text('Messages de succès:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => MessageManager.showSuccess(
                title: 'Déconnexion',
                message: MessageTexts.logoutSuccess,
              ),
              child: const Text('Message de succès'),
            ),
            const SizedBox(height: 10),

            // Messages d'erreur de validation
            const Text('Erreurs de validation:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => MessageManager.showValidationError(
                title: 'Erreur de validation',
                message: MessageTexts.invalidEmail,
              ),
              child: const Text('Erreur de validation'),
            ),
            const SizedBox(height: 10),

            // Messages d'erreur réseau
            const Text('Erreurs réseau:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => MessageManager.showNetworkError(
                title: 'Erreur de connexion',
                message: MessageTexts.networkError,
              ),
              child: const Text('Erreur réseau'),
            ),
            const SizedBox(height: 10),

            // Messages d'erreur serveur
            const Text('Erreurs serveur:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => MessageManager.showServerError(
                title: 'Erreur serveur',
                message: MessageTexts.serverError,
              ),
              child: const Text('Erreur serveur'),
            ),
            const SizedBox(height: 10),

            // Messages d'erreur d'authentification
            const Text('Erreurs d\'authentification:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => MessageManager.showAuthError(
                title: 'Échec de connexion',
                message: MessageTexts.invalidCredentials,
              ),
              child: const Text('Erreur d\'authentification'),
            ),
            const SizedBox(height: 20),

            // Test de l'ErrorHandler
            const Text('Test ErrorHandler:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => ErrorHandler.handleGeneralError(
                'Erreur générale',
                'Ceci est un test d\'erreur générale',
              ),
              child: const Text('Erreur générale'),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () => ErrorHandler.handleValidationError(
                'Email',
                'Format invalide',
              ),
              child: const Text('Erreur de validation (ErrorHandler)'),
            ),
            const SizedBox(height: 20),

            // Retour
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              child: const Text('Retour'),
            ),
          ],
        ),
      ),
    );
  }
}
