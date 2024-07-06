// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:eautokuca_mobile/models/komentari.dart';
import 'package:eautokuca_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class KomentariProvider extends BaseProvider<Komentari> {
  KomentariProvider() : super("Komentari");

  @override
  Komentari fromJson(data) {
    // TODO: implement fromJson
    return Komentari.fromJson(data);
  }

  Future<List<Komentari>> getKomentareZaAuto(int autoId) async {
    var url = "$baseUrl$end/getKomentareZaAuto?autoId=$autoId";
    var uri = Uri.parse(url);
    var headers = createdHeaders();

    var request = await http.get(uri, headers: headers);

    if (isValidResponse(request)) {
      List<Komentari> lista = [];
      var data = jsonDecode(request.body);
      for (var item in data) {
        lista.add(fromJson(item));
      }

      return lista;
    } else {
      throw Exception("Greška...");
    }
  }

  Future<Komentari> dodajKomentar(dynamic request) async {
    var url = "$baseUrl$end/dodajKomentar";
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

  Future<void> sakrijKomentar(int id) async {
    if (id == null) {
      throw Exception("Invalid comment ID");
    }
    var url = "$baseUrl$end/sakrijKomentar/$id";
    var uri = Uri.parse(url);
    var headers = createdHeaders();

    var request = await http.post(uri, headers: headers);

    if (!isValidResponse(request)) {
      throw Exception("Greška...");
    }
  }
}
