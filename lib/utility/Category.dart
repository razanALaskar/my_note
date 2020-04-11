import 'package:flutter/material.dart';
import 'package:notes_app/app/app.dart';


class Category extends StatefulWidget {
  final Function(int) onTap;
  final int selectedIndex;
  Category({this.onTap, this.selectedIndex});
  @override
  CategoryState createState() => CategoryState();
}

class CategoryState extends State<Category> {
  int selectedIndex;
  static List<IconData> CategoryIcon = [Icons.favorite,Icons.local_airport, Icons.work,Icons.access_alarms];
  @override
  Widget build(BuildContext context) {
    if (selectedIndex == null) {
      selectedIndex = widget.selectedIndex;
    }
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onTap(index);
            },
            child: Container(
              padding: EdgeInsets.all(8.0),
              width: width / 4,
              height: 70,
              child: Container(
                child: Center(
                  child: Icon(CategoryIcon[index],
                          color: selectedIndex == index
                              ? NotesApp.colorCustom
                              : Colors.grey,
                          ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}