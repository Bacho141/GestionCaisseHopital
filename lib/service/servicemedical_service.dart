import 'package:dio/dio.dart';
import 'package:get/get_connect/connect.dart' hide Response;
import 'package:migo/models/cache.dart';
import 'package:migo/models/servicemedical/servicemedical.dart';
import 'package:migo/utils/config.dart';

class ServiceServices extends GetConnect with CacheManager {
  final String baseUrl = AppConfig.baseUrl;

  Future<List<Product>?> fetchByCategory(String category) async {
    final dio = Dio();
    dio.options.headers['authorization'] = 'Bearer ${getToken()}';
    final resp = await dio.get('$baseUrl/service/category/$category');
    if (resp.statusCode == 200) {
      final data = resp.data['data'] as List;
      return data.map((e) => Product.fromJson(e)).toList();
    }
    return null;
  }

  Future<List<Product>?> search(String term) async {
    final dio = Dio();
    dio.options.headers['authorization'] = 'Bearer ${getToken()}';
    final resp = await dio.get('$baseUrl/service/search/$term');
    if (resp.statusCode == 200) {
      final data = resp.data['data'] as List;
      return data.map((e) => Product.fromJson(e)).toList();
    }
    return null;
  }

  Future<List<Product>?> fetchAll() async {
    final dio = Dio();
    dio.options.headers['authorization'] = 'Bearer ${getToken()}';
    final resp = await dio.get('$baseUrl/service');

    if (resp.statusCode == 200) {
      final body = resp.data;
      List<dynamic> list;

      if (body is List) {
        // Cas 1 : backend renvoie une liste brute
        list = body;
      } else if (body is Map<String, dynamic> && body['data'] is List) {
        // Cas 2 : backend renvoie { success, data }
        list = body['data'] as List;
      } else {
        // Aucun format connu : on retourne vide
        return [];
      }

      // Map vers votre modèle Service
      return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    }
    return null;
  }

  /// ─── MISE À JOUR D’UN SERVICE ───
  Future<bool> updateService(String id, Map<String, dynamic> payload) async {
    final dio = Dio();
    final token = getToken();
    dio.options.headers["authorization"] = "Bearer $token";

    // Appel PUT vers /api/service/update/:id
    final url = '$baseUrl/service/update/$id';
    Response response = await dio.put(
      url,
      data: payload,
      options: Options(validateStatus: (_) => true),
    );
    print("Service response :, ${response.statusCode}");

    if (response.statusCode == 200) {
      // Optionnel : vous pouvez vérifier response.data si vous voulez
      return true;
    } else {
      return false;
    }
  }

}
