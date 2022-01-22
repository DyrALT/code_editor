import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_code/bloc_tema/Tema_bloc.dart';
import 'package:note_code/bloc_tema/Tema_events.dart';
import 'package:note_code/pages/login.dart';
import 'package:note_code/utils/locator.dart';
import 'package:note_code/utils/utils.dart';

final TemaBloc temaBloc = locator.get<TemaBloc>();
FirebaseAuth _auth = FirebaseAuth.instance;
final utils = Utils();


class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String dropdownvalue = temaBloc.ad;

  // List of items in our dropdown menu
  var items = [
    'Açık',
    'Koyu',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Column(
        children: [
          DropdownButton(
            // Initial Value
            value: dropdownvalue,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: items.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue == "Açık") {
                temaBloc.temaEventSink.add(AcikTemaDegistirEvent());
              }
              if (newValue == "Koyu") {
                temaBloc.temaEventSink.add(KoyuTemaDegistirEvent());
              }
              setState(() {
                dropdownvalue = newValue!;
              });
            },
          ),
          TextButton(
              onPressed: () async {
                await _auth.signOut();
                print("çıkış yapıldı*****************************");
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                  ModalRoute.withName('/'),
                );
              },
              child: Text('Çıkış yap')),
        ],
      ),
    );
  }
}
