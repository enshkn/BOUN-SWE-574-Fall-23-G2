// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConfigAdapter extends TypeAdapter<Config> {
  @override
  final int typeId = 2;

  @override
  Config read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Config(
      onboardingCompleted: fields[0] as bool?,
      checkNotification: fields[1] as bool?,
      referanceCode: fields[2] as String?,
      email: fields[5] as String?,
      name: fields[3] as String?,
      surname: fields[4] as String?,
      username: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Config obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.onboardingCompleted)
      ..writeByte(1)
      ..write(obj.checkNotification)
      ..writeByte(2)
      ..write(obj.referanceCode)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.surname)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.username);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
