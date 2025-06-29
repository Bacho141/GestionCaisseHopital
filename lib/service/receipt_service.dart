// lib/service/receipt_service.dart
import 'package:dio/dio.dart';
import 'package:get/get_connect/connect.dart' hide Response;
import 'package:migo/models/receipt/receipt_model.dart';
import 'package:migo/models/cache.dart';
import 'package:migo/utils/config.dart';

class ReceiptService extends GetConnect with CacheManager {
  final String _baseUrl = AppConfig.baseUrl;
  final Dio _dio = Dio();

  /// Envoie un nouveau reçu, renvoie l'ID généré
  Future<String?> createReceipt(Map<String, dynamic> payload) async {
    final token = await getToken();
    _dio.options.headers['authorization'] = 'Bearer $token';

    final resp = await _dio.post('$_baseUrl/receipt', data: payload);
    if (resp.statusCode == 201) {
      return resp.data['_id'] as String;
    }
    return null;
  }

  /// Récupère un reçu existant
  Future<Receipt?> getReceipt(String id) async {
    final token = await getToken();
    _dio.options.headers['authorization'] = 'Bearer $token';

    final resp = await _dio.get('$_baseUrl/receipt/$id');
    if (resp.statusCode == 200) {
      return Receipt.fromMap(resp.data);
    }
    return null;
  }

  ReceiptService() {
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

  /// Récupère la liste des reçus, avec filtres facultatifs.
  // Future<List<Receipt>?> fetchReceipts({
  //   DateTime? from,
  //   DateTime? to,
  //   DateTime? date,
  //   String? cashier,
  //   String? product,
  //   String? status,
  // }) async {
  //   final query = <String, dynamic>{};

  //   if (date != null) {
  //     query['date'] = date.toIso8601String().substring(0, 10);
  //   } else {
  //     if (from != null) query['from'] = from.toIso8601String().substring(0, 10);
  //     if (to   != null) query['to']   = to.toIso8601String().substring(0, 10);
  //   }
  //   if (cashier != null) query['cashier'] = cashier;
  //   if (product != null) query['product'] = product;
  //   if (status != null)  query['status']  = status; // 'paid' ou 'due'

  //   final response = await _dio.get('$_baseUrl/receipt', queryParameters: query);
  //   if (response.statusCode == 200) {
  //     final data = response.data as List;
  //     return data
  //         .map((m) => Receipt.fromMap(Map<String, dynamic>.from(m)))
  //         .toList();
  //   } else {
  //     return null;
  //   }
  // }

  /// Récupère la liste des reçus en appliquant les query-params passés.
  /// Exemples de clés dans [params] : 'from', 'to', 'caissier', 'produit', 'status'
  Future<List<Receipt>?> fetchReceipts(Map<String, String> params) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/receipt',
        queryParameters: params.isEmpty ? null : params,
      );
      if (response.statusCode == 200) {
        // On suppose que l'API renvoie directement un array JSON de reçus
        final data = response.data as List<dynamic>;
        return data
            .map((e) => Receipt.fromMap(Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (e) {
      // Vous pouvez logger ou re-thrower
      print('Erreur fetchReceipts: $e');
    }
    return null;
  }

  /// Récupère un reçu par ID
  Future<Receipt?> fetchById(String id) async {
    final response = await _dio.get('$_baseUrl/receipts/$id');
    if (response.statusCode == 200) {
      return Receipt.fromMap(Map<String, dynamic>.from(response.data as Map));
    } else {
      return null;
    }
  }

  /// Supprime un reçu
  Future<bool> deleteReceipt(String id) async {
    final response = await _dio.delete('$_baseUrl/receipts/$id');
    return response.statusCode == 200;
  }

  /// Met à jour le statut d'un reçu (paid/due)
  Future<bool> updateReceiptStatus(
      String receiptNumber, double newPaid, double newDue) async {
    try {
      print(
          '🔄 Tentative de mise à jour du statut pour le reçu: $receiptNumber');
      print('📊 Nouveaux montants - Paid: $newPaid, Due: $newDue');

      final response = await _dio.put(
        '$_baseUrl/receipt/$receiptNumber/status',
        data: {
          'paid': newPaid,
          'due': newDue,
        },
      );

      print('✅ Réponse du serveur: ${response.statusCode}');
      print('📄 Données reçues: ${response.data}');

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Erreur updateReceiptStatus: $e');
      if (e is DioException) {
        print('🔍 Détails de l\'erreur Dio:');
        print('   - Type: ${e.type}');
        print('   - Status: ${e.response?.statusCode}');
        print('   - Message: ${e.response?.data}');
        print('   - URL: ${e.requestOptions.uri}');
      }
      return false;
    }
  }
}
