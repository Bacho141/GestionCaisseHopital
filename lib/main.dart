import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:migo/utils/theme_config.dart';
import 'package:migo/view/products/billing/billing.dart';
import 'package:migo/view/splash.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:window_manager/window_manager.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized(); // Initialisation correcte

    WindowOptions windowOptions = const WindowOptions(
      minimumSize: Size(1310, 730), // Taille minimale
      maximumSize: Size(1920, 1080), // Taille maximale (optionnel)
      center: true, // Centrer la fenêtre au démarrage
      fullScreen: false, // Empêcher le mode plein écran forcé
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.setResizable(
          true); // Autoriser le redimensionnement mais avec limites
    });
  }

  await GetStorage.init(); // Initialisation du stockage
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

    const QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      setState(() {
        if (shortcutType != null) {
          shortcut = shortcutType;
        }
      });
    });

    quickActions.setShortcutItems([
      const ShortcutItem(
        type: 'create_bill',
        localizedTitle: 'Create a bill',
        icon: 'icon_reciept_long',
      ),
    ]).then((void _) {
      setState(() {
        if (shortcut == 'no action set') {
          shortcut = 'actions ready';
        }
      });
    });
    quickActions.initialize((type) {
      if (type == 'create_bill') {
        Get.to(() => const Billing(isMobile: true));
      }
    });
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
