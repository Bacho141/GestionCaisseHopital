import 'package:migo/models/servicemedical/servicemedical.dart';

class ApiHandler {
  int? count;
  int? next;
  int? previous;
  List<Product>? allProducts;

  ApiHandler({this.count, this.next, this.previous, this.allProducts});

  ApiHandler.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    
    if (json['results'] != null && json['results'] is List) {
      allProducts = <Product>[];
      json['results'].forEach((v) {
        if (v != null && v is Map<String, dynamic>) {
          allProducts!.add(Product.fromJson(v));
        }
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    data['results'] = allProducts!.map((v) => v.toJson()).toList();
    return data;
  }

  List<Product>? getProducts() {
    return allProducts;
  }
}
