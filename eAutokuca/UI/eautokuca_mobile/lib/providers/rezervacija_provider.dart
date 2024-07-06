import 'dart:convert';

import 'package:eautokuca_mobile/models/rezervacija.dart';

import 'package:eautokuca_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class RezervacijaProvider extends BaseProvider<Rezervacija> {
  RezervacijaProvider() : super("Rezervacija");

  @override
  Rezervacija fromJson(data) {
    // TODO: implement fromJson
    return Rezervacija.fromJson(data);
  }

  Future<List<Rezervacija>> getRezervacijeZaUsera(String username) async {
    var url = "$baseUrl$end/$username/getRezervacijeZaUsera";
    var uri = Uri.parse(url);
    var headers = createdHeaders();

    var request = await http.get(uri, headers: headers);

    if (isValidResponse(request)) {
      List<Rezervacija> lista = [];
      var data = jsonDecode(request.body);
      for (var item in data) {
        lista.add(fromJson(item));
      }
      return lista;
    } else {
      throw Exception("Greška...");
    }
  }

  Future<List<String>> getSlobodne(int id, DateTime datum) async {
    var url = "$baseUrl$end/getDostupne?id=$id&datum=$datum";
    var uri = Uri.parse(url);

    var headers = createdHeaders();
    var req = await http.get(uri, headers: headers);

    if (isValidResponse(req)) {
      List<String> lista = [];
      var data = jsonDecode(req.body);
      for (var item in data) {
        lista.add(item);
      }
      return lista;
    } else {
      throw Exception('Greška...');
    }
  }

  Future<Rezervacija> kreirajRezervaciju(dynamic request) async {
    var url = "$baseUrl$end/kreirajRezervaciju";
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

  Future<void> otkazi(int rezervacijaId) async {
    var url = "$baseUrl$end/Otkazi/$rezervacijaId";
    var uri = Uri.parse(url);
    var headers = createdHeaders();
    var request = await http.put(uri, headers: headers);

    if (!isValidResponse(request)) {
      throw Exception("Greška...");
    }
  }
}
