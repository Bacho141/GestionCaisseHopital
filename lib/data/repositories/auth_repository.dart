import '../repositories/auth_api.dart';
import '../../models/authentication/user.dart';
// import 'package:get_storage/get_storage.dart';

class AuthRepository {
  final api = AuthApi();
  // final storage = GetStorage();

  Future<User> login(String email, String password) async {
    final user = await api.login(email, password);
    // Sauvegarder en local
    // storage.write('user', user.toJson());
    // storage.write('jwt', user.token);
    print("DATA: ${user.token}");
    return user;
  }

  Future<User> signup(
      String firstname, String name, String email, String password) async {
    final user = await api.signup(firstname, name, email, password);
    // storage.write('user', user.toJson());
    // storage.write('jwt', user.token);
    print("INSCRIPTION : $user");
    return user;
  }
}
