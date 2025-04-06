// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class AppUserAdapter extends TypeAdapter<AppUser> {
  @override
  final int typeId = 0;

  @override
  AppUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppUser(
      uid: fields[0] as String,
      email: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AppUser obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LocalAppUserAdapter extends TypeAdapter<LocalAppUser> {
  @override
  final int typeId = 1;

  @override
  LocalAppUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalAppUser(
      uid: fields[1] as String,
      email: fields[2] as String?,
      password: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LocalAppUser obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.password)
      ..writeByte(1)
      ..write(obj.uid)
      ..writeByte(2)
      ..write(obj.email);
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
