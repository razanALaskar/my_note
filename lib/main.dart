import 'package:flutter/material.dart';
import 'package:notes_app/app/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Brightness brightness;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  brightness =
  (prefs.getBool("isDark") ?? false) ? Brightness.dark : Brightness.light;
  runApp(NotesApp(brightness));
}


