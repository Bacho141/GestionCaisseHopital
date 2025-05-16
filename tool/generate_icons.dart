// tool/generate_icons.dart
import 'dart:io';

void main() {
  // 1) Chemin vers votre SDK Flutter local
  final flutterSdk = Platform.environment['FLUTTER_SDK'];
  if (flutterSdk == null) {
    stderr.writeln('Erreur : la variable d’environnement FLUTTER_SDK doit pointer sur votre Flutter SDK');
    exit(1);
  }
  final iconsDartPath = '$flutterSdk/packages/flutter/lib/src/material/icons.dart';

  // 2) Où écrire le mapping généré
  final outputPath = 'lib/icon_mapping.dart';

  final file = File(iconsDartPath);
  if (!file.existsSync()) {
    stderr.writeln('icons.dart introuvable à : $iconsDartPath');
    exit(1);
  }

  final lines = file.readAsLinesSync();
  final buffer = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY')
    ..writeln("import 'package:flutter/widgets.dart';")
    ..writeln('')
    ..writeln('const Map<String, IconData> iconMapping = {');

  // 3) Extrait chaque définition IconData
  final regex = RegExp(r"static const IconData (\\w+) = IconData\\(0x([0-9a-fA-F]+), fontFamily: 'MaterialIcons'\\);");
  for (var line in lines) {
    final m = regex.firstMatch(line);
    if (m != null) {
      final name = m.group(1);
      final hex = m.group(2);
      buffer.writeln("  '$name': IconData(0x$hex, fontFamily: 'MaterialIcons'),");
    }
  }

  buffer.writeln('};');

  // 4) Écrit le fichier de mapping
  File(outputPath).writeAsStringSync(buffer.toString());
  print('✅ icon_mapping.dart généré avec ${buffer.toString().split('\n').length} lignes.');
}
