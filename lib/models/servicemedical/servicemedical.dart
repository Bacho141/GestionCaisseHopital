class Product {
  final String id; 
  final String category; 
  String label;
  String  tarif;
  final String? icon;

  Product({
    required this.id,
    required this.category,
    required this.label,
    required this.tarif,
    this.icon,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] as String,
      category: json['category'] as String,
      label: json['label'] as String,
      tarif: json['tarif'].toString(),
      icon: json['icon'] as String?,
    );
  }
 

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id; 
    data['tarif'] = tarif;
    data['icon'] = icon;
    data['label'] = label;
    data['category'] = category;
    return data;
  }
}

class Keyword {
  String? category;
  String? query;

  Keyword({this.category, this.query});

  Keyword.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    query = json['query'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    data['query'] = query;
    return data;
  }
}

