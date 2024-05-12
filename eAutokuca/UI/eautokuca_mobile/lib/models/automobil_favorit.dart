import 'package:eautokuca_mobile/models/car.dart';
import 'package:json_annotation/json_annotation.dart';

part 'automobil_favorit.g.dart';

@JsonSerializable()
class AutomobilFavorit {
  int? automobilId;
  int? korisnikId;
  Car? automobil;

  AutomobilFavorit(
    this.automobilId,
    this.korisnikId,
    this.automobil,
  );

  factory AutomobilFavorit.fromJson(Map<String, dynamic> json) =>
      _$AutomobilFavoritFromJson(json);

  String get imeAuta {
    return "${automobil?.marka} ${automobil?.model}";
  }

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AutomobilFavoritToJson(this);
}
