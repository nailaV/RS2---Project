import 'package:eautokuca_desktop/models/narudzba.dart';
import 'package:eautokuca_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class NarudzbaProvider extends BaseProvider<Narudzba> {
  NarudzbaProvider() : super("Narudzbe");

  @override
  Narudzba fromJson(data) {
    // TODO: implement fromJson
    return Narudzba.fromJson(data);
  }

  Future<void> posaljiNarudzbu(int id) async {
    var url = "$baseUrl$end/posaljiNarudzbu/$id";
    var uri = Uri.parse(url);
    var headers = createdHeaders();

    var request = await http.post(uri, headers: headers);

    if (!isValidResponse(request)) {
      throw Exception("Greška...");
    }
  }

  Future<void> otkaziNarudzbu(int id) async {
    var url = "$baseUrl$end/otkaziNarudzbu/$id";
    var uri = Uri.parse(url);
    var headers = createdHeaders();

    var request = await http.post(uri, headers: headers);

    if (!isValidResponse(request)) {
      throw Exception("Greška...");
    }
  }
}
