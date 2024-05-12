// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automobil_favorit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutomobilFavorit _$AutomobilFavoritFromJson(Map<String, dynamic> json) =>
    AutomobilFavorit(
      (json['automobilId'] as num?)?.toInt(),
      (json['korisnikId'] as num?)?.toInt(),
      json['automobil'] == null
          ? null
          : Car.fromJson(json['automobil'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AutomobilFavoritToJson(AutomobilFavorit instance) =>
    <String, dynamic>{
      'automobilId': instance.automobilId,
      'korisnikId': instance.korisnikId,
      'automobil': instance.automobil,
    };
