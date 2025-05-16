import 'package:migo/models/product/product_model.dart';

class Receipt {
  final String receiptNumber;
  final DateTime dateTime;
  final String clientName;
  final List<Product> produits;
  final double total;
  final String totalInWords;
  final double paid;
  final double due;
  
  // Infos société
  final String companyName;
  final String nif;
  final String rccm;
  final String address;
  final String contact;
  final String nomCaissier;

  Receipt({
    required this.receiptNumber,
    required this.dateTime,
    required this.clientName,
    required this.produits,
    required this.total,
    required this.totalInWords,
    required this.paid,
    required this.due,
    required this.companyName,
    required this.nif,
    required this.rccm,
    required this.address,
    required this.contact,
    required this.nomCaissier,
  });

  factory Receipt.fromMap(Map<String, dynamic> map) {
    return Receipt(
      receiptNumber: map['receiptNumber'] as String,
      dateTime: DateTime.parse(map['dateTime'] as String),
      clientName: map['clientName'] as String,
      produits: (map['produits'] as List)
          .map((e) => Product.fromMap(e as Map<String, dynamic>))
          .toList(),
      total: (map['total'] as num).toDouble(),
      totalInWords: map['totalInWords'] as String,
      paid: (map['paid'] as num).toDouble(),
      due: (map['due'] as num).toDouble(),
      companyName: map['companyName'] as String,
      nif: map['nif'] as String,
      rccm: map['rccm'] as String,
      address: map['address'] as String,
      contact: map['contact'] as String,
      nomCaissier: map['nomCaissier'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'receiptNumber': receiptNumber,
      'dateTime': dateTime.toIso8601String(),
      'clientName': clientName,
      'produits': produits.map((p) => p.toMap()).toList(),
      'total': total,
      'totalInWords': totalInWords,
      'paid': paid,
      'due': due,
      'companyName': companyName,
      'nif': nif,
      'rccm': rccm,
      'address': address,
      'contact': contact,
      'nomCaissier': nomCaissier,
    };
  }
}