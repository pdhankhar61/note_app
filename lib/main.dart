import 'package:flutter/material.dart';
import 'notes.dart';

//import 'note_detail.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'notes',
        theme: ThemeData(primarySwatch: Colors.red),
        home: Notes());
  }
}
