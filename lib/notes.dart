import 'package:note_app/note_detail.dart';
import 'package:note_app/utils/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:note_app/models/noteDb.dart';

class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<NoteDb> noteList;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = [];
      updateListview();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: getlistview(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          toNavigate(NoteDb("", "", 2, ""), "Add Note");
        },
        tooltip: "Add Note",
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getlistview(BuildContext context) {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2.0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    getprioritycolor(this.noteList[index].priority),
                child: getpriorityicon(this.noteList[index].priority),
              ),
              trailing: GestureDetector(
                child: Icon(Icons.delete),
                onTap: () {
                  delete(context, noteList[index]);
                },
              ),
              title: Text(this.noteList[index].title),
              subtitle: Text(this.noteList[index].date),
              onTap: () {
                toNavigate(this.noteList[index], "Edit Note");
              },
            ),
          ),
        );
      },
    );
  }

  void toNavigate(NoteDb noteDb, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(noteDb, title);
    }));
    if (result == true) {
      updateListview();
    }
  }

  Color getprioritycolor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

  Icon getpriorityicon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void delete(BuildContext context, NoteDb noteDb) async {
    int result = await databaseHelper.deleteNote(noteDb.id);
    if (result != 0) {
      _showSnackBar(context, 'Note is deleted Successfully');
      updateListview();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackbar = SnackBar(
      content: Text(message),
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void updateListview() {
    final Future<Database> dbFuture = databaseHelper.initialzeDatabase();
    dbFuture.then((database) {
      Future<List<NoteDb>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
