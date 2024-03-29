import 'package:json_annotation/json_annotation.dart';

part 'car.g.dart';

@JsonSerializable()
class Car {
  int? automobilId;
  String? mjenjac;
  String? motor;
  String? boja;
  String? slika;
  double? cijena;

  Car(this.automobilId, this.mjenjac, this.motor, this.boja, this.slika,
      this.cijena);

  factory Car.fromJson(Map<String, dynamic> json) => _$CarFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$CarToJson(this);
}

/* "automobilId": 6,
      "cijena": 3890,
      "godinaProizvodnje": 2009,
      "predjeniKilometri": 309879,
      "brojSasije": "hhjuk8897",
      "motor": "Dizel",
      "snagaMotora": "78kW",
      "mjenjac": "Manuelni",
      "boja": "Crna",
      "brojVrata": 5,
      "model": "5",
      "marka": "Golf",
      "status": "Active" */