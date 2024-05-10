import 'package:eautokuca_mobile/models/car.dart';
import 'package:eautokuca_mobile/models/korisnici.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rezervacija.g.dart';

@JsonSerializable()
class Rezervacija {
  int? rezervacijaId;
  DateTime? datumVrijemeRezervacije;
  String? status;
  Car? automobil;
  Korisnici? korisnik;

  Rezervacija(this.rezervacijaId, this.datumVrijemeRezervacije, this.status,
      this.automobil, this.korisnik);

  factory Rezervacija.fromJson(Map<String, dynamic> json) =>
      _$RezervacijaFromJson(json);

  Map<String, dynamic> toJson() => _$RezervacijaToJson(this);
}
