// import 'package:migo/models/servicemedical/product_model.dart';
import 'package:migo/models/receipt/client_patient.dart';
import 'package:migo/models/receipt/receipt_cart_model.dart';

class Receipt {
  final String receiptNumber;
  final DateTime dateTime;
  // final List<Product>  clientName;
  Client client;
  List<ReceiptItem> produits;
  double total;
  String totalInWords;
  double paid;
  double due;

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
    required this.client,
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
    print('↪️ Receipt.fromMap reçu : $map');

    // Gestion de l'incohérence entre receiptNumber et receiptNummber
    String receiptNumber;
    if (map.containsKey('receiptNumber')) {
      receiptNumber = map['receiptNumber'] as String;
    } else if (map.containsKey('receiptNummber')) {
      receiptNumber = map['receiptNummber'] as String;
      print('⚠️ Correction: receiptNummber -> receiptNumber: $receiptNumber');
    } else {
      throw Exception(
          'Champ "receiptNumber" ou "receiptNummber" manquant dans la réponse');
    }

    // Sécurité : s'assurer que map['client'] est un Map<String, dynamic>
    final clientMap = map['client'];
    if (clientMap == null || clientMap is! Map) {
      throw Exception('Champ "client" manquant ou mal formé dans la réponse');
    }

    // Convertir proprement en Map<String, dynamic>
    final clientData = Map<String, dynamic>.from(clientMap as Map);

    // Sécurité : map['produits'] doit être une List
    final produitsList = map['produits'];
    if (produitsList == null || produitsList is! List) {
      throw Exception('Champ "produits" manquant ou mal formé dans la réponse');
    }
    final produitsData = (produitsList as List)
        .map((e) => ReceiptItem.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();

    return Receipt(
      receiptNumber: receiptNumber,
      dateTime: DateTime.parse(map['dateTime'] as String),
      client: Client.fromMap(clientData),
      produits: produitsData,
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
      'client': client.toMap(),
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

// lib/models/receipt/receipt_model.dart

// class Receipt {
//   String receiptNumber;
//   DateTime dateTime;
//   Client client;
//   List<ReceiptItem> produits;  // Changed to ReceiptItem
//   double total;
//   String totalInWords;
//   double paid;
//   double due;
//   String companyName;
//   String nif;
//   String rccm;
//   String address;
//   String contact;
//   String nomCaissier;

//   Receipt({
//     required this.receiptNumber,
//     required this.dateTime,
//     required this.client,
//     required this.produits,
//     required this.total,
//     required this.totalInWords,
//     required this.paid,
//     required this.due,
//     required this.companyName,
//     required this.nif,
//     required this.rccm,
//     required this.address,
//     required this.contact,
//     required this.nomCaissier,
//   });

//   factory Receipt.fromMap(Map<String, dynamic> map) {
//     return Receipt(
//       receiptNumber: map['receiptNumber'] as String,
//       dateTime: DateTime.parse(map['dateTime'] as String),
//       client: Client.fromMap(map['client'] as Map<String, dynamic>),
//       produits: (map['produits'] as List)
//           .map((e) => ReceiptItem.fromMap(e as Map<String, dynamic>))
//           .toList(),
//       total: (map['total'] as num).toDouble(),
//       totalInWords: map['totalInWords'] as String,
//       paid: (map['paid'] as num).toDouble(),
//       due: (map['due'] as num).toDouble(),
//       companyName: map['companyName'] as String,
//       nif: map['nif'] as String,
//       rccm: map['rccm'] as String,
//       address: map['address'] as String,
//       contact: map['contact'] as String,
//       nomCaissier: map['nomCaissier'] as String,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'receiptNumber': receiptNumber,
//       'dateTime': dateTime.toIso8601String(),
//       'client': client.toMap(),
//       'produits': produits.map((p) => p.toMap()).toList(),
//       'total': total,
//       'totalInWords': totalInWords,
//       'paid': paid,
//       'due': due,
//       'companyName': companyName,
//       'nif': nif,
//       'rccm': rccm,
//       'address': address,
//       'contact': contact,
//       'nomCaissier': nomCaissier,
//     };
//   }
// }
