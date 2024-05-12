// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      json['automobil'] == null
          ? null
          : Car.fromJson(json['automobil'] as Map<String, dynamic>),
      json['reportId'] as int?,
      json['automobilId'] as int?,
      json['datumProdaje'] == null
          ? null
          : DateTime.parse(json['datumProdaje'] as String),
      (json['prihodi'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'reportId': instance.reportId,
      'automobilId': instance.automobilId,
      'datumProdaje': instance.datumProdaje?.toIso8601String(),
      'prihodi': instance.prihodi,
      'automobil': instance.automobil,
    };
