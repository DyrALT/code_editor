import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:note_code/bloc_tema/Tema_bloc.dart';
import 'package:note_code/models/Code.dart';
import 'package:note_code/models/languages.dart';
import 'package:note_code/main.dart';
import 'package:note_code/models/themes.dart';
import 'package:note_code/utils/locator.dart';

class NewCodeQuestion extends StatefulWidget {
  const NewCodeQuestion({Key? key}) : super(key: key);

  @override
  _NewCodeQuestionState createState() => _NewCodeQuestionState();
}

class _NewCodeQuestionState extends State<NewCodeQuestion> {
  TextEditingController? _title;
  List<DropDownItemModel> _dropDownItemModelList = [
    DropDownItemModel(
      text: "Python",
      dil: python,
    ),
    DropDownItemModel(
      dil: javascript,
      text: "JavaScript",
    ),
    DropDownItemModel(
      dil: cpp,
      text: "C++",
    ),
    DropDownItemModel(
      dil: cs,
      text: "C#",
    ),
    DropDownItemModel(
      dil: dart,
      text: "dart",
    ),
    DropDownItemModel(
      dil: java,
      text: "Java",
    ),
    DropDownItemModel(
      dil: arduino,
      text: "Arduino",
    ),
    DropDownItemModel(
      dil: bash,
      text: "Bash",
    ),
    DropDownItemModel(
      dil: css,
      text: "Css",
    ),
    DropDownItemModel(
      dil: kotlin,
      text: "Kotlin",
    ),
    DropDownItemModel(
      dil: json,
      text: "Json",
    ),
    DropDownItemModel(
      dil: perl,
      text: "Perl",
    ),
    DropDownItemModel(
      dil: go,
      text: "Go",
    ),
    DropDownItemModel(
      dil: php,
      text: "Php",
    ),
    DropDownItemModel(
      dil: ruby,
      text: "Ruby",
    ),
    DropDownItemModel(
      dil: xml,
      text: "Xml",
    ),
    DropDownItemModel(
      dil: swift,
      text: "Swift",
    ),
    DropDownItemModel(
      dil: sql,
      text: "Sql",
    ),
    DropDownItemModel(
      dil: objectivec,
      text: "Objective-C",
    ),
    DropDownItemModel(
      dil: gradle,
      text: "Gradle",
    ),
    DropDownItemModel(
      dil: rust,
      text: "Rust",
    )
  ];
  late DropDownItemModel _dropDownItemModel;
  @override
  void initState() {
    // TODO: implement initState
    _title = TextEditingController();
    _dropDownItemModel = _dropDownItemModelList[0];
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _title?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.fromLTRB(30, 50, 30, 0),
        child: Column(
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(
                icon: const Icon(Icons.text_snippet_outlined),
                hintText: 'Kod başlığını giriniz',
                labelText: 'Başlık',
              ),
            ),
            SizedBox(height: 40),
            Padding(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: DropdownButton(
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: _dropDownItemModelList
                      .map((e) => DropdownMenuItem<DropDownItemModel>(
                            child: Row(
                              children: [Text(e.text)],
                            ),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (DropDownItemModel? dropDownItemModel) {
                    setState(() {
                      _dropDownItemModel = dropDownItemModel!;
                      print(dropDownItemModel.text);
                    });
                  },
                  hint: Row(children: [Text(_dropDownItemModel.text)]),
                )),
            SizedBox(height: 30),
            Row(
              children: [Expanded(child: Divider())],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              ElevatedButton(
                  onPressed: () {
                    if (_title!.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Lütfen Not Başlığı Girin"),
                      ));
                    } else {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => NewCode(
                                title: _title!.text,
                                lanugage: _dropDownItemModel.dil,
                              )));
                    }
                  },
                  child: Text("İLERLE"))
            ])
          ],
        ),
      ),
    );
  }
}

class NewCode extends StatefulWidget {
  late String title;
  late var lanugage;
  NewCode({Key? key, required this.title, required this.lanugage})
      : super(key: key);

  @override
  _NewCodeState createState() => _NewCodeState();
}

final TemaBloc temaBloc = locator.get<TemaBloc>();
FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;

class _NewCodeState extends State<NewCode> {
  CodeController? _codeController;

  @override
  void initState() {
    super.initState();
    final source = """
""";
    // Instantiate the CodeController
    _codeController = CodeController(
      text: source,
      language: widget.lanugage,
      theme: temaBloc.code_theme, //
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title),
            IconButton(
                onPressed: () {
                  String lang = utils.setLangugage(widget.lanugage);
                  _firestore.collection("notes").add({
                    "title": widget.title,
                    "content": _codeController?.text,
                    "language": lang,
                  }).then((value) async {
                    var id = value.id; //not id
                    var user = await _firestore
                        .collection("users")
                        .doc(_auth.currentUser!.uid)
                        .get();
                    var ds = user.data();
                    List<dynamic> notlistesi = ds!["notes"];
                    notlistesi.add(id);
                    _firestore
                        .collection("users")
                        .doc(_auth.currentUser!.uid)
                        .update({"notes": notlistesi});
                  });
                  
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (a, b, c) => MyApp(),
                          transitionDuration: Duration(seconds: 2)),
                      (r) => false);
                },
                icon: Icon(Icons.check)),
          ],
        ),
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
}
