import 'package:flutter/material.dart';
class Cards extends StatefulWidget {
  final title;
  const Cards({ Key? key,required this.title }) : super(key: key);

  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  @override
  Widget build(BuildContext context) {
    return Card(
              margin: EdgeInsets.all(10),
              elevation:20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              // color: Colors.grey[800],
              child: ListTile(
                leading: FlutterLogo(size: 40,),
                title: Text("${widget.title}",style:TextStyle(fontSize: 20,fontWeight: FontWeight.w300)),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(""),
                   ]
                ),
              ),
            );
  }
}