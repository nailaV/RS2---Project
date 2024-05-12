import 'package:eautokuca_desktop/models/car.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report.g.dart';

@JsonSerializable()
class Report {
  int? reportId;
  int? automobilId;
  DateTime? datumProdaje;
  double? prihodi;
  Car? automobil;

  Report(
    this.automobil,
    this.reportId,
    this.automobilId,
    this.datumProdaje,
    this.prihodi,
  );

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
