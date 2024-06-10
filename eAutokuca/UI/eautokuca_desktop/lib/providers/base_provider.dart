// ignore_for_file: unused_field

import 'dart:convert';

import 'package:eautokuca_desktop/models/search_result.dart';
import 'package:eautokuca_desktop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  late String _baseUrl;
  late String _endpoint;
  String get baseUrl => _baseUrl;
  String get end => _endpoint;

  BaseProvider(String endpoint) {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:5146/");
    _endpoint = endpoint;
  }

  Future<SearchResult<T>> getAll({dynamic filter}) async {
    var url = "$_baseUrl$_endpoint/getAll";

    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createdHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<T>();

      result.count = data['count'];
      result.total = data['totalPages'];

      for (var item in data['result']) {
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw new Exception("Unknown error.");
    }
  }

  Future<bool> delete(int id) async {
    var url = "$_baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createdHeaders();

    var response = await http.delete(uri, headers: headers);
    if (!isValidResponse(response)) {
      throw Exception("Error...");
    }
    return true;
  }

  Future<T> insert(dynamic request) async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = createdHeaders();
    var jsonRequest = jsonEncode(request);

    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw new Exception("Unknown error.");
    }
  }

  Future<T> getById(int id) async {
    var url = "$_baseUrl$_endpoint/$id/getByID";
    var uri = Uri.parse(url);
    var headers = createdHeaders();

    var request = await http.get(uri, headers: headers);

    if (isValidResponse(request)) {
      var data = jsonDecode(request.body);
      return fromJson(data);
    } else {
      throw Exception("Greška...");
    }
  }

  Future<T> update(int ID, [dynamic request]) async {
    var url = "$_baseUrl$_endpoint/$ID/update";
    var uri = Uri.parse(url);
    var headers = createdHeaders();
    var jsonRequest = jsonEncode(request);

    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unknown error.");
    }
  }

  T fromJson(data) {
    throw Exception("Method not implemented.");
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

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };
    return headers;
  }

  String getQueryString(Map params,
      {String prefix = '&', bool inRecursion = false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${(value as DateTime).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  }
}
