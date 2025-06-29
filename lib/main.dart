import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:migo/utils/theme_config.dart';
import 'package:migo/view/splash.dart';
// import 'package:quick_actions/quick_actions.dart';
import 'package:window_manager/window_manager.dart';
import 'package:migo/controller/auth_controller.dart';
import 'package:migo/models/authManager.dart';
import 'package:intl/date_symbol_data_local.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ---------- Initialisation de intl pour les locales ----------
  await initializeDateFormatting('fr_FR', null);
  print('▶ Intl initialisé pour fr_FR ✅');

  // ---------- Initialisation de GetStorage (très important) ----------
  await GetStorage.init();
  print('▶ GetStorage initialisé ✅');

  Get.put(AuthenticationManager());
  Get.put(AuthController());
  final authCtrl = Get.find<AuthController>();
  print('▶ AuthController initialisé dans main: $authCtrl');

  if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
    try {
      await windowManager.ensureInitialized(); // Initialisation correcte

      WindowOptions windowOptions = const WindowOptions(
        minimumSize: Size(1310, 730), // Taille minimale
        maximumSize: Size(1920, 1080), // Taille maximale (optionnel)
        center: true, // Centrer la fenêtre au démarrage
        fullScreen: false, // Empêcher le mode plein écran forcé
      );

      await windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.setResizable(
            true); // Autoriser le redimensionnement mais avec limites
      });
    } catch (e) {
      print('▶ Erreur lors de l\'initialisation de windowManager: $e');
    }
  }

  // Pas besoin de réinitialiser GetStorage ici
  runApp(const MiGo());
}

class MiGo extends StatefulWidget {
  const MiGo({super.key});

  @override
  State<MiGo> createState() => _MiGoState();
}

class _MiGoState extends State<MiGo> {
  String shortcut = 'no action set';

  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MiGo',
      debugShowCheckedModeBanner: false,
      theme: mainTheme,
      home: SplashView(),
    );
  }
}
