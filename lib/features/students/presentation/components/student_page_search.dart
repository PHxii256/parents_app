import 'package:flutter/material.dart';

class StudentPageSearch extends StatelessWidget {
  const StudentPageSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: SearchBar(
        trailing: [Icon(Icons.search)],
        //TODO localise and call this student search hint
        hintText: "Search Students By Name",
        elevation: WidgetStatePropertyAll(0),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(6))),
        ),
      ),
    );
  }
}
