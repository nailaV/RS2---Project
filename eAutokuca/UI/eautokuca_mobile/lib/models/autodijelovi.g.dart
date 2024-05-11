// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'autodijelovi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Autodijelovi _$AutodijeloviFromJson(Map<String, dynamic> json) => Autodijelovi(
      (json['autodioId'] as num?)?.toInt(),
      json['naziv'] as String?,
      (json['cijena'] as num?)?.toDouble(),
      (json['kolicinaNaStanju'] as num?)?.toInt(),
      json['status'] as String?,
      json['slika'] as String?,
      json['opis'] as String?,
    );

Map<String, dynamic> _$AutodijeloviToJson(Autodijelovi instance) =>
    <String, dynamic>{
      'autodioId': instance.autodioId,
      'naziv': instance.naziv,
      'cijena': instance.cijena,
      'kolicinaNaStanju': instance.kolicinaNaStanju,
      'status': instance.status,
      'slika': instance.slika,
      'opis': instance.opis,
    };
