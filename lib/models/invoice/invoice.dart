
import 'package:flutter/foundation.dart';
import 'package:migo/models/product/product_model.dart';

class Items {
  String? title;
  int? quantity;
  String? unitPrice;
  String? netAmount;

  Items({this.title, this.quantity, this.unitPrice, this.netAmount});

  Items.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    quantity = json['quantity'];
    unitPrice = json['unit_price'];
    netAmount = json['net_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['quantity'] = quantity;
    data['unit_price'] = unitPrice;
    data['net_amount'] = netAmount;
    return data;
  }
}

class Invoice {
  String? invoiceNumber;
  String? clientName;
  String? clientNumber;
  String? clientAddress;
  int? netAmount;
  int? paie;
  int? remaiderPaie;
  List<Items>? items;
  Map<String, dynamic>? itemsDetails;

  Invoice(
      {this.invoiceNumber,
      this.clientName,
      this.clientNumber,
      this.clientAddress,
      this.netAmount,
      this.paie,
      this.remaiderPaie,
      this.items});

  Invoice.fromJson(Map<String, dynamic> json) {
    invoiceNumber = json['invoice_number'];
    clientName = json['client_name'];
    clientNumber = json['client_number'];
    clientAddress = json['client_address'];
    netAmount = json['net_amount'];
    paie = json['amount_paie'];
    remaiderPaie = json['remaider_Paie'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['invoice_number'] = invoiceNumber;
    data['client_name'] = clientName;
    data['client_number'] = clientNumber;
    data['client_address1'] = clientAddress;
    data['net_amount'] = netAmount;
    data['amount_paie'] = paie;
    data['remaider_Paie'] = remaiderPaie;
    if (itemsDetails != null) {
      data['items'] = itemsDetails;
    }
    return data;
  }
}


/// Modèle complet d'un reçu
class Receipt {
  final String receiptNumber;
  final DateTime dateTime;
  final String clientName;
  final List<Product> product;
  final double total;
  final String totalInWords;
  final double paid;
  final double due;

  Receipt({
    required this.receiptNumber,
    required this.dateTime,
    required this.clientName,
    required this.product,
    required this.total,
    required this.totalInWords,
    required this.paid,
    required this.due,
  });

  /// Création depuis JSON ou Map
  factory Receipt.fromMap(Map<String, dynamic> map) {
    return Receipt(
      receiptNumber: map['receiptNumber'] as String,
      dateTime: DateTime.parse(map['dateTime'] as String),
      clientName: map['clientName'] as String,
    product: (map['product'] as List)
          .map((e) => Product.fromMap(e as Map<String, dynamic>))
          .toList(),
      total: (map['total'] as num).toDouble(),
      totalInWords: map['totalInWords'] as String,
      paid: (map['paid'] as num).toDouble(),
      due: (map['due'] as num).toDouble(),
    );
  }

  /// Sérialisation en Map
  Map<String, dynamic> toMap() {
    return {
      'receiptNumber': receiptNumber,
      'dateTime': dateTime.toIso8601String(),
      'clientName': clientName,
      'product': product.map((d) => d.toMap()).toList(),
      'total': total,
      'totalInWords': totalInWords,
      'paid': paid,
      'due': due,
    };
  }
}

class InvoiceCreation {
    String? invoiceNumber;
  String? clientName;
  String? clientNumber;
  String? clientAddress;
  int? netAmount;
  int? paie;
  int? remaiderPaie;
  List<Items>? items;
  Map<String, dynamic>? itemsDetails;

  InvoiceCreation(
      {this.invoiceNumber,
      this.clientName,
      this.clientNumber,
      this.clientAddress,
      this.netAmount,
      this.paie,
      this.remaiderPaie,
      this.items});

  InvoiceCreation.fromJson(Map<String, dynamic> json) {
    clientName = json['client_name'];
    clientNumber = json['client_number'];
    clientAddress = json['client_address'];
    netAmount = json['net_amount'];
    paie = json['amount_paie'];
    remaiderPaie = json['remaider_Paie'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['client_name'] = clientName;
    data['client_number'] = clientNumber;
    data['client_address'] = clientAddress;
    data['net_amount'] = netAmount;
    data['amount_paie'] = paie;
    data['remaider_Paie'] = remaiderPaie;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InvoiceApiHandler {
  int? count;
  int? next;
  int? previous;
  List<Invoice>? results;

  InvoiceApiHandler({this.count, this.next, this.previous, this.results});

  InvoiceApiHandler.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Invoice>[];
      json['results'].forEach((v) {
        results!.add(Invoice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  List<Invoice>? getInvoice() {
    return results;
  }
}
