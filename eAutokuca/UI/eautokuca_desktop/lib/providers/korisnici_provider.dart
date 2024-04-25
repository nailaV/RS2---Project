// ignore_for_file: unused_field

import 'dart:convert';

import 'package:eautokuca_desktop/models/korisnici.dart';
import 'package:eautokuca_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class KorisniciProvider extends BaseProvider<Korisnici> {
  KorisniciProvider() : super("Korisnici");

  @override
  Korisnici fromJson(data) {
    // TODO: implement fromJson
    return Korisnici.fromJson(data);
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
}
