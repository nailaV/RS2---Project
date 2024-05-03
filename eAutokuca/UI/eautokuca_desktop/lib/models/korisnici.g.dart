// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnici.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Korisnici _$KorisniciFromJson(Map<String, dynamic> json) => Korisnici(
      json['korisnikId'] as int?,
      json['ime'] as String?,
      json['prezime'] as String?,
      json['email'] as String?,
      json['telefon'] as String?,
      json['username'] as String?,
      json['datumRegistracije'] == null
          ? null
          : DateTime.parse(json['datumRegistracije'] as String),
      json['stanje'] as bool?,
      json['slika'] as String?,
    );

Map<String, dynamic> _$KorisniciToJson(Korisnici instance) => <String, dynamic>{
      'korisnikId': instance.korisnikId,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'email': instance.email,
      'telefon': instance.telefon,
      'username': instance.username,
      'datumRegistracije': instance.datumRegistracije?.toIso8601String(),
      'stanje': instance.stanje,
      'slika': instance.slika,
    };
