// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oprema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Oprema _$OpremaFromJson(Map<String, dynamic> json) => Oprema(
      (json['opremaId'] as num?)?.toInt(),
      json['zracniJastuci'] as bool?,
      json['bluetooth'] as bool?,
      json['xenon'] as bool?,
      json['alarm'] as bool?,
      json['daljinskoKljucanje'] as bool?,
      json['navigacija'] as bool?,
      json['servoVolan'] as bool?,
      json['autoPilot'] as bool?,
      json['tempomat'] as bool?,
      json['parkingSenzori'] as bool?,
      json['grijanjeSjedista'] as bool?,
      json['grijanjeVolana'] as bool?,
    );

Map<String, dynamic> _$OpremaToJson(Oprema instance) => <String, dynamic>{
      'opremaId': instance.opremaId,
      'zracniJastuci': instance.zracniJastuci,
      'bluetooth': instance.bluetooth,
      'xenon': instance.xenon,
      'alarm': instance.alarm,
      'daljinskoKljucanje': instance.daljinskoKljucanje,
      'navigacija': instance.navigacija,
      'servoVolan': instance.servoVolan,
      'autoPilot': instance.autoPilot,
      'tempomat': instance.tempomat,
      'parkingSenzori': instance.parkingSenzori,
      'grijanjeSjedista': instance.grijanjeSjedista,
      'grijanjeVolana': instance.grijanjeVolana,
    };
