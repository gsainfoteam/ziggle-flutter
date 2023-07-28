// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'write_store.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WriteStoreAdapter extends TypeAdapter<_$_WriteStore> {
  @override
  final int typeId = 0;

  @override
  _$_WriteStore read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$_WriteStore(
      title: fields[0] as String,
      body: fields[1] as String,
      deadline: fields[2] as DateTime?,
      imagePaths: (fields[3] as List).cast<String>(),
      tags: (fields[4] as List).cast<String>(),
      typeIndex: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, _$_WriteStore obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.body)
      ..writeByte(2)
      ..write(obj.deadline)
      ..writeByte(3)
      ..write(obj.imagePaths.toList())
      ..writeByte(5)
      ..write(obj.typeIndex)
      ..writeByte(4)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WriteStoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
