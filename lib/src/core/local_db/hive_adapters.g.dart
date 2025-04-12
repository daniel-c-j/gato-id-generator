// coverage:ignore-file
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
      other is AppUserAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
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
      other is LocalAppUserAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class GatoIdAdapter extends TypeAdapter<GatoId> {
  @override
  final int typeId = 2;

  @override
  GatoId read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GatoId(
      uid: fields[0] as String,
      name: fields[1] as String,
      doB: fields[2] as DateTime,
      isMale: fields[6] as bool,
      occupation: fields[3] as String,
      madeIn: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GatoId obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.doB)
      ..writeByte(3)
      ..write(obj.occupation)
      ..writeByte(4)
      ..write(obj.madeIn)
      ..writeByte(6)
      ..write(obj.isMale);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GatoIdAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
