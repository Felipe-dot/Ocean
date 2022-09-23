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
      userWeight: fields[0] as int,
      userWakeUpTime: fields[1] as DateTime,
      userSleepTime: fields[2] as DateTime,
      additionalReminder: fields[3] as bool,
      notificationTimeList: (fields[4] as List).cast<DateTime>(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.userWeight)
      ..writeByte(1)
      ..write(obj.userWakeUpTime)
      ..writeByte(2)
      ..write(obj.userSleepTime)
      ..writeByte(3)
      ..write(obj.additionalReminder)
      ..writeByte(4)
      ..write(obj.notificationTimeList);
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
