import 'dart:convert';
import 'package:client_bos_final/model/categories.dart';
import 'package:client_bos_final/model/products.dart';
import 'package:http/http.dart' as http;
import 'package:client_bos_final/common/ENDPOINT.dart';

Future<List<Product>> fetchCategoryProduct(String code) async {
  try {
    final response = await http.get('$endPoint/categories/$code/allProducts');
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      Iterable items = res['data'];
      return items.map((item) => new Product.fromJson(item)).toList();
    }
    throw Exception(
        'Erreur de recuperation des produits de la categorie specifiee');
  } catch (e) {
    throw Exception(
        'Erreur de recuperation des produits de la categorie specifiee');
  }
}

Future<List<Category>> fetchParentCategories() async {
  try {
    final response = await http.get('$endPoint/parentCategory');
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      Iterable items = res['data'];
      return items.map((item) => new Category.fromJson(item)).toList();
    }
    return null;
  } catch (e) {
    throw Exception('Erreur de recuperation des categories $e');
  }
}

Future<List<Category>> fetchAllCategories() async {
  try {
    final response = await http.get('$endPoint/allCategories');
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      Iterable items = res['data'];
      return items.map((item) => new Category.fromJson(item)).toList();
    }
    return null;
  } catch (e) {
    throw Exception('Erreur de recuperation des categories $e');
  }
}
