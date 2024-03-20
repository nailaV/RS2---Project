// ignore_for_file: unused_field

import 'dart:convert';

import 'package:eautokuca_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class CarProvider with ChangeNotifier {
  static String? _baseUrl;
  String _endpoint = "Automobil/getAll";

  CarProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:5146/");
  }

  Future<dynamic> get() async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = createdHeaders();

    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw new Exception("Unknown error.");
    }

    //OVO SAM KUCALA DA BI U TERMINALU VIDJELA STATUS KOD I ERROR!
    //print("response: ${response.request} code: ${response.statusCode} body: ${response.body}");
  }

  bool isValidResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw new Exception("Unauthorized.");
    } else {
      throw new Exception("Something happened.");
    }
  }

  Map<String, String> createdHeaders() {
    String username = Authorization.username ?? "";
    String password = Authorization.password ?? "";
    print("credentials passed: $username, $password");

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };
    return headers;
  }
}
