class User {
  final String id;
  final String name;
  final String email;
  final String token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });

  /// Crée un User depuis un JSON renvoyé par l’API
  factory User.fromJson(Map<String, dynamic> json, {required String token}) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      token: token,
    );
  }

  /// Convertit l’instance en JSON pour stockage local
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
    };
  }
}
