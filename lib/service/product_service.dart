import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get_connect/connect.dart' hide Response;
import 'package:migo/models/cache.dart';
import 'package:migo/models/product/api.dart';
import 'package:migo/models/product/product.dart';

class ProductServices extends GetConnect with CacheManager {
  // final String searchUrl =
  //     'https://backpos.herokuapp.com/api/v1/product/search/';
  final String allProduct = 'http://192.168.0.104:8080/api/service';

  // Future<List<Product>?> fetchProducts(Keyword model) async {
  //   var dio = Dio();
  //   final token = getToken();
  //   dio.options.headers["authorization"] = "Bearer $token";
  //   Response response =
  //       await dio.post(searchUrl, data: json.encode(model.toJson()));
  //   print("RESPONSE 1: $response");
  //   if (response.statusCode == 200) {
  //     print("ALLPRODUCTS 1: $allProduct");
  //     return ApiHandler.fromJson(response.data).allProducts;
  //   } else {
  //     //show error message
  //     print("ALLPRODUCTS 2: $allProduct");
  //     return null;
  //   }
  // }

  Future<List<Product>?> fetchAllProducts() async {
    var dio = Dio();
    final token = getToken();
    dio.options.headers["authorization"] = "Bearer $token";
      print("RESPONSE 11: ");
    Response response = await dio.get(allProduct);
      print("RESPONSE 22: $response");
    if (response.statusCode == 200) {
      ApiHandler handler = ApiHandler.fromJson(response.data); //
      List<Product>? product = handler.getProducts();
      // List<Product>? product = response.data;
      print("RESPONSE 33: $product");
      return product;
    } else {
      //show error message
      return null;
    }
  }
}
