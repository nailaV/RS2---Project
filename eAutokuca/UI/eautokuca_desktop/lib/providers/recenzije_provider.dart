// ignore_for_file: unused_import

import 'dart:convert';

import 'package:eautokuca_desktop/models/recenzije.dart';
import 'package:eautokuca_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class RecenzijeProvider extends BaseProvider<Recenzije> {
  RecenzijeProvider() : super("Recenzije");

  @override
  Recenzije fromJson(data) {
    // TODO: implement fromJson
    return Recenzije.fromJson(data);
  }

  Future<double> getAverage() async {
    var url = "$baseUrl$end/getAverage";
    var uri = Uri.parse(url);
    var headers = createdHeaders();

    var request = await http.get(uri, headers: headers);

    if (isValidResponse(request)) {
      var data = jsonDecode(request.body);
      return data;
    } else {
      throw Exception("Greška...");
    }
  }
}
