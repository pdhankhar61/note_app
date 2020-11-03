import 'package:note_app/utils/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/models/noteDb.dart';

class NoteDetail extends StatefulWidget {
  final String appBartTitle;
  final NoteDb noteDb;
  NoteDetail(this.noteDb, this.appBartTitle);
  @override
  _NoteDetailState createState() =>
      _NoteDetailState(this.noteDb, this.appBartTitle);
}

class _NoteDetailState extends State<NoteDetail> {
  DatabaseHelper helper = DatabaseHelper();

  String title;
  NoteDb noteDb;
  _NoteDetailState(this.noteDb, String title) {
    this.title = title;
    this.noteDb = noteDb;
  }

  static var _priority = ["High", "Low"];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = noteDb.title;
    descriptionController.text = noteDb.description;
    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                moveToLastScreen();
              }),
        ),
        body: getDetail(context),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void udatePriorityAsInt(String value) {
    switch (value) {
      case "High":
        noteDb.priority = 1;

        break;
      case "Low":
        noteDb.priority = 2;

        break;
    }
  }

  String udatePriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priority[0];

        break;
      case 2:
        priority = _priority[1];

        break;
    }
    return priority;
  }

  void updateTitle() {
    noteDb.title = titleController.text;
  }

  void updateDescription() {
    noteDb.description = descriptionController.text;
  }

  void _delete() async {
    if (noteDb.id == null) {
      _showAlert("status", "no note was deleted");
      return;
    }
    int result = await helper.deleteNote(noteDb.id);

    if (result != 0) {
      _showAlert("status", "note deleted Successfully");
    } else {
      _showAlert("status", "something went wrong");
    }
  }

  void _save() async {
    moveToLastScreen();
    noteDb.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (noteDb.id != null) {
      result = await helper.updateNote(noteDb);
    } else {
      result = await helper.insertNote(noteDb);
    }

    if (result != 0) {
      _showAlert("status", "note saved Successfully");
    } else {
      _showAlert("status", "something went wrong");
    }
  }

  void _showAlert(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );

    showDialog(context: context, builder: (_) => alertDialog);
  }

  Widget getDetail(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: ListView(
        children: [
          ListTile(
            title: DropdownButton(
                items: _priority.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                value: udatePriorityAsString(noteDb.priority),
                onChanged: (value) {
                  setState(() {
                    udatePriorityAsInt(value);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: titleController,
              onChanged: (value) {
                updateTitle();
              },
              decoration: InputDecoration(
                  labelText: "Enter Title",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: descriptionController,
              onChanged: (value) {
                updateDescription();
              },
              decoration: InputDecoration(
                  labelText: "Enter Description",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      _save();
                    });
                  },
                  color: Theme.of(context).primaryColorDark,
                  textColor: Colors.white,
                  child: Text(
                    "Save",
                    textScaleFactor: 1.3,
                  ),
                )),
                SizedBox(width: 5.0),
                Expanded(
                    child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      _delete();
                    });
                  },
                  color: Theme.of(context).primaryColorDark,
                  textColor: Colors.white,
                  child: Text(
                    "Delete",
                    textScaleFactor: 1.3,
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
