import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_code/bloc_tema/Tema_bloc.dart';
import 'package:note_code/main.dart';
import 'package:note_code/models/languages.dart';
import 'package:note_code/utils/locator.dart';
import 'package:note_code/utils/utils.dart';

class Details extends StatefulWidget {
  String title;
  String content;
  var language;
  Details(
      {Key? key,
      required this.title,
      required this.content,
      required this.language})
      : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

final TemaBloc temaBloc = locator.get<TemaBloc>();

class _DetailsState extends State<Details> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Utils utils = Utils();
  CodeController? _codeController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _codeController = CodeController(
      text: widget.content,
      language: utils.getLangugage(widget.language),
      theme: temaBloc.code_theme,
    );
  }

  @override
  void dispose() {
    _codeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(widget.title),
          IconButton(
              onPressed: () async {
                var col = _firestore.collection("notes");
                final snapshot = col.snapshots().map((snapshot) => snapshot.docs
                    .where((doc) =>
                        doc.data()["title"] == widget.title ||
                        doc.data()["content"] == widget.content));
                var data = await snapshot.first;
                var jsonSp = data.toList();
                var noteId = jsonSp.first.id;
                _firestore
                    .doc("notes/" + noteId)
                    .update({"content": _codeController!.text});
                Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (a, b, c) => MyApp(),
                        transitionDuration: Duration(seconds: 0)),
                    (r) => false);
              },
              icon: Icon(Icons.check)),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: delete,
        child: Icon(Icons.delete_outline_outlined),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          CodeField(
            controller: _codeController!,
            textStyle: TextStyle(fontFamily: 'SourceCode'),
          )
        ]),
      ),
    );
  }

  delete() {
    return showDialog(
      context: context,
      builder: (builder) => AlertDialog(
        title: Text("Silmek İstediğinize Emin Misiniz"),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              var col = _firestore.collection("notes");
              final snapshot = col.snapshots().map((snapshot) => snapshot.docs
                  .where((doc) =>
                      doc.data()["title"] == widget.title ||
                      doc.data()["content"] == widget.content));
              var data = await snapshot.first;
              var jsonSp = data.toList();
              var noteId = jsonSp.first.id;
              _firestore.doc("notes/" + noteId).delete();
              var userDoc = _firestore.doc("users/" + _auth.currentUser!.uid);
              var user = await userDoc.get();
              var userData = user.data();
              List notes = userData!["notes"];
              var index = notes.remove(noteId);
              userDoc.update({"notes": notes});
              Navigator.of(context, rootNavigator: true).pop(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (a, b, c) => MyApp(),
                      transitionDuration: Duration(seconds: 0)),
                  (r) => false);
            },
            child: Text("EVET"),
          ),
        ],
      ),
    );
  }
}
