class Service {
  final String category; 
  String label;
  String  tarif;
  final String? icon;

  Service({
    required this.category,
    required this.label,
    required this.tarif,
    this.icon,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      category: json['category'] as String,
      label: 
        json['TypeExamen']   != null ? json['TypeExamen'] as String :
        json['Acte']         != null ? json['Acte'] as String :
        json['Type_prestation'] as String,
      tarif: json['Tarif'] as String ,
      icon: json['icon'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{
      'Tarif': tarif,
      'icon': icon,
      'category': category,
    };
    if (category == 'examens_de_laboratoire') {
      m['TypeExamen'] = label;
    } else if (category == 'actes_medico_chirurgicaux') {
         m['Acte'] = label;
   } else {
       m['Type_prestation'] = label;
    }
    return m;
  }
}
