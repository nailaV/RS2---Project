import 'package:eautokuca_mobile/models/korisnici.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recenzije.g.dart';

@JsonSerializable()
class Recenzije {
  int? recenzijeId;
  String? sadrzaj;
  int? ocjena;
  Korisnici? korisnik;

  Recenzije(
    this.recenzijeId,
    this.sadrzaj,
    this.ocjena,
    this.korisnik,
  );

  factory Recenzije.fromJson(Map<String, dynamic> json) =>
      _$RecenzijeFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$RecenzijeToJson(this);
}
