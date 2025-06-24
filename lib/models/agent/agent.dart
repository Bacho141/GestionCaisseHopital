class Agent {
  final String? id;     // null lors de la création
  String nom;
  String prenom;
  String adresse;
  String telephone;
  String role;
  String? rawPassword;

  Agent({
    this.id,
    required this.nom,
    required this.prenom,
    required this.adresse,
    required this.telephone,
    this.role = 'Agent',
    this.rawPassword,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: (json['_id'] as String?) ?? (json['id'] as String?),
      nom: json['nom']  as String,
      prenom: json['prenom']  as String,
      adresse: json['adresse']  as String,
      telephone: json['telephone']  as String,
      role: json['role']  as String? ?? 'Agent',
      rawPassword: json['rawPassword'] as String?,
    );
  }


  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'nom': nom,
      'prenom': prenom,
      'adresse': adresse,
      'telephone': telephone,
      'role': role,
    };
    if (id != null) {
      data['_id'] = id;
    }
    return data;
  }

}
