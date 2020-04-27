import 'dart:io';

import 'package:client_bos_final/common/ENDPOINT.dart';
import 'package:client_bos_final/common/globals.dart';
import 'package:client_bos_final/model/products.dart';
import 'package:client_bos_final/model/shops.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Product>> fetchShopProducts(String code) async {
  try {
    final response = await http.get('$endPoint/shop/$code/allProducts');
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      Iterable items = res['data'];
      return items.map((item) => new Product.fromJson(item)).toList();
    }
    throw Exception(
        'Erreur de recuperation des produits de la boutique specifiee');
  } catch (e) {
    throw Exception(
        'Erreur de recuperation des produits de la boutique specifiee');
  }
}

Future fetchProductsByShopId(int id) async {
  try {
    final response = await http.get('$endPoint/shop/$id/products');
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      /* 
      Iterable items = res['data'];
      return items.map((item) => new Product.fromJson(item)).toList(); */
      return res['data'];
    }
    throw Exception(
        'Erreur de recuperation des produits de la boutique specifiee');
  } catch (e) {
    throw Exception(
        'Erreur de recuperation des produits de la boutique specifiee');
  }
}

Future<List<Shop>> fetchFollowShops() async {
  try {
    final response = await http.get('$endPoint/clients/$userCode/followShops',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      Iterable data = res['data'];
      return data.map((model) => Shop.fromJson(model)).toList();
    }
    throw Exception(
        'Impossible de recuperer les boutiques ${response.statusCode}');
  } catch (e) {
    throw Exception('Impossible de recuperer les boutiques $e');
  }
}
