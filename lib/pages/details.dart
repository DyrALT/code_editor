import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:note_code/bloc_tema/Tema_bloc.dart';
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
        title: Text(widget.title),
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
