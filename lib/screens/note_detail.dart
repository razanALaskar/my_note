import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/modal_class/notes.dart';
import 'package:notes_app/db_helper/db_helper.dart';
import 'package:notes_app/utility/Category.dart';



class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdited = false;

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    descriptionController.text = note.description;
    return WillPopScope(
        onWillPop: () {
          isEdited ? showDiscardDialog(context) : moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              appBarTitle,
              style: Theme.of(context).textTheme.headline5,
            ),
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  isEdited ? showDiscardDialog(context) : moveToLastScreen();
                }),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.save, color: Colors.white),
                onPressed: () {
                  titleController.text.length == 0
                      ? showEmptyTitleDialog(context)
                      : _save();
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.white),
                onPressed: () {
                  showDeleteDialog(context);
                },
              )
            ],
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Category(
                selectedIndex: note.category,
                onTap: (index) {
                  isEdited = true;
                  note.category = index;
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    controller: titleController,
                    maxLength: 30,
                    style: Theme.of(context).textTheme.bodyText1,
                    onChanged: (value) {
                      updateTitle();
                    },
                    decoration: InputDecoration.collapsed(
                      hintText: 'Title',
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 20,
                      maxLength: 255,
                      controller: descriptionController,
                      style: Theme.of(context).textTheme.bodyText2,
                      onChanged: (value) {
                        updateDescription();
                      },
                      decoration: InputDecoration.collapsed(
                        hintText: 'Description',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void showDiscardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Discard Changes?",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          content: Text("Are you sure you want to discard changes?",
              style: Theme.of(context).textTheme.bodyText2),
          actions: <Widget>[
            FlatButton(
              child: Text("No",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Yes",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1),
              onPressed: () {
                Navigator.of(context).pop();
                moveToLastScreen();
              },
            ),
          ],
        );
      },
    );
  }

  void showEmptyTitleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Title is empty!",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          content: Text('The title of the note cannot be empty.',
              style: Theme.of(context).textTheme.bodyText2),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Delete Note?",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          content: Text("Are you sure you want to delete this note?",
              style: Theme.of(context).textTheme.bodyText2),
          actions: <Widget>[
            FlatButton(
              child: Text("No",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Yes",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1),
              onPressed: () {
                Navigator.of(context).pop();
                _delete();
              },
            ),
          ],
        );
      },
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateTitle() {
    isEdited = true;
    note.title = titleController.text;
  }

  void updateDescription() {
    isEdited = true;
    note.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    note.date = new DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    if (note.id != null) {
      await helper.updateNote(note);
    } else {
      await helper.insertNote(note);
    }
  }

// Save data from database
  void _delete() async {
    await helper.deleteNote(note.id);
    moveToLastScreen();
  }
}
