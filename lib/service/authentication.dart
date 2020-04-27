import 'dart:io';
import 'package:client_bos_final/common/ENDPOINT.dart';
import 'package:client_bos_final/common/globals.dart' as globals;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> login(Map<String, dynamic> params) async {
  bool result = false;
  try {
    final response = await http.post('$endPoint/logClient', body: params);

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      if (data['success'] == true) {
        await globals.logIn(data['user'], data['token']);
        globals.userCode = data['user']['code'];
        globals.userId = data['user']['id'];
        globals.token = data['token'];
        result = true;
      }
      globals.errorMessageText = data['message'];
    } else {
      print(response.statusCode);
      globals.errorMessageText = data['message'];
    }
  } catch (e) {
    print('Exception: $e');
    globals.errorMessageText = 'Verifier votre connexion internet';
  }
  return result;
}

Future<bool> register(Map<String, dynamic> params) async {
  bool result = false;
  try {
    final response = await http.post('$endPoint/regClient', body: params);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      if (data['success'] == true) {
        await globals.logIn(data['user'], data['token']);
        globals.userCode = data['user']['code'];
        globals.userId = data['user']['id'];
        globals.token = data['token'];
        result = true;
      }
      globals.errorMessageText = data['message'];
    } else {
      print(response.body);
      globals.errorMessageText = data['message'];
    }
  } catch (e) {
    print('Exception: $e');
    globals.errorMessageText = 'Verifier votre connexion internet';
  }

  return result;
}

Future<bool> recoverPassword(Map<String, dynamic> params) async {
  try {
    print('Tentative recuperation mdp');
    final response = await http.post('$endPoint/forgot', body: params);
    if (response.statusCode == 200) {
      print('Tentative de recuperation du mdp terminee avec succes');
      return true;
    } else {
      print(
          '\n\n\n\n\n\nCode de reponse: ${response.statusCode}\n\n\n\n\n\n\n');
      return false;
    }
  } catch (e) {
    print('\n\n\n\n\n\nException: $e\n\n\n\n\n\n\n');
    return false;
  }
}

Future<bool> checkCode(Map<String, dynamic> params) async {
  try {
    print('Tentative de verification du mot de passe');
    final response = await http.post('$endPoint/check', body: params);
    if (response.statusCode == 200) {
      print('Tentative de verification du mot de passe terminee avec succes');
      return true;
    } else {
      print(
          '\n\n\n\n\n\nCode de reponse: ${response.statusCode}\n\n\n\n\n\n\n');
      return false;
    }
  } catch (e) {
    print('\n\n\n\n\n\nException: $e\n\n\n\n\n\n\n');
    return false;
  }
}

Future<bool> logout() async {
  bool result = false;
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    final response = await http.post('$endPoint/logout',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});
    if (response.statusCode == 200) {
      result = true;
      globals.token = '';
    } else {
      print(response.statusCode);
    }
  } catch (e) {
    print('Exception: $e');
  }

  return result;
}

Future<bool> update(Map<String, dynamic> params) async {
  bool result = false;
  try {
    globals.token = await globals.getUserToken();
    final response = await http.post('$endPoint/updateClient',
        body: params,
        headers: {HttpHeaders.authorizationHeader: 'Bearer ${globals.token}'});
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      if (data['success'] == true) {
        result = true;
      }
      globals.errorMessageText = data['message'];
    } else {
      print(response.statusCode);
      globals.errorMessageText = data['message'];
    }
  } catch (e) {
    print('Exception: $e');
    globals.errorMessageText = 'Verifier votre connexion internet';
  }

  return result;
}
