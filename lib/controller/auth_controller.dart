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
import 'package:migo/utils/message_manager.dart';
import 'package:migo/utils/error_handler.dart';
import '../data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _adminRepo = AuthRepository();
  final AgentServices _agentSvc = Get.put(AgentServices());
  final AuthenticationManager _authMgr = Get.find();

  var adminUser = Rxn<User>();
  var agentUser = Rxn<Agent>();
  var loading = false.obs;

  /// Rôle courant : 'Admin' ou 'Agent'
  RxString userRole = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _hydrateUserRole(); // ← appelle la fonction d'initialisation
  }

  /// Lit le token stocké et en extrait le rôle pour initialiser userRole
  Future<void> _hydrateUserRole() async {
    try {
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
    } catch (error) {
      ErrorHandler.logError('_hydrateUserRole', error);
    }
  }

  /// Login Admin (email/password)
  Future<void> loginAdmin(String email, String password) async {
    loading.value = true;
    try {
      print('🔐 LOGIN_ADMIN - Tentative de connexion pour: $email');
      
      final userData = await _adminRepo.login(email, password);
      if (userData != null) {
        adminUser.value = userData;
        userRole.value = 'Admin';
        _authMgr.login(userData.token);
        
        print('✅ LOGIN_ADMIN - Connexion réussie pour: $email');
        print('   👤 User: ${userData.firstname} ${userData.name}');
        print('   🎭 Role: ${userData.role}');
      } else {
        print('❌ LOGIN_ADMIN - Identifiants invalides pour: $email');
        MessageManager.showAuthError(
          title: 'Échec de connexion',
          message: MessageTexts.invalidCredentials,
        );
      }
    } catch (error) {
      ErrorHandler.logError('loginAdmin', error);
      
      if (error.toString().contains('Exception:')) {
        // Erreur du backend
        final message = error.toString().replaceFirst('Exception: ', '');
        MessageManager.showAuthError(
          title: 'Erreur de connexion',
          message: message,
        );
      } else {
        // Erreur réseau ou autre
        MessageManager.showNetworkError(
          title: 'Erreur de connexion',
          message: MessageTexts.networkError,
        );
      }
    } finally {
      loading.value = false;
    }
  }

  /// Login Agent (téléphone/password)
  Future<void> loginAgent(String phone, String password) async {
    loading.value = true;
    try {
      print('🔐 LOGIN_AGENT - Tentative de connexion pour: $phone');
      
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
        
        print('✅ LOGIN_AGENT - Connexion réussie pour: $phone');
        print('   📱 Téléphone: $phone');
        print('   🎭 Role: Agent');
      } else {
        print('❌ LOGIN_AGENT - Identifiants invalides pour: $phone');
        MessageManager.showAuthError(
          title: 'Échec de connexion',
          message: MessageTexts.invalidCredentials,
        );
      }
    } catch (error) {
      ErrorHandler.logError('loginAgent', error);
      
      if (error.toString().contains('Exception:')) {
        // Erreur du backend
        final message = error.toString().replaceFirst('Exception: ', '');
        MessageManager.showAuthError(
          title: 'Erreur de connexion',
          message: message,
        );
      } else {
        // Erreur réseau ou autre
        MessageManager.showNetworkError(
          title: 'Erreur de connexion',
          message: MessageTexts.networkError,
        );
      }
    } finally {
      loading.value = false;
    }
  }

  void logout() {
    try {
      print('🚪 LOGOUT - Déconnexion de l\'utilisateur');
      print('   👤 Role avant déconnexion: ${userRole.value}');
      
      _authMgr.logOut();
      adminUser.value = null;
      agentUser.value = null;
      userRole.value = ''; // réinitialise le rôle
      
      print('✅ LOGOUT - Déconnexion réussie');
      
      MessageManager.showSuccess(
        title: 'Déconnexion',
        message: MessageTexts.logoutSuccess,
      );
    } catch (error) {
      ErrorHandler.logError('logout', error);
    }
  }

  Future<void> signup(
      String firstname, String name, String email, String password) async {
    loading.value = true;
    try {
      print('📝 SIGNUP - Tentative d\'inscription');
      print('   👤 Prénom: $firstname');
      print('   👤 Nom: $name');
      print('   📧 Email: $email');
      print('   🔐 Password: ${'*' * password.length}');
      print("▶ Début inscription - userRole avant: ${userRole.value}");
      
      final u = await _adminRepo.signup(firstname, name, email, password);
      adminUser.value = u;

      // Utiliser le rôle du token plutôt que de le définir manuellement
      if (u.token != null) {
        final decoded = JwtDecoder.decode(u.token);
        print("▶ Token décodé après inscription: $decoded");
        print("▶ Rôle dans le token: ${decoded['role']}");
        userRole.value =
            decoded['role'] ?? 'Admin'; // Fallback sur 'Admin' si pas de rôle
      } else {
        userRole.value = 'Admin'; // Fallback si pas de token
      }

      print("▶ INSCRIPTION réussie: $u");
      print("▶ userRole après inscription: ${userRole.value}");
      print("▶ adminUser.value: ${adminUser.value}");
      Get.find<AuthenticationManager>().login(u.token);
      
      print('✅ SIGNUP - Inscription réussie pour: $email');
    } on Exception catch (err) {
      ErrorHandler.logError('signup', err);
      print("▶ Erreur lors de l'inscription: $err");
      
      final message = err.toString().replaceFirst('Exception: ', '');
      MessageManager.showValidationError(
        title: 'Erreur d\'inscription',
        message: message,
      );
    } finally {
      loading.value = false;
    }
  }
}
