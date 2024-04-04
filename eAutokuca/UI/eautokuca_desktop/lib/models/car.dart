import 'package:json_annotation/json_annotation.dart';

part 'car.g.dart';

@JsonSerializable()
class Car {
  int? automobilId;
  String? mjenjac;
  String? motor;
  String? boja;
  String? slike;
  double? cijena;
  int? godinaProizvodnje;
  double? predjeniKilometri;
  String? brojSasije;
  String? snagaMotora;
  int? brojVrata;
  String? model;
  String? marka;
  String? status;

  Car(
      this.automobilId,
      this.mjenjac,
      this.motor,
      this.boja,
      this.slike,
      this.cijena,
      this.godinaProizvodnje,
      this.predjeniKilometri,
      this.brojSasije,
      this.snagaMotora,
      this.brojVrata,
      this.model,
      this.marka,
      this.status);

  factory Car.fromJson(Map<String, dynamic> json) => _$CarFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$CarToJson(this);
}
