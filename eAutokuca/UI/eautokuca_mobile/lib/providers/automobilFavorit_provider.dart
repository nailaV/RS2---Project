import 'dart:convert';

import 'package:eautokuca_mobile/models/automobil_favorit.dart';
import 'package:eautokuca_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class AutomobilFavoritProvider extends BaseProvider<AutomobilFavorit> {
  AutomobilFavoritProvider() : super("AutomobilFavorit");

  @override
  AutomobilFavorit fromJson(data) {
    // TODO: implement fromJson
    return AutomobilFavorit.fromJson(data);
  }

  Future<List<AutomobilFavorit>> getFavoriteZaUsera(String username) async {
    var url = "$baseUrl$end/$username/getFavoriteZaUsera";
    var uri = Uri.parse(url);
    var headers = createdHeaders();

    var request = await http.get(uri, headers: headers);

    if (isValidResponse(request)) {
      List<AutomobilFavorit> lista = [];
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
