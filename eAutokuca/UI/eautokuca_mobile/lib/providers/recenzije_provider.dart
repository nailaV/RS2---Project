import 'dart:convert';

import 'package:eautokuca_mobile/models/recenzije.dart';
import 'package:eautokuca_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class RecenzijeProvider extends BaseProvider<Recenzije> {
  RecenzijeProvider() : super("Recenzije");

  @override
  Recenzije fromJson(data) {
    // TODO: implement fromJson
    return Recenzije.fromJson(data);
  }

  Future<List<Recenzije>> getRecenzijeZaUsera(String username) async {
    var url = "$baseUrl$end/getRecenzijeZaUsera?username=$username";
    var uri = Uri.parse(url);
    var headers = createdHeaders();

    var request = await http.get(uri, headers: headers);

    if (isValidResponse(request)) {
      List<Recenzije> lista = [];
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
