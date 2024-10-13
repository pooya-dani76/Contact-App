import 'package:hive/hive.dart';

part 'models.g.dart';

@HiveType(typeId: 0)
class Contact extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  List<String>? numbers;

  @HiveField(3)
  String? picturePath;

  Contact({
    this.id,
    this.name,
    this.numbers,
    this.picturePath,
  });

  @override
  String toString() {
    return {
      'id': id,
      'name': name,
      'pic_path': picturePath,
      'numbers': numbers,
    }.toString();
  }
}
