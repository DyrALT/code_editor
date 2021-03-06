import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:note_code/main.dart';
import 'package:note_code/pages/password_reset.dart';
import 'package:note_code/pages/register.dart';
import 'package:note_code/utils/auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:the_validator/the_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

AuthService authService = AuthService();
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AuthController extends StatefulWidget {
  const AuthController({Key? key}) : super(key: key);

  @override
  _AuthControllerState createState() => _AuthControllerState();
}

class _AuthControllerState extends State<AuthController> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authService.userVarmi(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data as bool;
          if (data) {
            WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                  (r) => false);
            });
          } else {
            WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                  (r) => false);
            });
          }
        }
        return Scaffold(
            body: Center(
          child: CircularProgressIndicator(),
        ));
      },
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

FirebaseAuth _auth = FirebaseAuth.instance;

class _LoginState extends State<Login> {
  var formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  bool _isLoading = false;
  late String _email;
  late String _sifre;
  late String _email2;
  late String _hataMesaji;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
        isLoading: _isLoading,
        child: MaterialApp(
            title: 'Note Code',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                brightness: Brightness.light, accentColor: Colors.cyanAccent),
            home: Scaffold(
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
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                onSaved: (newValue) {
                                  setState(() {
                                    _email = newValue!;
                                  });
                                },
                                autofocus: false,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Doldurulmas?? Zorunludur";
                                  } else {
                                    if (EmailValidator.validate(value) !=
                                        true) {
                                      return "Ge??erli Bir E-*posta giriniz";
                                    } else {
                                      return null;
                                    }
                                  }
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.email),
                                    errorStyle: TextStyle(fontSize: 15),
                                    labelText: "Email",
                                    labelStyle: TextStyle(fontSize: 20),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.purple))),
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                onSaved: (value) {
                                  _sifre = value!;
                                },
                                obscureText: true,
                                validator: FieldValidator.password(
                                  minLength: 8,
                                  shouldContainNumber: true,
                                  errorMessage:
                                      "Minimum 8 Karakter uzunlu??unda Olmal??d??r!",
                                  onNumberNotPresent: () {
                                    return "Rakam ????ermelidir!";
                                  },
                                ),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock),
                                    errorStyle: TextStyle(fontSize: 15),
                                    labelText: "??ifre",
                                    labelStyle: TextStyle(fontSize: 20),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.purple))),
                              ),
                              SizedBox(height: 20),
                              Container(
                                  child: Row(
                                children: <Widget>[
                                  Text('hen??z hesab??n??z yokmu?'),
                                  FlatButton(
                                    textColor: Colors.blue,
                                    child: Text(
                                      'Kay??t Olun!',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Register()));
                                    },
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              )),
                              Container(
                                  child: Row(
                                children: <Widget>[
                                  Text('??ifrenizi mi unuttunuz?'),
                                  FlatButton(
                                    textColor: Colors.blue,
                                    child: Text(
                                      '??ifre S??f??rla!',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ResetPass()));
                                    },
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              )),
                              SizedBox(height: 20),
                              Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: ElevatedButton(
                                    child: Text('Giri?? Yap',
                                        style: TextStyle(fontSize: 20)),
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                    ))),
                                    onPressed: _emailSifreGiris,
                                  )),
                              SizedBox(height: 50),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: MaterialButton(
                                  onPressed: googleGiris,
                                  color: Colors.teal[100],
                                  elevation: 10,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 50.0,
                                        width: 30.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/googleimage.png'),
                                              fit: BoxFit.cover),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text("Sign In with Google")
                                    ],
                                  ),

                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )))));
  }

  void _emailSifreGiris() async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();

        await _auth
            .signInWithEmailAndPassword(email: _email, password: _sifre)
            .then((user) {
          if (user.user!.emailVerified == false) {
            _auth.signOut();
            Alert(
                context: context,
                type: AlertType.warning,
                title: "Hata",
                desc: "L??tfen Email Adresinize Gelen Mesaj?? Onaylay??n",
                buttons: [
                  DialogButton(
                      child: Text('Kapat'),
                      onPressed: () {
                        WidgetsBinding.instance!
                            .addPostFrameCallback((timeStamp) {
                          Navigator.of(context, rootNavigator: true).pop();
                        });
                      })
                ]).show();
            setState(() {
              _isLoading = false;
            });
          } else {
            WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                  (r) => false);
            });
            formKey.currentState!.reset();
          }
        }).catchError((onError) {
          Alert(
              type: AlertType.warning,
              context: context,
              title: "Giri?? Yap??lamad??",
              desc: "E-postan??z veya ??ifreniz hatal??",
              buttons: [
                DialogButton(
                  child: Text(
                    "Kapat",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                )
              ]).show();
          setState(() {
            _isLoading = false;
          });
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("HATA VAR $e");
    }
  }

  googleGiris() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      var userId = _auth.currentUser!.uid;
      try {
        var user = await _firestore.collection("users").doc(userId).get();
        var x = user.data();
        if (x!.isEmpty) {
          print("X BO??");
        }
      } catch (e) {
        print("GOOGLE ??LE G??R???? YAPAMADI ENA??");
        _firestore.collection("users").doc(_auth.currentUser!.uid).set({
          "id": _auth.currentUser!.uid,
          "email": _auth.currentUser!.email,
          "notes": []
        });
        print("KAYIT EKLEND?? HAD?? BAKALAIM");
      }
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => MyApp()), (r) => false);
    } catch (e) {
      return null;
    }
  }
}
