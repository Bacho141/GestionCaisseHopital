import 'package:dio/dio.dart';
import '../remote/api_client.dart';
import '../../models/authentication/user.dart';
import '../../utils/error_handler.dart';

class AuthApi {
  final Dio _client = ApiClient().client;

  Future<User> login(String email, String password) async {
    try {
      print('🌐 AUTH_API - Tentative de connexion pour: $email');

      final resp = await _client.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (resp.statusCode! >= 200 && resp.statusCode! < 300) {
        final data = resp.data;
        print("✅ AUTH_API - Connexion réussie pour: $email");
        print("   📊 Données reçues: $data");

        return User.fromJson(data['user'], token: data['token']);
      } else {
        // On récupère le message d'erreur du backend (ou un fallback)
        final backendMsg = resp.data is Map<String, dynamic>
            ? resp.data['message'] ?? 'Erreur inconnue'
            : 'Erreur inattendue';

        print("❌ AUTH_API - Erreur de connexion pour: $email");
        print("   📊 Status: ${resp.statusCode}");
        print("   📊 Message: $backendMsg");

        throw Exception(backendMsg);
      }
    } on DioException catch (error) {
      print("❌ AUTH_API - Erreur Dio lors de la connexion");
      ErrorHandler.handleDioError(error);
      rethrow;
    } catch (error) {
      print("❌ AUTH_API - Erreur inattendue lors de la connexion");
      ErrorHandler.logError('AuthApi.login', error);
      rethrow;
    }
  }

  Future<User> signup(
      String firstname, String name, String email, String password) async {
    try {
      print('🌐 AUTH_API - Tentative d\'inscription pour: $email');
      print('   👤 Prénom: $firstname');
      print('   👤 Nom: $name');

      final resp = await _client.post('/auth/signup', data: {
        'firstname': firstname,
        'name': name,
        'email': email,
        'password': password,
      });

      if (resp.statusCode! >= 200 && resp.statusCode! < 300) {
        final data = resp.data;
        print("✅ AUTH_API - Inscription réussie pour: $email");
        print("   📊 Données reçues: $data");

        return User.fromJson(data['user'], token: data['token']);
      } else {
        // On récupère le message d'erreur du backend (ou un fallback)
        final backendMsg = resp.data is Map<String, dynamic>
            ? resp.data['message'] ?? 'Erreur inconnue'
            : 'Erreur inattendue';

        print("❌ AUTH_API - Erreur d'inscription pour: $email");
        print("   📊 Status: ${resp.statusCode}");
        print("   📊 Message: $backendMsg");

        throw Exception(backendMsg);
      }
    } on DioException catch (error) {
      print("❌ AUTH_API - Erreur Dio lors de l'inscription");
      ErrorHandler.handleDioError(error);
      rethrow;
    } catch (error) {
      print("❌ AUTH_API - Erreur inattendue lors de l'inscription");
      ErrorHandler.logError('AuthApi.signup', error);
      rethrow;
    }
  }
}
