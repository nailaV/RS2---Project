import 'dart:convert';

import 'package:eautokuca_desktop/models/oprema.dart';
import 'package:eautokuca_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class OpremaProvider extends BaseProvider<Oprema> {
  OpremaProvider() : super("Oprema");

  @override
  Oprema fromJson(data) {
    // TODO: implement fromJson
    return Oprema.fromJson(data);
  }

  Future<Oprema> getOpremuZaAutomobil(int id) async {
    var url = "$baseUrl$end/getOpremuZaAutomobil/$id";
    var uri = Uri.parse(url);
    var headers = createdHeaders();

    var request = await http.get(uri, headers: headers);
    print("response ${request.body} ${request.statusCode}");

    if (isValidResponse(request)) {
      var data = jsonDecode(request.body);
      return fromJson(data);
    } else {
      throw Exception("Greška...");
    }
  }
}
