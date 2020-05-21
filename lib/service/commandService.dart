import 'dart:convert';
import 'dart:io';
import 'package:client_bos_final/model/carts.dart';
import 'package:client_bos_final/model/commands.dart';
import 'package:http/http.dart' as http;

import 'package:client_bos_final/common/ENDPOINT.dart';
import 'package:client_bos_final/common/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Cart> storeCart(Map<String, dynamic> params) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    final response = await http.post('$endPoint/carts',
        body: params,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return Cart.fromJson(data['data']);
    }
    print(response.statusCode.toString());
    throw Exception('Impossible de stocker le panier');
  } catch (e) {
    throw Exception('Impossible de stocker le panier');
  }
}

Future<Command> storeCommand(Map<String, dynamic> params) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    final response = await http.post('$endPoint/commands',
        body: params,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return Command.fromJson(data['data']);
    }

    throw Exception(
        'Impossible de stocker la commande ${response.statusCode} - ${response.body.toString()}');
  } catch (e) {
    throw Exception('Impossible de stocker la commande $e');
  }
}

Future fetchWaitingCommands(String code) async {
  try {
    String token = await getUserToken();
    final response = await http.get('$endPoint/clients/$code/waitingCommands',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success']) {
        return data['data'];
      }
    }
    throw Exception('Impossible de recuperer les commandes en attente');
  } catch (e) {
    throw Exception('Impossible de recuperer les commandes en attente');
  }
}

Future fetchOnRoadCommands(String code) async {
  try {
    String token = await getUserToken();
    final response = await http.get('$endPoint/clients/$code/closeCommands',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success']) {
        print('success');
        return data['data'];
      }
    }
    throw Exception('Impossible de recuperer les commandes en route');
  } catch (e) {
    throw Exception('Impossible de recuperer les commandes en route');
  }
}

Future fetchAllCommands(String code) async {
  try {
    String token = await getUserToken();
    final response = await http.get('$endPoint/clients/$code/allCommands',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success']) {
        return data['data'];
      }
    }
    throw Exception('Impossible de recuperer les commandes');
  } catch (e) {
    throw Exception('Impossible de recuperer les commandes');
  }
}

Future<bool> sendRecapMail(String code) async {
  try {
    String token = await getUserToken();
    final response = await http.get('$endPoint/commands/$code/mailRecap',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['success'];
    }
    throw Exception(
        'Impossible d\'envoyer le mail recapitulatif ${response.body}');
  } catch (e) {
    throw Exception('Exception $e');
  }
}
