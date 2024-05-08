import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'korisnici.g.dart';

@JsonSerializable()
class Korisnici {
  int? korisnikId;
  String? ime;
  String? prezime;
  String? email;
  String? telefon;
  String? username;
  DateTime? datumRegistracije;
  bool? stanje;
  String? slika;

  Korisnici(this.korisnikId, this.ime, this.prezime, this.email, this.telefon,
      this.username, this.datumRegistracije, this.stanje, this.slika);

  String? get registrationDate {
    return datumRegistracije != null
        ? DateFormat.yMMMd().format(datumRegistracije!)
        : "date null";
  }

  factory Korisnici.fromJson(Map<String, dynamic> json) =>
      _$KorisniciFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$KorisniciToJson(this);
}
