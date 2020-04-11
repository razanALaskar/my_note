import 'package:intl/intl.dart';

class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  int _category;

  Note(this._title, this._date, this._category,
      [this._description]);

  Note.withId(this._id, this._title, this._date,  this._category,
      [this._description]);

  int get id => _id;

  String get title => _title;

  String get description => _description;

  int get category => _category;
  String get date => _date;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }


  set category(int newcategory) {
    if (newcategory >= 0 && newcategory <= 4) {
      this._category = newcategory;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['category'] = _category;
    map['date'] = _date;

    return map;
  }

  // Extract a Note object from a Map object
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._category = map['category'];
    var date = DateTime.parse(map['date']);
    var formatter = new DateFormat('yyyy-MM-dd HH:mm');
    String formatted = formatter.format(date);
    this._date =formatted;
  }
}
