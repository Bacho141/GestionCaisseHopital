// ignore_for_file: file_names, constant_identifier_names

import 'package:get_storage/get_storage.dart';

mixin CacheManager {
  Future<bool> saveToken(String? token) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.TOKEN.toString(), token);
    print('▶ CacheManager.saveToken() – écrit [key] = $token');
    return true;
  }

  // String? getToken() {
  //   final box = GetStorage();
  //   return box.read(CacheManagerKey.TOKEN.toString());
  // }

  // Future<void> removeToken() async {
  //   final box = GetStorage();
  //   await box.remove(CacheManagerKey.TOKEN.toString());
  // }

  Future<String?> getToken() async {
    final box = GetStorage();
    final key = CacheManagerKey.TOKEN.toString();
    final t = box.read(key);
    print('▶ CacheManager.getToken() – lit  [$key] = $t');
    return t;
  }

  Future<void> removeToken() async {
    final box = GetStorage();
    final key = CacheManagerKey.TOKEN.toString();
    await box.remove(key);
    print('▶ CacheManager.removeToken() – supprimé clé [$key]');
  }
}

enum CacheManagerKey { TOKEN }
