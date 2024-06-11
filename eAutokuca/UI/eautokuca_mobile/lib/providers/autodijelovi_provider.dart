import 'dart:convert';

import 'package:eautokuca_mobile/models/autodijelovi.dart';
import 'package:eautokuca_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class AutodijeloviProvider extends BaseProvider<Autodijelovi> {
  AutodijeloviProvider() : super("Autodio");

  @override
  Autodijelovi fromJson(data) {
    // TODO: implement fromJson
    return Autodijelovi.fromJson(data);
  }

  Future<List<Autodijelovi>> recommend(int autodioId) async {
    var url = "$baseUrl$end/recommend/$autodioId";
    var uri = Uri.parse(url);
    var headers = createdHeaders();
    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      List<Autodijelovi> lista = [];
      var data = jsonDecode(response.body);
      for (var item in data) {
        lista.add(item);
      }

      return lista;
    } else {
      throw Exception("Greška pri učitavanju.");
    }
  }
}
