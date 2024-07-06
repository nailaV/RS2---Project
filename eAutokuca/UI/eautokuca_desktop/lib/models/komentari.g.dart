// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'komentari.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Komentari _$KomentariFromJson(Map<String, dynamic> json) => Komentari(
      json['komentarId'] as int?,
      json['sadrzaj'] as String?,
      json['datumDodavanja'] == null
          ? null
          : DateTime.parse(json['datumDodavanja'] as String),
      json['korisnik'] == null
          ? null
          : Korisnici.fromJson(json['korisnik'] as Map<String, dynamic>),
      json['automobil'] == null
          ? null
          : Car.fromJson(json['automobil'] as Map<String, dynamic>),
      json['stanje'] as String?,
    );

Map<String, dynamic> _$KomentariToJson(Komentari instance) => <String, dynamic>{
      'komentarId': instance.komentarId,
      'sadrzaj': instance.sadrzaj,
      'datumDodavanja': instance.datumDodavanja?.toIso8601String(),
      'korisnik': instance.korisnik,
      'automobil': instance.automobil,
      'stanje': instance.stanje,
    };
