// ignore_for_file: unused_field

import 'package:eautokuca_desktop/models/korisnici.dart';
import 'package:eautokuca_desktop/providers/base_provider.dart';

class KorisniciProvider extends BaseProvider<Korisnici> {
  KorisniciProvider() : super("Korisnici");

  @override
  Korisnici fromJson(data) {
    // TODO: implement fromJson
    return Korisnici.fromJson(data);
  }
}
