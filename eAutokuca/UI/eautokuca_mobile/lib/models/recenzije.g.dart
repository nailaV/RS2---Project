// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recenzije.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recenzije _$RecenzijeFromJson(Map<String, dynamic> json) => Recenzije(
      (json['recenzijeId'] as num?)?.toInt(),
      json['sadrzaj'] as String?,
      (json['ocjena'] as num?)?.toInt(),
      json['korisnik'] == null
          ? null
          : Korisnici.fromJson(json['korisnik'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RecenzijeToJson(Recenzije instance) => <String, dynamic>{
      'recenzijeId': instance.recenzijeId,
      'sadrzaj': instance.sadrzaj,
      'ocjena': instance.ocjena,
      'korisnik': instance.korisnik,
    };
