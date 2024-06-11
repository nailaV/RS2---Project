import 'package:eautokuca_desktop/models/korisnici.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'narudzba.g.dart';

@JsonSerializable()
class Narudzba {
  int? narudzbaId;
  double? ukupniIznos;
  Korisnici? korisnik;
  DateTime? datumNarudzbe;
  String? status;

  Narudzba(this.narudzbaId, this.ukupniIznos, this.korisnik, this.datumNarudzbe,
      this.status);

  String get datum {
    return DateFormat('dd.MM.yyyy').format(datumNarudzbe!);
  }

  String get user {
    return "${korisnik?.ime} ${korisnik?.prezime}";
  }

  factory Narudzba.fromJson(Map<String, dynamic> json) =>
      _$NarudzbaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$NarudzbaToJson(this);
}
