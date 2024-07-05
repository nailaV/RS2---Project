import 'package:eautokuca_desktop/models/car.dart';
import 'package:eautokuca_desktop/models/korisnici.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'komentari.g.dart';

@JsonSerializable()
class Komentari {
  int? komnetarId;
  String? sadrzaj;
  DateTime? datumDodavanja;
  Korisnici? korisnik;
  Car? automobil;

  Komentari(this.komnetarId, this.sadrzaj, this.datumDodavanja, this.korisnik,
      this.automobil);

  String get datum {
    return DateFormat('dd.MM.yyyy').format(datumDodavanja!);
  }

  String get vrijeme {
    return DateFormat.Hm().format(datumDodavanja!);
  }

  String get auto {
    return "${automobil?.marka} ${automobil?.model} ${automobil?.godinaProizvodnje}";
  }

  String get user {
    return "${korisnik?.ime} ${korisnik?.prezime}";
  }

  factory Komentari.fromJson(Map<String, dynamic> json) =>
      _$KomentariFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$KomentariToJson(this);
}
