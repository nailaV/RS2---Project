import 'package:eautokuca_desktop/models/narudzba.dart';
import 'package:eautokuca_desktop/providers/base_provider.dart';

class NarudzbaProvider extends BaseProvider<Narudzba> {
  NarudzbaProvider() : super("Narudzbe");

  @override
  Narudzba fromJson(data) {
    // TODO: implement fromJson
    return Narudzba.fromJson(data);
  }
}
