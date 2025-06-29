import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:migo/models/cache.dart';
import 'package:migo/utils/config.dart';

class SettingsService extends GetxController with CacheManager {
  final String _baseUrl = AppConfig.baseUrl;
  final Dio _dio = Dio();

  SettingsService() {
    // Intercepteur pour injecter le token dans chaque requête
    _dio.interceptors.add(
      InterceptorsWrapper(onRequest: (options, handler) async {
        final token = await getToken();
        if (token != null) {
          options.headers['authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      }),
    );
  }

  /// Récupère le profil de l'utilisateur connecté
  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final response = await _dio.get('$_baseUrl/auth/profile');
      if (response.statusCode == 200) {
        return response.data['data'] as Map<String, dynamic>;
      }
    } catch (e) {
      print('Erreur récupération profil: $e');
    }
    return null;
  }

  /// Met à jour le profil de l'utilisateur
  Future<bool> updateProfile({
    required String firstname,
    required String name,
    required String email,
  }) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/auth/profile',
        data: {
          'firstname': firstname,
          'name': name,
          'email': email,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Erreur mise à jour profil: $e');
      return false;
    }
  }

  /// Change le mot de passe de l'utilisateur
  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/auth/change-password',
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message':
              response.data['message'] ?? 'Mot de passe changé avec succès'
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ??
              'Erreur lors du changement de mot de passe'
        };
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          return {'success': false, 'message': 'Mot de passe incorrect'};
        }
        return {
          'success': false,
          'message':
              e.response?.data['message'] ?? 'Erreur de connexion au backend'
        };
      }
      return {'success': false, 'message': 'Erreur de connexion au backend'};
    }
  }
}
