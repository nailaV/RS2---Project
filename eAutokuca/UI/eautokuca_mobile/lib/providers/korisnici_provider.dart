// ignore_for_file: unused_field

import 'dart:convert';

import 'package:eautokuca_mobile/models/korisnici.dart';
import 'package:eautokuca_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class KorisniciProvider extends BaseProvider<Korisnici> {
  KorisniciProvider() : super("Korisnici");

  @override
  Korisnici fromJson(data) {
    // TODO: implement fromJson
    return Korisnici.fromJson(data);
  }

  Future<void> promjenaPassworda(int id, dynamic object) async {
    var url = "$baseUrl$end/PromjenaPassworda/$id";
    var uri = Uri.parse(url);
    var headers = createdHeaders();
    var obj = jsonEncode(object);
    var req = await http.post(uri, headers: headers, body: obj);
    if (!isValidResponse(req)) {
      throw Exception("Greška.");
    }
  }

  Future<void> promjenaSlike(int id, dynamic object) async {
    var url = "$baseUrl$end/PromjenaSlike/$id";
    var uri = Uri.parse(url);
    var headers = createdHeaders();
    var obj = jsonEncode(object);
    var req = await http.post(uri, headers: headers, body: obj);
    if (!isValidResponse(req)) {
      throw Exception("Greška.");
    }
  }

  Future<Korisnici> getByUseranme(String username) async {
    var url = "$baseUrl$end/$username/getByUsername";
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

  Future<void> promijeniStanje(int id) async {
    var url = "$baseUrl$end/promijeniStanje/$id";
    var uri = Uri.parse(url);
    var headers = createdHeaders();

    var request = await http.post(uri, headers: headers);

    if (!isValidResponse(request)) {
      throw Exception("Greška...");
    }
  }
}
