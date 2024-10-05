// ignore_for_file: public_member_api_docs, sort_constructors_first
class Contact {
  int? id;
  String? name;
  List<String>? numbers;
  String? picturePath;

  Contact({
    this.name,
    this.numbers,
    this.picturePath,
  });

  void setContactId({required int createdId})=> id = createdId;

  Map<String, dynamic> getBaseInfo(){
    return {
      'id': id,
      'name': name,
      'pic_path': picturePath,
    };
  }

  Map<String, dynamic> getNumberInfo(){
    return {
      'contact': id,
      'numbers': numbers,
    };
  }
}
