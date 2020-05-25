import 'dart:convert';

import 'package:formvalidation/src/shared_preferences/preferencias.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {
  String _firebaseToken = 'AIzaSyDGL7vfMMOuqPWPaKNX8KAqFOva3hy_aFA';
  final _prefs = new PreferenciasUsuario();
 
 
  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
        body: json.encode(authData));

    Map<String, dynamic> decodeResp = json.decode(resp.body);

    print(decodeResp);

    if (decodeResp.containsKey('idToken')) {
    
      _prefs.token = decodeResp['idToken'];
     
      return {'ok': true, 'token': decodeResp['idToken']};
    } else {
      return {'ok': false, 'mensaje': decodeResp['error']['mensaje']};
    }
  }

  Future<Map<String, dynamic>> nuevoUsuario(
      String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
        body: json.encode(authData));

    Map<String, dynamic> decodeResp = json.decode(resp.body);


    if (decodeResp.containsKey('idToken')) {

_prefs.token = decodeResp['idToken'];

      return {'ok': true, 'token': decodeResp['idToken']};
    } else {
      return {'ok': false, 'mensaje': decodeResp['error']['mensaje']};
    }
  }
}
