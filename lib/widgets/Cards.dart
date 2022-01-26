import 'package:flutter/material.dart';

import 'package:note_code/pages/details.dart';

class Cards extends StatefulWidget {
  String title;
  String content;
  var language;
  Cards({
    Key? key,
    required this.title,
    required this.content,
    required this.language,
  }) : super(key: key);

  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      // color: Colors.grey[800],
      child: InkWell(
        child: ListTile(
          leading: FlutterLogo(
            size: 40,
          ),
          title: Text("${widget.title}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
          subtitle: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text(""),
          ]),
        ),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Details(title: widget.title,content: widget.content,language: widget.language)));
        },
      ),
    );
  }
}
