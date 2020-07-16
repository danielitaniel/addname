import 'package:hive/hive.dart';

part 'fileschema.g.dart';
@HiveType(typeId: 0)
class FileSchema {
  @HiveField(0)
  final String owner;
  @HiveField(1)
  final String fileName;
  @HiveField(2)
  final bool isFolder;
  @HiveField(3)
  final List<String> sharedWith;

  FileSchema(this.owner, this.fileName, this.isFolder, this.sharedWith);

}