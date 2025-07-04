// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:migo/models/cache.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthenticationManager extends GetxController with CacheManager {
  final isLogged = false.obs;

  void logOut() {
    isLogged.value = false;
    removeToken();
  }

  void login(String? token) async {
    isLogged.value = true;
    //Token is cached
    final result = await saveToken(token);
    print('▶ AuthenticationManager.login() – saveToken() returned: $result');
    print('▶ AuthenticationManager.login() – token sauvegardé : $token');
  }


  Future<void> checkLoginStatus() async {
    final token = await getToken();
    print("TOKEN  : $token");

    if (token == null) {
      print("TOKEN 1 : $token");
      isLogged.value = false;
      return;
    }

    // 1) Si le token expiré, le supprimer et déconnecter
    if (JwtDecoder.isExpired(token)) {
      print("TOKEN 2.1 : $token");
      await removeToken();
      print("TOKEN 2 : $token");
      isLogged.value = false;
      return;
    }

    // 2) Sinon, on est bon
    isLogged.value = true;
  }
}
