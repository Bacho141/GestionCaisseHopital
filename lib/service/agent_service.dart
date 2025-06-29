import 'package:dio/dio.dart';
import 'package:get/get_connect/connect.dart' hide Response;
import 'package:migo/models/cache.dart';
import 'package:migo/models/agent/agent.dart';
import 'package:migo/utils/config.dart';
import 'package:migo/utils/error_handler.dart';

class AgentServices extends GetConnect with CacheManager {
  final String baseUrl = AppConfig.baseUrl;

  /// 1) Login agent (renvoie token)
  Future<String?> loginAgent(String telephone, String password) async {
    try {
      print('🌐 AGENT_SERVICE - Tentative de connexion pour: $telephone');
      
      final dio = Dio();
      final resp = await dio.post(
        '$baseUrl/agent/login',
        data: {'telephone': telephone, 'password': password},
        options: Options(validateStatus: (_) => true),
      );
      
      // Ne jette plus sur 401, on gère nous-mêmes :
      if (resp.statusCode == 200 && resp.data['success'] == true) {
        final token = resp.data['data']['token'] as String;
        print('✅ AGENT_SERVICE - Connexion réussie pour: $telephone');
        print('   🔑 Token reçu: ${token.substring(0, 20)}...');
        return token;
      }
      
      // Ici code 401 ou autre → on considère que c'est un échec de login
      print('❌ AGENT_SERVICE - Échec de connexion pour: $telephone');
      print('   📊 Status: ${resp.statusCode}');
      print('   📊 Response: ${resp.data}');
      return null;
    } on DioException catch (error) {
      print('❌ AGENT_SERVICE - Erreur Dio lors de la connexion agent');
      ErrorHandler.handleDioError(error);
      return null;
    } catch (error) {
      print('❌ AGENT_SERVICE - Erreur inattendue lors de la connexion agent');
      ErrorHandler.logError('AgentServices.loginAgent', error);
      return null;
    }
  }

  /// 2) Reveal password (Admin must pass own password)
  Future<String?> revealAgent(String id, String adminPassword) async {
    try {
      print('🔍 AGENT_SERVICE - Tentative de révélation du mot de passe pour agent: $id');
      
      final dio = Dio();
      // 1) Récupère le token via CacheManager
      final token = await getToken();
      dio.options.headers['authorization'] = 'Bearer $token';
      
      final resp = await dio.post(
        '$baseUrl/agent/$id/reveal',
        data: {'adminPassword': adminPassword},
        // 2) Autorise de ne pas throw automatiquement sur 403
        options: Options(validateStatus: (_) => true),
      );
      
      if (resp.statusCode == 200 && resp.data['success'] == true) {
        final password = resp.data['data']['rawPassword'] as String;
        print('✅ AGENT_SERVICE - Mot de passe révélé pour agent: $id');
        return password;
      }
      
      print('❌ AGENT_SERVICE - Échec de révélation pour agent: $id');
      print('   📊 Status: ${resp.statusCode}');
      print('   📊 Response: ${resp.data}');
      return null;
    } on DioException catch (error) {
      print('❌ AGENT_SERVICE - Erreur Dio lors de la révélation');
      ErrorHandler.handleDioError(error);
      return null;
    } catch (error) {
      print('❌ AGENT_SERVICE - Erreur inattendue lors de la révélation');
      ErrorHandler.logError('AgentServices.revealAgent', error);
      return null;
    }
  }

  /// 3) Reset password (Admin must pass own password)
  Future<String?> resetAgent(String id, String adminPassword) async {
    try {
      print('🔄 AGENT_SERVICE - Tentative de reset du mot de passe pour agent: $id');
      
      final dio = Dio();
      final token = await getToken();
      dio.options.headers['authorization'] = 'Bearer $token';

      final resp = await dio.post(
        '$baseUrl/agent/$id/reset',
        data: {'adminPassword': adminPassword},
        options: Options(validateStatus: (_) => true),
      );
      
      if (resp.statusCode == 200 && resp.data['success'] == true) {
        final password = resp.data['data']['rawPassword'] as String;
        print('✅ AGENT_SERVICE - Mot de passe reset pour agent: $id');
        return password;
      }
      
      print('❌ AGENT_SERVICE - Échec de reset pour agent: $id');
      print('   📊 Status: ${resp.statusCode}');
      print('   📊 Response: ${resp.data}');
      return null;
    } on DioException catch (error) {
      print('❌ AGENT_SERVICE - Erreur Dio lors du reset');
      ErrorHandler.handleDioError(error);
      return null;
    } catch (error) {
      print('❌ AGENT_SERVICE - Erreur inattendue lors du reset');
      ErrorHandler.logError('AgentServices.resetAgent', error);
      return null;
    }
  }

