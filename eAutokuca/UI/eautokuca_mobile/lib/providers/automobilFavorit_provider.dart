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

  Future<bool> isFavorit(int automobilId, int korisnikId) async {
    var url =
        "$baseUrl$end/isFavorit?automobilId=$automobilId&korisnikId=$korisnikId";

    var uri = Uri.parse(url);
    var headers = createdHeaders();

    var request = await http.get(uri, headers: headers);
    print("Jel favorit: ${request.body}");

    if (isValidResponse(request)) {
      if (request.body.toLowerCase() == 'true') {
        return true;
      } else if (request.body.toLowerCase() == 'false') {
        return false;
      } else {
        throw Exception("Invalid response from server.");
      }
    } else {
      throw Exception("Greška...");
    }
  }

  Future<void> ukloniFavorita(int automobilId, int korisnikId) async {
    var url =
        "$baseUrl$end/izbrisiFavorita?automobilId=$automobilId&korisnikId=$korisnikId";
    print(url);
    var uri = Uri.parse(url);
    var headers = createdHeaders();

    var request = await http.post(uri, headers: headers);
    print(request.body);
    if (!isValidResponse(request)) {
      throw Exception("Greska");
    }
  }
}
