import 'package:hive/hive.dart';

part 'models.g.dart';

@HiveType(typeId: 0)
class Contact {
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

  Map toJson() {
    return {
      'id': id,
      'name': name,
      'pic_path': picturePath ?? "",
      'numbers': numbers,
    };
  }

  @override
  String toString() {
    return {
      'id': id,
      'name': name,
      'pic_path': picturePath,
      'numbers': numbers,
    }.toString();
  }

  bool isNumbersEqual(Contact other) {
    int numLength = numbers == null ? 0 : numbers!.length;
    int otherNumLength = other.numbers == null ? 0 : other.numbers!.length;
    if (numLength != otherNumLength) {
      return false;
    } else {
      for (int i = 0; i <= numLength; i++) {
        if (numbers![i] != other.numbers![i]) {
          return false;
        }
      }
      return true;
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is! Contact) {
      return false;
    }
    return name == other.name &&
        id == other.id &&
        picturePath == other.picturePath &&
        isNumbersEqual(other);
  }

  @override
  int get hashCode => Object.hash(id, name, picturePath, numbers);
}

Map a = {
  "1": {
    "id": 1,
    "name": "مهدی کونی",
    "pic_path": "/data/user/0/com.example.special_phone_book/cache/image_cropper_1728954917818.jpg",
    "numbers": ["09104981584"]
  },
  "2": {
    "id": 2,
    "name": "بابا۲",
    "pic_path": "/data/user/0/com.example.special_phone_book/cache/image_cropper_1728954955456.jpg",
    "numbers": ["09125085229", "09335084229"]
  },
  "3": {
    "id": 3,
    "name": "ابولفضل چاقال",
    "pic_path": null,
    "numbers": ["1545548495"]
  },
};
