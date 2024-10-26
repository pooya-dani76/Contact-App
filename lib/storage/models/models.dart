// ignore_for_file: public_member_api_docs, sort_constructors_first

class Contact {
  int id;
  String name;
  List<PhoneNumber> numbers;
  String? picturePath;

  Contact({
    required this.id,
    required this.name,
    required this.numbers,
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
}

class PhoneNumber {
  String countryCode;
  String number;

  PhoneNumber({
    required this.countryCode,
    required this.number,
  });

  Map toJson() {
    return {
      'country_code': countryCode,
      'number': number,
    };
  }
}