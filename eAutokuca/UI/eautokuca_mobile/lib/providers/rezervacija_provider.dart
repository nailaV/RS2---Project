import 'package:eautokuca_mobile/models/rezervacija.dart';
import 'package:eautokuca_mobile/providers/base_provider.dart';

class RezervacijaProvider extends BaseProvider<Rezervacija> {
  RezervacijaProvider() : super("Rezervacija");

  @override
  Rezervacija fromJson(data) {
    // TODO: implement fromJson
    return Rezervacija.fromJson(data);
  }
}
