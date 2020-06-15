import 'dart:convert';
import 'dart:io';

import 'package:client_bos_final/common/ENDPOINT.dart';
import 'package:client_bos_final/model/discounts.dart';
import 'package:http/http.dart' as http;
import 'package:client_bos_final/common/globals.dart';

Future<int> fetchDiscountAmount(String code) async {
  try {
    String token = await getUserToken();
    final response = await http.get('$endPoint/clients/$code/amountDiscount',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      return res['data'];
    }
    print(code);
    throw Exception(
        'Impossible de recuperer le montant des bons de reduction ${response.body}');
  } catch (e) {
    throw Exception(
        'Impossible de recuperer le montant des bons de reduction $e');
  }
}

Future<List<Discount>> fetchClientDiscounts(String code) async {
  try {
    String token = await getUserToken();
    final response = await http.get('$endPoint/clients/$code/discounts',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      Iterable data = res['data'];
      return data.map((model) => Discount.fromJson(model)).toList();
    }
    print(response.statusCode);
    throw Exception('Impossible de recuperer les remises du client $code');
  } catch (e) {
    throw Exception('Impossible de recuperer les remises du client $code');
  }
}
