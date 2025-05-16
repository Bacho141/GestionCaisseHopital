// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:migo/models/authManager.dart';
import '../data/repositories/auth_repository.dart';
import '../../models/authentication/user.dart';
// import 'package:migo/models/authManager.dart';
// import 'package:migo/models/authentication/login_request_model.dart';
// import 'package:migo/service/login_service.dart';

class AuthController extends GetxController {
  final repo = AuthRepository();
  var user = Rxn<User>();
  var loading = false.obs;


  Future<void> login(String email, String password) async {
    loading.value = true;
    try {
      final u = await repo.login(email, password);
      user.value = u;
      Get.find<AuthenticationManager>().login(u.token);
      // navigation gérée ailleurs
    } on Exception catch (err) {
      // Affiche directement le message levé plus haut
      Get.snackbar(
        'Erreur de connexion',
        err.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> signup(String name, String email, String password) async {
    loading.value = true;
    try {
      final u = await repo.signup(name, email, password);
      user.value = u;
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