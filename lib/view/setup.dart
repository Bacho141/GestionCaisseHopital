import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:migo/models/authManager.dart';
import 'package:migo/view/auth/login.dart';
import 'package:migo/view/auth/agent_login.dart';
import 'package:migo/view/onboarding/onboarding.dart';
import 'package:migo/view/home/home_dashboard.dart';

class OnStart extends StatelessWidget {
  const OnStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticationManager authManager = Get.find();
    final onboardingOnce = GetStorage();

    return Obx(() {
      return authManager.isLogged.value
          ? onboardingOnce.read('onboarded') ?? false
              ? const DashboardPage()
              : const Onboarding()
          : const AgentLoginView();
    });
  }
}
