// import 'package:get/get.dart';
// import 'package:migo/models/authentication/user.dart';
// import 'package:migo/models/agent/agent.dart';
// import 'package:migo/models/authManager.dart';
// import 'package:migo/service/service_agent.dart';
// import '../data/repositories/auth_repository.dart';

// class AuthController extends GetxController {
//   final AuthRepository _adminRepo = AuthRepository();
//   final AgentServices _agentSvc = Get.put(AgentServices());
//   final AuthenticationManager _authMgr = Get.put(AuthenticationManager());

//   var adminUser = Rxn<User>();
//   var agentUser = Rxn<Agent>();
//   var loading = false.obs;

//   /// Rôle courant : 'Admin' ou 'Agent'
//   RxString userRole = ''.obs;

//   /// Login Admin (email/password)
//   Future<void> loginAdmin(String email, String password) async {
//     loading.value = true;
//     try {
//       final userData = await _adminRepo.login(email, password);
//       if (userData != null) {
//         userRole.value = 'Admin';
//         print("userRole : ${userRole.value}");
//         adminUser.value = userData;
//         _authMgr.login(userData.token);
//       } else {
//         Get.snackbar('Erreur', 'Identifiants admin invalides');
//       }
//     } catch (e) {
//       Get.snackbar('Erreur de connexion', e.toString());
//     } finally {
//       loading.value = false;
//     }
//   }

//   /// Login Agent (téléphone/password)
//   Future<void> loginAgent(String phone, String password) async {
//     // loading.value = true;
//     try {
//       final token = await _agentSvc.loginAgent(phone, password);
//       print("agentUser token: $token");
//       if (token != null) {
//         // Pour les agents, on crée un Agent minimal et on stocke le token
//         userRole.value = 'Agent';
//         print("userRole : ${userRole.value}");
//         agentUser.value = Agent(
//           id: null,
//           nom: '',
//           prenom: '',
//           adresse: '',
//           telephone: phone,
//           role: 'Agent',
//         );
//         _authMgr.login(token);
//         print("agentUser 1: $agentUser");
//       } else {
//         Get.snackbar('Erreur', 'Téléphone ou mot de passe invalide');
//         print("agentUser 2: $agentUser");
//       }
//     } catch (e) {
//       Get.snackbar('Erreur de connexion', e.toString());
//       print("agentUser 3: $e");
//     }
//   }

//   void logout() {
//     _authMgr.logOut();
//     print("Déconnexion: $agentUser");
//     adminUser.value = null;
//     agentUser.value = null;
//   }

//   Future<void> signup(String name, String email, String password) async {
//     loading.value = true;
//     try {
//       final u = await _adminRepo.signup(name, email, password);
//       adminUser.value = u;
//       print("INSCRIPTION : $u");
//       Get.find<AuthenticationManager>().login(u.token);
//     } on Exception catch (err) {
//       Get.snackbar(
//         'Erreur inscription',
//         err.toString().replaceFirst('Exception: ', ''),
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       loading.value = false;
//     }
//   }
// }


import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:migo/models/authentication/user.dart';
import 'package:migo/models/agent/agent.dart';
import 'package:migo/models/authManager.dart';
import 'package:migo/service/agent_service.dart';
import '../data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository    _adminRepo = AuthRepository();
  final AgentServices     _agentSvc  = Get.put(AgentServices());
  final AuthenticationManager _authMgr = Get.find();

  var adminUser  = Rxn<User>();
  var agentUser  = Rxn<Agent>();
  var loading = false.obs;
  // RxBool loading = false.obs;

  /// Rôle courant : 'Admin' ou 'Agent'
  RxString userRole = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _hydrateUserRole(); // ← appelle la fonction d’initialisation
  }

  /// Lit le token stocké et en extrait le rôle pour initialiser userRole
  Future<void> _hydrateUserRole() async {
    final token = await _authMgr.getToken();
    print('▶ _hydrateUserRole() – token récupéré : $token');

    if (token != null && token.isNotEmpty && !JwtDecoder.isExpired(token)) {
      final decoded = JwtDecoder.decode(token);
      print('▶ _hydrateUserRole() – contenu décodé du JWT : $decoded');
      userRole.value = decoded['role'] ?? '';
      print('▶ userRole.value mis à : ${userRole.value}');
    } else {
      print('▶ _hydrateUserRole() – pas de token ou token expiré');
    }
  }

  /// Login Admin (email/password)
  Future<void> loginAdmin(String email, String password) async {
    try {
      final userData = await _adminRepo.login(email, password);
      if (userData != null) {
        adminUser.value = userData;
        userRole.value = 'Admin';             
        _authMgr.login(userData.token);
      } else {
        Get.snackbar('Erreur', 'Identifiants admin invalides');
      }
    } catch (e) {
      Get.snackbar('Erreur de connexion', e.toString());
    }
  }

  /// Login Agent (téléphone/password)
  Future<void> loginAgent(String phone, String password) async {
    try {
      final token = await _agentSvc.loginAgent(phone, password);
      if (token != null) {
        agentUser.value = Agent(
          id: null,
          nom: '',
          prenom: '',
          adresse: '',
          telephone: phone,
          role: 'Agent',
        );
        userRole.value = 'Agent';            
        _authMgr.login(token);
      } else {
        Get.snackbar('Erreur', 'Téléphone ou mot de passe invalide');
      }
    } catch (e) {
      Get.snackbar('Erreur de connexion', e.toString());
    }
  }

  void logout() {
    _authMgr.logOut();
    adminUser.value = null;
    agentUser.value = null;
    userRole.value = ''; // réinitialise le rôle
  }

  Future<void> signup(String name, String email, String password) async {
    loading.value = true;
    try {
      final u = await _adminRepo.signup(name, email, password);
      adminUser.value = u;
      print("INSCRIPTION : $u");
      Get.find<AuthenticationManager>().login(u.token);
    } on Exception catch (err) {
      Get.snackbar(
        'Erreur inscription',
        err.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      loading.value = false;
    }
  }
}