  /// 4) Fetch all agents (existant)
  Future<List<Agent>?> fetchAllAgents() async {
    try {
      print('📋 AGENT_SERVICE - Récupération de tous les agents');
      
      final dio = Dio();

      // 1) Récupérer réellement le token
      final token = await getToken(); 
      if (token == null) {
        print('❌ AGENT_SERVICE - Pas de token en cache');
        return null;
      }

      // 2) Injecter le bon header
      dio.options.headers['Authorization'] = 'Bearer $token';

      // 3) Facultatif : ne pas throw sur 401 pour inspecter la réponse
      dio.options.validateStatus = (status) => status! < 500;

      // 4) Appel de l'API
      final resp = await dio.get('$baseUrl/agent');
      print('📊 AGENT_SERVICE - Status code: ${resp.statusCode}');
      print('📊 AGENT_SERVICE - Body: ${resp.data}');

      // 5) Traitement
      if (resp.statusCode == 200) {
        final list = (resp.data['data'] as List?) ?? [];
        final agents = list.map((e) => Agent.fromJson(e)).toList();
        print('✅ AGENT_SERVICE - ${agents.length} agents récupérés');
        return agents;
      } else if (resp.statusCode == 401) {
        // 401 confirmé : token invalide / expiré
        print('❌ AGENT_SERVICE - Token invalide/expiré');
        return null;
      }

      print('❌ AGENT_SERVICE - Échec de récupération des agents');
      print('   📊 Status: ${resp.statusCode}');
      return null;
    } on DioException catch (error) {
      print('❌ AGENT_SERVICE - Erreur Dio lors de la récupération des agents');
      ErrorHandler.handleDioError(error);
      return null;
    } catch (error) {
      print('❌ AGENT_SERVICE - Erreur inattendue lors de la récupération des agents');
      ErrorHandler.logError('AgentServices.fetchAllAgents', error);
      return null;
    }
  }

  Future<Agent?> fetchAgentById(String id) async {
    try {
      print('🔍 AGENT_SERVICE - Récupération de l\'agent: $id');
      
      final dio = Dio();
      dio.options.headers['authorization'] = 'Bearer ${getToken()}';
      final resp = await dio.get('$baseUrl/caissiers/$id');
      
      if (resp.statusCode == 200) {
        final agent = Agent.fromJson(resp.data['data']);
        print('✅ AGENT_SERVICE - Agent récupéré: ${agent.nom} ${agent.prenom}');
        return agent;
      }
      
      print('❌ AGENT_SERVICE - Échec de récupération de l\'agent: $id');
      print('   📊 Status: ${resp.statusCode}');
      return null;
    } on DioException catch (error) {
      print('❌ AGENT_SERVICE - Erreur Dio lors de la récupération de l\'agent');
      ErrorHandler.handleDioError(error);
      return null;
    } catch (error) {
      print('❌ AGENT_SERVICE - Erreur inattendue lors de la récupération de l\'agent');
      ErrorHandler.logError('AgentServices.fetchAgentById', error);
      return null;
    }
  }

  Future<Agent?> createAgent(Agent agent) async {
    try {
      print('➕ AGENT_SERVICE - Création d\'un nouvel agent');
      print('   👤 Nom: ${agent.nom} ${agent.prenom}');
      print('   📱 Téléphone: ${agent.telephone}');
      
      final dio = Dio();
      dio.options.headers['authorization'] = 'Bearer ${getToken()}';
      final resp = await dio.post(
        '$baseUrl/agent',
        data: agent.toJson(),
      );
      
      if (resp.statusCode == 201) {
        final newAgent = Agent.fromJson(resp.data['data']);
        print('✅ AGENT_SERVICE - Agent créé avec succès');
        print('   🆔 ID: ${newAgent.id}');
        return newAgent;
      }
      
      print('❌ AGENT_SERVICE - Échec de création de l\'agent');
      print('   📊 Status: ${resp.statusCode}');
      return null;
    } on DioException catch (error) {
      print('❌ AGENT_SERVICE - Erreur Dio lors de la création de l\'agent');
      ErrorHandler.handleDioError(error);
      return null;
    } catch (error) {
      print('❌ AGENT_SERVICE - Erreur inattendue lors de la création de l\'agent');
      ErrorHandler.logError('AgentServices.createAgent', error);
      return null;
    }
  }

  Future<Agent?> updateAgent(String id, Agent agent) async {
    try {
      print('✏️ AGENT_SERVICE - Mise à jour de l\'agent: $id');
      
      final dio = Dio();
      dio.options.headers['authorization'] = 'Bearer ${getToken()}';
      final resp = await dio.put(
        '$baseUrl/agent/$id',
        data: agent.toJson(),
      );
      
      if (resp.statusCode == 200) {
        final updatedAgent = Agent.fromJson(resp.data['data']);
        print('✅ AGENT_SERVICE - Agent mis à jour avec succès');
        return updatedAgent;
      }
      
      print('❌ AGENT_SERVICE - Échec de mise à jour de l\'agent: $id');
      print('   📊 Status: ${resp.statusCode}');
      return null;
    } on DioException catch (error) {
      print('❌ AGENT_SERVICE - Erreur Dio lors de la mise à jour de l\'agent');
      ErrorHandler.handleDioError(error);
      return null;
    } catch (error) {
      print('❌ AGENT_SERVICE - Erreur inattendue lors de la mise à jour de l\'agent');
      ErrorHandler.logError('AgentServices.updateAgent', error);
      return null;
    }
  }

  Future<bool> deleteAgent(String id) async {
    try {
      print('🗑️ AGENT_SERVICE - Suppression de l\'agent: $id');
      
      final dio = Dio();
      dio.options.headers['authorization'] = 'Bearer ${getToken()}';
      final resp = await dio.delete('$baseUrl/agent/$id');
      
      if (resp.statusCode == 200) {
        print('✅ AGENT_SERVICE - Agent supprimé avec succès');
        return true;
      }
      
      print('❌ AGENT_SERVICE - Échec de suppression de l\'agent: $id');
      print('   📊 Status: ${resp.statusCode}');
      return false;
    } on DioException catch (error) {
      print('❌ AGENT_SERVICE - Erreur Dio lors de la suppression de l\'agent');
      ErrorHandler.handleDioError(error);
      return false;
    } catch (error) {
      print('❌ AGENT_SERVICE - Erreur inattendue lors de la suppression de l\'agent');
      ErrorHandler.logError('AgentServices.deleteAgent', error);
      return false;
    }
  }
}
