import 'package:eautokuca_mobile/models/autodijelovi.dart';
import 'package:eautokuca_mobile/providers/base_provider.dart';
//import 'package:http/http.dart' as http;

class AutodijeloviProvider extends BaseProvider<Autodijelovi> {
  AutodijeloviProvider() : super("Autodio");

  @override
  Autodijelovi fromJson(data) {
    // TODO: implement fromJson
    return Autodijelovi.fromJson(data);
  }
}
