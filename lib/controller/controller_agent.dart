import 'package:get/get.dart';
import 'package:migo/models/agent/agent.dart';
import 'package:migo/models/authManager.dart';
import 'package:migo/service/agent_service.dart';

class AgentController extends GetxController {
  final AgentServices _svc = Get.put(AgentServices());
  final AuthenticationManager _authMgr = Get.find();

  var isLoading = false.obs;
  var isLoginLoading = false.obs;
  RxList<Agent> agents = <Agent>[].obs;
  Rxn<Agent> selectedAgent = Rxn<Agent>();

  // Pour stocker temporairement le mot de passe révélé ou nouvellement réinitialisé
  Rxn<String> revealedPassword = Rxn<String>();
  Rxn<String> resetPasswordValue = Rxn<String>();
  Rxn<String> loginToken = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    // fetchAll();
  }

     /// 1) Connexion de l’agent
  Future<bool> loginAgent(String telephone, String password) async {
    isLoginLoading.value = true;
    final token = await _svc.loginAgent(telephone, password);
    isLoginLoading.value = false;
    if (token != null) {
      loginToken.value = token;
      // C’est ici qu’on déclenche l’enregistrement du token
      _authMgr.login(token);
      return true;
    }
    return false;
  }

     /// 2) Révéler le mot de passe d’un agent (Admin only)
  Future<bool> revealPassword(String agentId, String adminPassword) async {
    isLoading.value = true;
    final pwd = await _svc.revealAgent(agentId, adminPassword);
    isLoading.value = false;
    if (pwd != null) {
      revealedPassword.value = pwd;
      return true;
    }
    revealedPassword.value = null;
    return false;
  }

     /// 3) Réinitialiser le mot de passe d’un agent (Admin only)
  Future<bool> resetPassword(String agentId, String adminPassword) async {
    isLoading.value = true;
    final pwd = await _svc.resetAgent(agentId, adminPassword);
    isLoading.value = false;
    if (pwd != null) {
      resetPasswordValue.value = pwd;
      return true;
    }
    resetPasswordValue.value = null;
    return false;
  }


  Future<void> fetchAll() async {
    isLoading.value = true;
    final list = await _svc.fetchAllAgents();
    
    if (list != null) agents.assignAll(list);
    isLoading.value = false;
  }

  // Future<void> fetchAll() async {
  //   Future.microtask(() => isLoading.value = true); // ✅ Exécute après le build

  //   final list = await _svc.fetchAllAgents();
    
  //   if (list != null) agents.assignAll(list);

  //   Future.microtask(() => isLoading.value = false); // ✅ Exécute après le build
  // }


  Future<void> fetchById(String id) async {
    isLoading.value = true;
    final agent = await _svc.fetchAgentById(id);
    selectedAgent.value = agent;
    isLoading.value = false;
  }

  // Future<void> addAgent(Agent agent) async {
  //   isLoading.value = true;
  //   final created = await _svc.createAgent(agent);
  //   if (created != null) agents.add(created);
  //   isLoading.value = false;
  // }

  /// Renvoie `true` si l'agent a bien été créé en base, `false` sinon.
  Future<bool> addAgent(Agent agent) async {
    try {
      isLoading.value = true;
      final created = await _svc.createAgent(agent);
      if (created != null) {
        // On ajoute _optionnellement_ à la liste locale (ou on appelle fetchAll ailleurs)
        agents.add(created);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }


  // Dans controller_agent.dart
  Future<Agent?> updateAgent(String id, Agent agent) async {
    isLoading.value = true;
    final updated = await _svc.updateAgent(id, agent);
    if (updated != null) {
      // Remplace l'ancien dans la liste Rx
      final idx = agents.indexWhere((a) => a.id == id);
      if (idx >= 0) agents[idx] = updated;
    }
    isLoading.value = false;
    return updated;
  }

  // Future<void> updateAgent(String id, Agent agent) async {
  //   isLoading.value = true;
  //   final updated = await _svc.updateAgent(id, agent);
  //   if (updated != null) {
  //     final idx = agents.indexWhere((a) => a.id == id);
  //     if (idx >= 0) agents[idx] = updated;
  //   }
  //   isLoading.value = false;
  // }

  // Future<void> removeAgent(String id) async {
  //   isLoading.value = true;
  //   final ok = await _svc.deleteAgent(id);
  //   if (ok) agents.removeWhere((a) => a.id == id);
  //   isLoading.value = false;
  // }

  // lib/controller/controller_agent.dart

  Future<bool> removeAgent(String id) async {
    try {
      isLoading.value = true;
      final success = await _svc.deleteAgent(id);
      if (success) {
        // Retire l’agent de la liste RxList pour mise à jour immédiate
        agents.removeWhere((a) => a.id == id);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
