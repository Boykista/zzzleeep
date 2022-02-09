// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleepinput.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SleepDataAdapter extends TypeAdapter<SleepData> {
  @override
  final int typeId = 0;

  @override
  SleepData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SleepData(
      date: fields[0] as DateTime?,
      fallenAsleep: fields[1] as String,
      wokenUp: fields[2] as String,
      hours: fields[4] as int,
      minutes: fields[5] as int,
      notes: fields[3] as String,
    )
      ..keyDate = fields[6] as String?
      ..list = (fields[7] as List?)?.cast<SleepData>();
  }

  @override
  void write(BinaryWriter writer, SleepData obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.fallenAsleep)
      ..writeByte(2)
      ..write(obj.wokenUp)
      ..writeByte(3)
      ..write(obj.notes)
      ..writeByte(4)
      ..write(obj.hours)
      ..writeByte(5)
      ..write(obj.minutes)
      ..writeByte(6)
      ..write(obj.keyDate)
      ..writeByte(7)
      ..write(obj.list);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SleepDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
