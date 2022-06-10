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
      drinkingWaterGoal: fields[0] as int,
      amountOfWaterDrank: fields[2] as int,
      goalOfTheDayWasBeat: fields[1] as bool,
      statusDay: fields[4] as DateTime,
      drinkingFrequency: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WaterStatus obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.drinkingWaterGoal)
      ..writeByte(1)
      ..write(obj.goalOfTheDayWasBeat)
      ..writeByte(2)
      ..write(obj.amountOfWaterDrank)
      ..writeByte(3)
      ..write(obj.drinkingFrequency)
      ..writeByte(4)
      ..write(obj.statusDay);
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
