import 'package:eautokuca_mobile/models/car.dart';
import 'package:eautokuca_mobile/models/korisnici.dart';
import 'package:intl/intl.dart';
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

  String get datum {
    return DateFormat('dd-MM-yyyy').format(datumVrijemeRezervacije!);
  }

  String get vrijeme {
    return DateFormat('HH:mm').format(datumVrijemeRezervacije!);
  }

  String get auto {
    return "${automobil?.marka} ${automobil?.model}";
  }

  factory Rezervacija.fromJson(Map<String, dynamic> json) =>
      _$RezervacijaFromJson(json);

  Map<String, dynamic> toJson() => _$RezervacijaToJson(this);
}
