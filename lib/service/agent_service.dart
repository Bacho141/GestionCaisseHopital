import 'package:dio/dio.dart';
import 'package:get/get_connect/connect.dart' hide Response;
import 'package:migo/models/cache.dart';
import 'package:migo/models/agent/agent.dart';
import 'package:migo/utils/config.dart';

class AgentServices extends GetConnect with CacheManager {
  final String baseUrl = AppConfig.baseUrl;

  /// 1) Login agent (renvoie token)
  // Future<String?> loginAgent(String telephone, String password) async {
  //   final dio = Dio();
  //   final resp = await dio.post(
  //     '$baseUrl/agent/login',
  //     data: {'telephone': telephone, 'password': password},
  //   );
  //   if (resp.statusCode == 200 && resp.data['success'] == true) {
  //     return resp.data['data']['token'] as String;
  //   }
  //   return null;
  // }

  Future<String?> loginAgent(String telephone, String password) async {
    final dio = Dio();
    final resp = await dio.post(
      '$baseUrl/agent/login',
      data: {'telephone': telephone, 'password': password},
      options: Options(validateStatus: (_) => true),
    );
    // Ne jette plus sur 401, on gère nous-mêmes :
    if (resp.statusCode == 200 && resp.data['success'] == true) {
      return resp.data['data']['token'] as String;
    }
    // Ici code 401 ou autre → on considère que c'est un échec de login
    return null;
  }

  /// 2) Reveal password (Admin must pass own password)
  Future<String?> revealAgent(String id, String adminPassword) async {
    final dio = Dio();
    // 1) Récupère le token via CacheManager
    final token = await getToken();
    dio.options.headers['authorization'] = 'Bearer $token';
    // dio.options.headers['authorization'] = 'Bearer ${getToken()}';
    final resp = await dio.post(
      '$baseUrl/agent/$id/reveal',
      data: {'adminPassword': adminPassword},
      // 2) Autorise de ne pas throw automatiquement sur 403
      options: Options(validateStatus: (_) => true),
    );
    if (resp.statusCode == 200 && resp.data['success'] == true) {
      return resp.data['data']['rawPassword'] as String;
    }
    return null;
  }

  /// 3) Reset password (Admin must pass own password)
  Future<String?> resetAgent(String id, String adminPassword) async {
    final dio = Dio();
    final token = await getToken();
    dio.options.headers['authorization'] = 'Bearer $token';

    final resp = await dio.post(
      '$baseUrl/agent/$id/reset',
      data: {'adminPassword': adminPassword},
      options: Options(validateStatus: (_) => true),
    );
    if (resp.statusCode == 200 && resp.data['success'] == true) {
      return resp.data['data']['rawPassword'] as String;
    }
    return null;
  }

  /// 4) Fetch all agents (existant)
  Future<List<Agent>?> fetchAllAgents() async {
    final dio = Dio();
    print("VALIDTOKENN 1: ${getToken()}");
    dio.options.headers['Authorization'] = 'Bearer ${getToken()}';
    final resp = await dio.get('$baseUrl/agent',
    );

    print('Status code: ${resp.statusCode}');
    print('Body: ${resp.data}');
    // print("CASSIERS 1 :, ${resp.statusCode}");
    if (resp.statusCode == 200) {
      final list = (resp.data['data'] as List?) ?? [];
      // print("CASSIERS 2 :, $list");

      return list.map((e) => Agent.fromJson(e)).toList();
    }
    return null;
  }

  Future<Agent?> fetchAgentById(String id) async {
    final dio = Dio();
    dio.options.headers['authorization'] = 'Bearer ${getToken()}';
    final resp = await dio.get('$baseUrl/caissiers/$id');
    if (resp.statusCode == 200) {
      return Agent.fromJson(resp.data['data']);
    }
    return null;
  }

  Future<Agent?> createAgent(Agent agent) async {
    final dio = Dio();
    dio.options.headers['authorization'] = 'Bearer ${getToken()}';
    final resp = await dio.post(
      '$baseUrl/agent',
      data: agent.toJson(),
    );
    if (resp.statusCode == 201) {
      return Agent.fromJson(resp.data['data']);
    }
    return null;
  }

  Future<Agent?> updateAgent(String id, Agent agent) async {
    final dio = Dio();
    dio.options.headers['authorization'] = 'Bearer ${getToken()}';
    final resp = await dio.put(
      '$baseUrl/agent/$id',
      data: agent.toJson(),
    );
    if (resp.statusCode == 200) {
      return Agent.fromJson(resp.data['data']);
    }
    return null;
  }

  Future<bool> deleteAgent(String id) async {
    final dio = Dio();
    dio.options.headers['authorization'] = 'Bearer ${getToken()}';
    final resp = await dio.delete('$baseUrl/agent/$id');
    return resp.statusCode == 200;
  }
}
