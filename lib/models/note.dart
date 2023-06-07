/// * JSON to Dart =>
/// {
///   "name" : "",
///   "info" : ""
/// }
/// =>

class Note {
  late String id;
  late String name;
  late String info;

  Note();

  Note.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    info = json['info'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['info'] = info;
    return data;
  }
}
