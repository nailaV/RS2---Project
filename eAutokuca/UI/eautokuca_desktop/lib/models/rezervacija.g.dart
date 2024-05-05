// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rezervacija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rezervacija _$RezervacijaFromJson(Map<String, dynamic> json) => Rezervacija(
      json['rezervacijaId'] as int?,
      json['datumVrijemeRezervacije'] == null
          ? null
          : DateTime.parse(json['datumVrijemeRezervacije'] as String),
      json['status'] as String?,
      json['automobil'] == null
          ? null
          : Car.fromJson(json['automobil'] as Map<String, dynamic>),
      json['korisnik'] == null
          ? null
          : Korisnici.fromJson(json['korisnik'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RezervacijaToJson(Rezervacija instance) =>
    <String, dynamic>{
      'rezervacijaId': instance.rezervacijaId,
      'datumVrijemeRezervacije':
          instance.datumVrijemeRezervacije?.toIso8601String(),
      'status': instance.status,
      'automobil': instance.automobil,
      'korisnik': instance.korisnik,
    };
