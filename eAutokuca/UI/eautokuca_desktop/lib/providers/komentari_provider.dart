import 'package:eautokuca_desktop/models/komentari.dart';
import 'package:eautokuca_desktop/providers/base_provider.dart';
//import 'package:http/http.dart' as http;

class KomentariProvider extends BaseProvider<Komentari> {
  KomentariProvider() : super("Komentari");

  @override
  Komentari fromJson(data) {
    // TODO: implement fromJson
    return Komentari.fromJson(data);
  }
}
