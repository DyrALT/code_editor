import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:note_code/bloc_tema/Tema_bloc.dart';
import 'package:note_code/models/Code.dart';
import 'package:note_code/models/languages.dart';
import 'package:note_code/main.dart';
import 'package:note_code/models/themes.dart';
import 'package:note_code/utils/locator.dart';

class NewCode extends StatefulWidget {
  const NewCode({Key? key}) : super(key: key);

  @override
  _NewCodeState createState() => _NewCodeState();
}

final TemaBloc temaBloc = locator.get<TemaBloc>();

class _NewCodeState extends State<NewCode> {
  CodeController? _codeController;
  List<DropDownItemModel> _dropDownItemModelList = [
    DropDownItemModel(
      text: "Python",
    ),
    DropDownItemModel(
      text: "JavaScript",
    ),
    DropDownItemModel(
      text: "C++",
    ),
    DropDownItemModel(
      text: "C#",
    ),
    DropDownItemModel(
      text: "Java",
    ),
    DropDownItemModel(
      text: "Arduino",
    ),
    DropDownItemModel(
      text: "Bash",
    ),
    DropDownItemModel(
      text: "Css",
    ),
    DropDownItemModel(
      text: "Kotlin",
    ),
    DropDownItemModel(
      text: "Json",
    ),
    DropDownItemModel(
      text: "Perl",
    ),
    DropDownItemModel(
      text: "Go",
    ),
    DropDownItemModel(
      text: "Php",
    ),
    DropDownItemModel(
      text: "Ruby",
    ),
    DropDownItemModel(
      text: "Xml",
    ),
    DropDownItemModel(
      text: "Swift",
    ),
    DropDownItemModel(
      text: "Sql",
    ),
    DropDownItemModel(
      text: "Objective-C",
    ),
    DropDownItemModel(
      text: "Gradle",
    ),
    DropDownItemModel(
      text: "Rust",
    )
  ];
  late DropDownItemModel _dropDownItemModel;
  @override
  void initState() {
    _dropDownItemModel = _dropDownItemModelList[0];
    super.initState();
final source = 
"""
class Selam:
  def __init__(self):
    pass
""";
    // Instantiate the CodeController
    _codeController = CodeController(
      text: source,
      language: python,
      theme: temaBloc.code_theme,//
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
            Text(""),
            DropdownButton(
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
            ),
            IconButton(
                onPressed: () {
                  print(_codeController!.text);
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                },
                icon: Icon(Icons.check)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: CodeField(
          controller: _codeController!,
          textStyle: TextStyle(fontFamily: 'SourceCode'),
        ),
      ),
    );
  }
}
