import 'package:notes_app/screens/note_list.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';



class NotesApp extends StatelessWidget {
  final Brightness brightness;

   static Map<int, Color> color =
  {
    50:Color.fromRGBO(136,14,79, .1),
    100:Color.fromRGBO(136,14,79, .2),
    200:Color.fromRGBO(136,14,79, .3),
    300:Color.fromRGBO(136,14,79, .4),
    400:Color.fromRGBO(136,14,79, .5),
    500:Color.fromRGBO(136,14,79, .6),
    600:Color.fromRGBO(136,14,79, .7),
    700:Color.fromRGBO(136,14,79, .8),
    800:Color.fromRGBO(136,14,79, .9),
    900:Color.fromRGBO(136,14,79, 1),
  };

  static MaterialColor colorCustom = MaterialColor(0xFF880E4F, color);

  NotesApp(this.brightness);

  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        data: (brightness) =>
            ThemeData(
              primarySwatch: colorCustom,
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                foregroundColor: Colors.white,
              ),
              textTheme: TextTheme(
                headline5: TextStyle(
                    fontFamily: 'Sans',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 24),
                headline6: TextStyle(
                    fontFamily: 'Sans',
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontSize: 14),
                bodyText1: TextStyle(
                    fontFamily: 'Sans',
                    fontWeight: FontWeight.bold,
                    color: colorCustom,
                    fontSize: 20),
                bodyText2: TextStyle(
                    fontFamily: 'Sans',
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: 18),
                subtitle2: TextStyle(
                    fontFamily: 'Sans',
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                    fontSize: 14),
              ),
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            theme: theme,
            title: 'MyNotes',
            debugShowCheckedModeBanner: false,
            home: NoteList(),
          );
        }
    );
  }
  }