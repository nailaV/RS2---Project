// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'autodijelovi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Autodijelovi _$AutodijeloviFromJson(Map<String, dynamic> json) => Autodijelovi(
      json['autodioId'] as int?,
      json['naziv'] as String?,
      (json['cijena'] as num?)?.toDouble(),
      json['kolicinaNaStanju'] as int?,
      json['status'] as String?,
    );

Map<String, dynamic> _$AutodijeloviToJson(Autodijelovi instance) =>
    <String, dynamic>{
      'autodioId': instance.autodioId,
      'naziv': instance.naziv,
      'cijena': instance.cijena,
      'kolicinaNaStanju': instance.kolicinaNaStanju,
      'status': instance.status,
    };
