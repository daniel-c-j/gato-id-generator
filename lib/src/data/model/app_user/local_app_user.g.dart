// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_app_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalAppUserAdapter extends TypeAdapter<LocalAppUser> {
  @override
  final int typeId = 2;

  @override
  LocalAppUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalAppUser(
      uid: fields[0] as String,
      email: fields[1] as String?,
      password: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LocalAppUser obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalAppUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
