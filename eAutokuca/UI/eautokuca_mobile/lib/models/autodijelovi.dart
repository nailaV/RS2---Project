import 'package:json_annotation/json_annotation.dart';

part 'autodijelovi.g.dart';

@JsonSerializable()
class Autodijelovi {
  int? autodioId;
  String? naziv;
  double? cijena;
  int? kolicinaNaStanju;
  String? status;
  String? slika;
  String? opis;

  Autodijelovi(this.autodioId, this.naziv, this.cijena, this.kolicinaNaStanju,
      this.status, this.slika, this.opis);

  factory Autodijelovi.fromJson(Map<String, dynamic> json) =>
      _$AutodijeloviFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AutodijeloviToJson(this);
}
