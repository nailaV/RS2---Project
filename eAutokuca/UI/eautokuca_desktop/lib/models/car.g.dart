// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Car _$CarFromJson(Map<String, dynamic> json) => Car(
      json['automobilId'] as int?,
      json['mjenjac'] as String?,
      json['motor'] as String?,
      json['boja'] as String?,
      json['slika'] as String?,
      (json['cijena'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CarToJson(Car instance) => <String, dynamic>{
      'automobilId': instance.automobilId,
      'mjenjac': instance.mjenjac,
      'motor': instance.motor,
      'boja': instance.boja,
      'slika': instance.slika,
      'cijena': instance.cijena,
    };
