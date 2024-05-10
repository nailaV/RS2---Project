// ignore_for_file: unused_import

import 'dart:convert';

import 'package:eautokuca_desktop/models/report.dart';
import 'package:eautokuca_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class ReportProvider extends BaseProvider<Report> {
  ReportProvider() : super("Report");

  @override
  Report fromJson(data) {
    // TODO: implement fromJson
    return Report.fromJson(data);
  }

  Future<List<Report>> getSve({dynamic filter}) async {
    var url = "$baseUrl$end";

    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createdHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      List<Report> result = [];

      for (var item in data) {
        result.add(fromJson(item));
      }

      return result;
    } else {
      throw new Exception("Unknown error.");
    }
  }
}
