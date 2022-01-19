import 'dart:async';
import "package:flutter/material.dart";
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
  bool deger = false; //true koyu false açık

  final _temaStateStreamController = StreamController<ThemeData>.broadcast();
  Stream<ThemeData> get tema => _temaStateStreamController.stream;
  StreamSink<ThemeData> get _temaStateSink => _temaStateStreamController.sink;

  final _temaEventStreamController = StreamController<TemaEvent>();
  Stream<TemaEvent> get temaEventStream => _temaEventStreamController.stream;
  StreamSink<TemaEvent> get temaEventSink => _temaEventStreamController.sink;
  TemaBloc() {
    temaEventStream.listen(_mapEventToState);
  }

  final utils = Utils();
  void _mapEventToState(TemaEvent event) async {
    if (event is TemaDegistirEvent) {
      if (deger) {
        theme = light;
        deger = false;
        utils.saveTheme(1);
      } else {
        theme = dark;
        deger = true;
        utils.saveTheme(0);
      }
    }
    _temaStateSink.add(theme);
  }
}
