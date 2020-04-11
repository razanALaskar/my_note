import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notes_app/modal_class/notes.dart';
import 'package:notes_app/screens/note_detail.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/screens/search_note.dart';
import 'package:notes_app/utility/Category.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:notes_app/db_helper/db_helper.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper helper = DatabaseHelper();

  List<Note> noteList;
  int count = 0;
  int axisCount = 2;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    Widget myAppBar() {
      return AppBar(
        title: Text('My Notes', style: Theme.of(context).textTheme.headline5),
        centerTitle: true,
        bottom: PreferredSize(
            child: Text('${count} Notes', style: Theme.of(context).textTheme.headline6),
            preferredSize: null),
        elevation: 0,
        leading: noteList.length == 0
            ? Container()
            : IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () => search(),
              ),
        actions: <Widget>[
          IconButton(
            icon: Theme.of(context).brightness == Brightness.dark ?
          Icon(Icons.highlight,
            color: Colors.white):
          Icon(Icons.lightbulb_outline,
          color: Colors.white),
            onPressed: (){
              changeBrightness();
            },
          )
          ,noteList.length == 0
              ? Container(

          )
              : IconButton(
                  icon: Icon(
                    axisCount == 2 ? Icons.list : Icons.grid_on,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      axisCount = axisCount == 2 ? 4 : 2;
                    });
                  },
                )
        ],
      );
    }

    return Scaffold(
      appBar: myAppBar(),
      body: noteList.length == 0
          ? Container(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Click on the add button to add a new note!',
                      style: Theme.of(context).textTheme.bodyText1),
                ),
              ),
            )
          : Container(
              child: getNotesList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Note('', '', 0), 'Add Note');
        },
        tooltip: 'Add Note',
        child: Icon(Icons.add)
      ),
    );
  }

  Widget getNotesList() {
    return StaggeredGridView.countBuilder(
      physics: BouncingScrollPhysics(),
      crossAxisCount: 4,
      itemCount: count,
      itemBuilder: (BuildContext context, int index) => GestureDetector(
            onTap: () {
              navigateToDetail(this.noteList[index], 'Edit Note');
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0)),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              this.noteList[index].title,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ),
                        Icon(
                          CategoryState.CategoryIcon[this.noteList[index].category],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                                this.noteList[index].description == null
                                    ? ''
                                    : this.noteList[index].description,
                                style: Theme.of(context).textTheme.bodyText2),
                          )
                        ],
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(this.noteList[index].date,
                              style: Theme.of(context).textTheme.subtitle2),
                        ])
                  ],
                ),
              ),
            ),
          ),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(axisCount),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  changeBrightness() {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

  void navigateToDetail(Note note, String title) async {
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => NoteDetail(note, title)));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = helper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
  void search() async {
    final Note result = await showSearch(
        context: context, delegate: NotesSearch(notes: noteList));
    if (result != null) {
      navigateToDetail(result, 'Edit Note');
    }
  }
}
