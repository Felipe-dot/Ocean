// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WaterStatusAdapter extends TypeAdapter<WaterStatus> {
  @override
  final int typeId = 2;

  @override
  WaterStatus read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WaterStatus(
      drinkingWaterGoal: fields[3] as int,
      amountOfWaterDrank: fields[5] as int,
      goalOfTheDayWasBeat: fields[4] as bool,
      statusDay: fields[6] as DateTime,
    )..waterStatusData = (fields[7] as List)?.cast<WaterStatus>();
  }

  @override
  void write(BinaryWriter writer, WaterStatus obj) {
    writer
      ..writeByte(5)
      ..writeByte(3)
      ..write(obj.drinkingWaterGoal)
      ..writeByte(4)
      ..write(obj.goalOfTheDayWasBeat)
      ..writeByte(5)
      ..write(obj.amountOfWaterDrank)
      ..writeByte(6)
      ..write(obj.statusDay)
      ..writeByte(7)
      ..write(obj.waterStatusData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
