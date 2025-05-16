class Product {
   final String category; 
  String label;
  String  tarif;
  final String? icon;

  Product(
      {required this.category,
    required this.label,
    required this.tarif,
    this.icon,});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      category: json['category'] as String,
      label: json['label'] as String,
      tarif: json['tarif'].toString(),
      icon: json['icon'] as String?,
    );
  }
 

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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

// class Service {
//   final String label;
//   final String tarif;
//   final String category;
//   final IconData? iconData;

//   Service({
//     required this.label,
//     required this.tarif,
//     required this.category,
//     this.iconData,
//   });

//   factory Service.fromJson(Map<String, dynamic> json) {
//     final icon = json['icon'];
//     IconData? iconData;
//     if (icon != null && icon['codePoint'] != null) {
//       iconData = IconData(
//         icon['codePoint'] as int,
//         fontFamily: 'MaterialIcons',
//       );
//     }
//     return Service(
//       label: json['label'] as String,
//       tarif: json['tarif'] as String,
//       category: json['category'] as String,
//       iconData: iconData,
//     );
//   }
// }

