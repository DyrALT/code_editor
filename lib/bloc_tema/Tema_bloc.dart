import 'dart:async';
import "package:flutter/material.dart";
import 'package:note_code/models/themes.dart';
import '../utils/utils.dart';
import 'Tema_events.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class TemaBloc {
  ThemeData theme =
      ThemeData(brightness: Brightness.light, accentColor: Colors.cyanAccent);
  ThemeData light =
      ThemeData(brightness: Brightness.light, accentColor: Colors.cyanAccent);

  ThemeData dark = ThemeData(
      primarySwatch: Colors.grey,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.grey.shade900,
      primaryColor: Colors.grey.shade900,
      accentColor: Colors.cyanAccent);
  int deger = 0; //0 : Açık , 1: Koyu ...
  String ad = "Açık";
  var code_theme = xcodeTheme;
  final _temaStateStreamController = StreamController<ThemeData>.broadcast();
  Stream<ThemeData> get tema => _temaStateStreamController.stream;
  StreamSink<ThemeData> get _temaStateSink => _temaStateStreamController.sink;

  final _temaEventStreamController = StreamController<TemaEvent>();
  Stream<TemaEvent> get _temaEventStream => _temaEventStreamController.stream;
  StreamSink<TemaEvent> get temaEventSink => _temaEventStreamController.sink;
  TemaBloc() {
    _temaEventStream.listen(_mapEventToState);
  }

  final utils = Utils();
  void _mapEventToState(TemaEvent event) async {
    if (event is AcikTemaDegistirEvent) {
      theme = light;
      ad = "Açık";
      code_theme = xcodeTheme;
      await utils.saveTheme(0);
    }
    if (event is KoyuTemaDegistirEvent) {
      theme = dark;
      ad = "Koyu";
      code_theme = monokaiSublimeTheme;
      await utils.saveTheme(1);
    }
    _temaStateSink.add(theme);
  }
}
