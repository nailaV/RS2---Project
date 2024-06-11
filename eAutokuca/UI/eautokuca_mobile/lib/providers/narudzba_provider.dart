// ignore_for_file: unused_import

import 'dart:convert';

import 'package:eautokuca_mobile/models/autodijelovi.dart';
import 'package:eautokuca_mobile/models/narudzba.dart';
import 'package:eautokuca_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class NarudzbaProvider extends BaseProvider<Narudzba> {
  NarudzbaProvider() : super("Narudzbe");

  @override
  Narudzba fromJson(data) {
    // TODO: implement fromJson
    return Narudzba.fromJson(data);
  }

  Future<void> dodajNarudzbu(dynamic object) async {
    var url = "$baseUrl$end/dodajNarudzbu";
    var uri = Uri.parse(url);
    var headers = createdHeaders();
    var obj = jsonEncode(object);
    var req = await http.post(uri, headers: headers, body: obj);
    if (!isValidResponse(req)) {
      throw Exception("Greška.");
    }
  }
}
