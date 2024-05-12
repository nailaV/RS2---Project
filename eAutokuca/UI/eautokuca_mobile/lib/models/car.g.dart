// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Car _$CarFromJson(Map<String, dynamic> json) => Car(
      (json['automobilId'] as num?)?.toInt(),
      json['mjenjac'] as String?,
      json['motor'] as String?,
      json['boja'] as String?,
      json['slike'] as String?,
      (json['cijena'] as num?)?.toDouble(),
      (json['godinaProizvodnje'] as num?)?.toInt(),
      (json['predjeniKilometri'] as num?)?.toDouble(),
      json['brojSasije'] as String?,
      json['snagaMotora'] as String?,
      (json['brojVrata'] as num?)?.toInt(),
      json['model'] as String?,
      json['marka'] as String?,
      json['status'] as String?,
    )..isFavorit = json['isFavorit'] as bool?;

Map<String, dynamic> _$CarToJson(Car instance) => <String, dynamic>{
      'automobilId': instance.automobilId,
      'mjenjac': instance.mjenjac,
      'motor': instance.motor,
      'boja': instance.boja,
      'slike': instance.slike,
      'cijena': instance.cijena,
      'godinaProizvodnje': instance.godinaProizvodnje,
      'predjeniKilometri': instance.predjeniKilometri,
      'brojSasije': instance.brojSasije,
      'snagaMotora': instance.snagaMotora,
      'brojVrata': instance.brojVrata,
      'model': instance.model,
      'marka': instance.marka,
      'status': instance.status,
      'isFavorit': instance.isFavorit,
    };
