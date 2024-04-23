// ignore_for_file: unused_field, unused_local_variable

import 'dart:convert';

import 'package:eautokuca_desktop/models/car.dart';
import 'package:eautokuca_desktop/models/search_result.dart';
import 'package:eautokuca_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class CarProvider extends BaseProvider<Car> {
  CarProvider() : super("Automobil");

  @override
  Car fromJson(data) {
    // TODO: implement fromJson
    return Car.fromJson(data);
  }

  Future<List<String>> getSveMarke() async {
    var url = "$baseUrl$end/GetSveMarke";
    var uri = Uri.parse(url);
    var headers = createdHeaders();
    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      List<String> lista = [];
      var data = jsonDecode(response.body);
      for (var item in data) {
        lista.add(item);
      }

      if (!lista.contains("Sve marke")) {
        lista.insert(0, "Sve marke");
      }
      return lista;
    } else {
      throw Exception("Greška pri učitavanju.");
    }
  }

  Future<List<String>> getSveModele() async {
    var url = "$baseUrl$end/GetSveModele";
    var uri = Uri.parse(url);
    var headers = createdHeaders();
    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      List<String> lista = [];
      var data = jsonDecode(response.body);
      for (var item in data) {
        lista.add(item);
      }

      if (!lista.contains("Svi modeli")) {
        lista.insert(0, "Svi modeli");
      }
      return lista;
    } else {
      throw Exception("Greška pri učitavanju.");
    }
  }

  Future<SearchResult<Car>> Filtriraj(dynamic filters) async {
    var query = getQueryString(filters);

    var url = "$baseUrl$end/Filtriraj?$query";
    var uri = Uri.parse(url);

    var headers = createdHeaders();
    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      SearchResult<Car>? res = SearchResult<Car>();
      var data = jsonDecode(response.body);
      res.hasNext = data['hasNext'];
      res.total = data['totalPages'];
      for (var item in data['result']) {
        res.result.add(fromJson(item));
      }
      return res;
    } else {
      throw Exception("Greška!");
    }
  }
}
