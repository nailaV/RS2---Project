// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'narudzba.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Narudzba _$NarudzbaFromJson(Map<String, dynamic> json) => Narudzba(
      (json['narudzbaId'] as num?)?.toInt(),
      (json['ukupniIznos'] as num?)?.toDouble(),
      json['korisnik'] == null
          ? null
          : Korisnici.fromJson(json['korisnik'] as Map<String, dynamic>),
      json['datumNarudzbe'] == null
          ? null
          : DateTime.parse(json['datumNarudzbe'] as String),
      json['status'] as String?,
      json['brojTransakcije'] as String?,
    );

Map<String, dynamic> _$NarudzbaToJson(Narudzba instance) => <String, dynamic>{
      'narudzbaId': instance.narudzbaId,
      'ukupniIznos': instance.ukupniIznos,
      'korisnik': instance.korisnik,
      'datumNarudzbe': instance.datumNarudzbe?.toIso8601String(),
      'status': instance.status,
      'brojTransakcije': instance.brojTransakcije,
    };
