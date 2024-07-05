import 'dart:convert';

import 'package:eautokuca_desktop/models/komentari.dart';
import 'package:eautokuca_desktop/providers/base_provider.dart';
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
}
