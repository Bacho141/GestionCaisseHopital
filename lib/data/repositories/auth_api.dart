import 'package:dio/dio.dart';
import '../remote/api_client.dart';
import '../../models/authentication/user.dart';

class AuthApi {
  final Dio _client = ApiClient().client;

  Future<User> login(String email, String password) async {
    final resp = await _client.post('/auth/login', data: {
      'email': email,
      'password': password,
    });

    if (resp.statusCode! >= 200 && resp.statusCode! < 300) {
      final data = resp.data;
      print("mbacho.web45@gmail.com : , $data");

      return User.fromJson(data['user'], token: data['token']);
    } else {
      // On récupère le message d'erreur du backend (ou un fallback)
      final backendMsg = resp.data is Map<String, dynamic>
          ? resp.data['message'] ?? 'Erreur inconnue'
          : 'Erreur inattendue';
      throw Exception(backendMsg);
    }
  }

  Future<User> signup(String name, String email, String password) async {
    final resp = await _client.post('/auth/signup', data: {
      'name': name,
      'email': email,
      'password': password,
    });

    if (resp.statusCode! >= 200 && resp.statusCode! < 300) {
      final data = resp.data;
      return User.fromJson(data['user'], token: data['token']);
    } else {
      // On récupère le message d'erreur du backend (ou un fallback)
      final backendMsg = resp.data is Map<String, dynamic>
          ? resp.data['message'] ?? 'Erreur inconnue'
          : 'Erreur inattendue';
      throw Exception(backendMsg);
    }
  }
}
