import 'package:eautokuca_desktop/models/autodijelovi.dart';
import 'package:eautokuca_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class AutodijeloviProvider extends BaseProvider<Autodijelovi> {
  AutodijeloviProvider() : super("Autodio");

  @override
  Autodijelovi fromJson(data) {
    // TODO: implement fromJson
    return Autodijelovi.fromJson(data);
  }

  Future<void> deaktiviraj(int id) async {
    var url = "$baseUrl$end/deaktiviraj/$id";
    var uri = Uri.parse(url);
    var headers = createdHeaders();

    var request = await http.post(uri, headers: headers);

    if (!isValidResponse(request)) {
      throw Exception("Greška...");
    }
  }

  Future<void> aktiviraj(int id) async {
    var url = "$baseUrl$end/aktiviraj/$id";
    var uri = Uri.parse(url);
    var headers = createdHeaders();

    var request = await http.post(uri, headers: headers);

    if (!isValidResponse(request)) {
      throw Exception("Greška...");
    }
  }
}
