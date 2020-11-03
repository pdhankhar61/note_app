class NoteDb {
  int _id;
  String _title;
  String _description;
  int _priority;
  String _date;

  NoteDb(
    this._date,
    this._title,
    this._priority, 
    this._description,
  ); //description is optional
  NoteDb.withID(
    this._date,
    this._title,
    this._priority,
    this._id, 
    this._description,
  ); //description is optional

  int get id {
    return _id;
  }

  String get title {
    return _title;
  }

  String get description {
    return _description;
  }

  int get priority {
    return _priority;
  }

  String get date {
    return _date;
  }

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(String newdescription) {
    if (newdescription.length <= 255) {
      this._description = newdescription;
    }
  }

  set priority(int newpriority) {
    if (newpriority == 1 || newpriority == 2) {
      this._priority = newpriority;
    }
  }

  set date(String newdate) {
    this._date = newdate;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;

    return map;
  }

  NoteDb.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._date = map['date'];
    this._title = map['title'];
    this._priority = map['priority'];
    this._description = map['description'];
  }
}
