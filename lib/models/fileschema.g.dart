// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fileschema.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FileSchemaAdapter extends TypeAdapter<FileSchema> {
  @override
  final typeId = 0;

  @override
  FileSchema read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FileSchema(
      fields[0] as String,
      fields[1] as String,
      fields[2] as bool,
      (fields[3] as List)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, FileSchema obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.owner)
      ..writeByte(1)
      ..write(obj.fileName)
      ..writeByte(2)
      ..write(obj.isFolder)
      ..writeByte(3)
      ..write(obj.sharedWith);
  }
}
