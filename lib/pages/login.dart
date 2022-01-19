import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_code/main.dart';
import 'package:note_code/pages/register.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameController = TextEditingController(text:"dyr.altunakar@gmail.com");
  TextEditingController passwordController = TextEditingController(text:"014025036987d.");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print("Kullanıcı yok");
      } else {
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => MyApp()));
        print("kullanıcı oturum açtı => $user");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Code Editor',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-mail',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Şifre',
                    ),
                  ),
                ),
                // FlatButton(
                //   onPressed: (){
                //     //forgot password screen
                //   },
                //   textColor: Colors.blue,
                //   child: Text('Forgot Password'),
                // ),
                SizedBox(
                  height: 30,
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Giriş Yap'),
                      onPressed: login,
                    )),
                SizedBox(
                  height: 20,
                ),
                Container(
                    child: Row(
                  children: <Widget>[
                    Text('henüz hesabınız yokmu?'),
                    FlatButton(
                      textColor: Colors.blue,
                      child: Text(
                        'Kayıt Olun!',
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Register()));
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                )),
                Container(
                    child: Row(
                  children: <Widget>[
                    Text('henüz hesabınız yokmu?'),
                    FlatButton(
                      textColor: Colors.blue,
                      child: Text(
                        'Oturum kapat!',
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: ()async {
                        await _auth.signOut();
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                )),
              ],
            )));
  }

  login() async {
    try {
      print("basıldı");
      if (_auth.currentUser == null) {
        User? oturum_acan_user = (await _auth.signInWithEmailAndPassword(
                email: nameController.text, password: passwordController.text))
            .user;
        if (oturum_acan_user!.emailVerified) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MyApp()));
        } else {
          _auth.signOut();
          print("email doğrulanmamış");
          SnackBar(
            content: Text("Eposta doğrulanmamış"),
          );
        }
      } else {
               
      }
    } catch (e) {
      print("****HATA => $e");
      SnackBar(
        content: Text("Giriş Yapıalamadı"),
      );
    }
  }
}
