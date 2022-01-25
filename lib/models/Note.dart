import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Note {
  String? title;
  String? content;
  String? language;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Note({this.title, this.content, this.language});

  Future<Map<String, dynamic>> getUser() async {
    try {
      var dokumanlar = await _firestore
          .collection("users")
          .where("id", isEqualTo: _auth.currentUser!.uid)
          .get();
      var _user = dokumanlar.docs[0]; //mevcut user bilgileri
      return _user.data();
    } catch (e) {
      return Map();
    }
  }

  getNotesId() async {
    Map<String, dynamic> userBilgileri = await getUser();
    if (userBilgileri.isEmpty) {
      return null;
    }
    List<String> notes = [];
    for (var i in userBilgileri["notes"]) {
      // print(i);
      notes.add(i);
    }
    print("NOT IDLERİ: $notes");
    return notes;
  }

  Future<List<Note>> getNotes() async {
    var notlarIdleri = await getNotesId();
    if (notlarIdleri == null) {
      List<Note> notlistesi = [];
      return notlistesi;
    }
    // print("GELEN NOTLAR: $notlarIdleri");
    List<Note> notlistesi = [];
    for (var i in notlarIdleri) {
      var not = await _firestore.doc("notes/" + i).get();
      var ds = not.data();
      // print(ds!["language"]);
      notlistesi.add(Note(
          title: ds!["title"],
          content: ds["content"],
          language: ds["language"]));
    }
    // print(notlistesi[0]);
    return notlistesi;
  }
}
