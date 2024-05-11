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
}
