// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gato_id.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GatoIdAdapter extends TypeAdapter<GatoId> {
  @override
  final int typeId = 3;

  @override
  GatoId read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GatoId(
      uid: fields[0] as String,
      imageUrl: fields[1] as String,
      name: fields[2] as String,
      doB: fields[3] as DateTime,
      occupation: fields[4] as String,
      madeIn: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GatoId obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.imageUrl)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.doB)
      ..writeByte(4)
      ..write(obj.occupation)
      ..writeByte(5)
      ..write(obj.madeIn);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GatoIdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
