import 'package:json_annotation/json_annotation.dart';

part 'oprema.g.dart';

@JsonSerializable()
class Oprema {
  int? opremaId;
  bool? zracniJastuci;
  bool? bluetooth;
  bool? xenon;
  bool? alarm;
  bool? daljinskoKljucanje;
  bool? navigacija;
  bool? servoVolan;
  bool? autoPilot;
  bool? tempomat;
  bool? parkingSenzori;
  bool? grijanjeSjedista;
  bool? grijanjeVolana;

  Oprema(
      this.opremaId,
      this.zracniJastuci,
      this.bluetooth,
      this.xenon,
      this.alarm,
      this.daljinskoKljucanje,
      this.navigacija,
      this.servoVolan,
      this.autoPilot,
      this.tempomat,
      this.parkingSenzori,
      this.grijanjeSjedista,
      this.grijanjeVolana);

  factory Oprema.fromJson(Map<String, dynamic> json) => _$OpremaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$OpremaToJson(this);
}
