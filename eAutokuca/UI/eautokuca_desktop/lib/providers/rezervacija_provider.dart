// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:eautokuca_desktop/models/rezervacija.dart';
import 'package:eautokuca_desktop/models/search_result.dart';
import 'package:eautokuca_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class RezervacijaProvider extends BaseProvider<Rezervacija> {
  RezervacijaProvider() : super("Rezervacija");

  @override
  Rezervacija fromJson(data) {
    // TODO: implement fromJson
    return Rezervacija.fromJson(data);
  }

  Future<void> zavrsi(int rezervacijaId) async {
    var url = "$baseUrl$end/Zavrsi/$rezervacijaId";
    var uri = Uri.parse(url);
    var headers = createdHeaders();
    var request = await http.put(uri, headers: headers);

    if (!isValidResponse(request)) {
      throw Exception("Greška...");
    }
  }

  Future<void> otkazi(int rezervacijaId) async {
    var url = "$baseUrl$end/Otkazi/$rezervacijaId";
    var uri = Uri.parse(url);
    var headers = createdHeaders();
    var request = await http.put(uri, headers: headers);

    if (!isValidResponse(request)) {
      throw Exception("Greška...");
    }
  }

  Future<SearchResult<Rezervacija>> getZavrsene() async {
    var url = "$baseUrl$end/GetZavrsene";
    var uri = Uri.parse(url);
    var headers = createdHeaders();
    var request = await http.get(uri, headers: headers);

    if (isValidResponse(request)) {
      var result = SearchResult<Rezervacija>();
      var data = jsonDecode(request.body);
      result.total = data['totalPages'];
      result.hasNext = data['hasNext'];
      {}
      var list = data['list'];
      if (list != null && list is Iterable) {
        for (var item in list) {
          result.result.add(Rezervacija.fromJson(item));
        }
      }
      //print("body: ${request.body}");
      print("status code: ${request.statusCode}");
      print("result: ${result}");
      print("result inst: ${result.result}");

      return result;
    } else {
      throw Exception("Greška...");
    }
  }

  Future<SearchResult<Rezervacija>> getAktivne(dynamic filter) async {
    var url = "$baseUrl$end/GetAktivne?";
    var uri = Uri.parse(url);
    var headers = createdHeaders();
    var request = await http.get(uri, headers: headers);

    if (isValidResponse(request)) {
      var result = SearchResult<Rezervacija>();
      var data = jsonDecode(request.body);
      result.total = data['totalPages'];
      result.hasNext = data['hasNext'];
      for (var item in data['list']) {
        result.result.add(fromJson(item));
      }
      return result;
    } else {
      throw Exception("Greška...");
    }
  }
}
