// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      drinkingWaterGoal: fields[0] as int,
      userWeight: fields[1] as int,
      userWakeUpTime: fields[2] as TimeOfDay,
      userSleepTime: fields[3] as TimeOfDay,
      goalOfTheDayBeat: (fields[4] as Map)?.cast<bool, DateTime>(),
      drinkingWaterStatus: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.drinkingWaterGoal)
      ..writeByte(1)
      ..write(obj.userWeight)
      ..writeByte(2)
      ..write(obj.userWakeUpTime)
      ..writeByte(3)
      ..write(obj.userSleepTime)
      ..writeByte(4)
      ..write(obj.goalOfTheDayBeat)
      ..writeByte(5)
      ..write(obj.drinkingWaterStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
