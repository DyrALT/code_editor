import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_code/bloc_tema/Tema_bloc.dart';
import 'package:note_code/bloc_tema/Tema_events.dart';
import 'package:note_code/pages/login.dart';
import 'package:note_code/utils/locator.dart';
import 'package:note_code/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final TemaBloc temaBloc = locator.get<TemaBloc>();
FirebaseAuth _auth = FirebaseAuth.instance;
final utils = Utils();
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      body: Container(
          margin: EdgeInsets.all(30),
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.fromLTRB(50, 0, 50, 50),
                  child: DropdownButton(
                    // Initial Value
                    value: dropdownvalue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    isExpanded: true,
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
                  )),
              TextButton.icon(
                  onPressed: () async {
                    await _auth.signOut();
                    await utils.clearTheme();
                    temaBloc.theme = temaBloc.light;
                    print("çıkış yapıldı*****************************");

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                  (r) => false);
   
                  },
                  label: Text('Çıkış yap'),
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(fontSize: 15),
                  ),
                  icon: const Icon(Icons.logout)),
              TextButton.icon(
                  onPressed: oku,
                  label: Text('Selam'),
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(fontSize: 15),
                  ),
                  icon: const Icon(Icons.logout)),
            ],
          )),
    );
  }

  Future<void> oku() async {
    // FirebaseFirestore.instance
    // .collection('users')
    // .get()
    // .then((QuerySnapshot querySnapshot) {
    //     querySnapshot.docs.forEach((doc) {
    //         print(doc["email"]);
    //     });
    // });
    _firestore
        .collection('users')
        .where("email", isEqualTo: _auth.currentUser!.email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["email"]);
      });
    });
  }
  
}
