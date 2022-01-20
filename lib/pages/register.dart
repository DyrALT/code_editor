import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:the_validator/the_validator.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  late String _email;
  late String _sifre;
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
                  'Kayıt Ol',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                ),
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      TextFormField(
                        onSaved: (newValue) {
                          setState(() {
                            _email = newValue!;
                          });
                        },
                        autofocus: false,
                        validator: (x) {
                          if (x!.isEmpty) {
                            return "Doldurulması Zorunludur!";
                          } else {
                            if (EmailValidator.validate(x) != true) {
                              return "Geçerli Bir Email Adresi Giriniz!";
                            } else {
                              return null;
                            }
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            errorStyle: TextStyle(fontSize: 18),
                            labelText: "Email",
                            labelStyle: TextStyle(fontSize: 20),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    width: 1, color: Colors.purple))),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        onSaved: (newValue) {
                          setState(() {
                            _sifre = newValue!;
                          });
                        },
                        obscureText: true,
                        validator: FieldValidator.password(
                          minLength: 8,
                          shouldContainNumber: true,
                          errorMessage:
                              "Minimum 8 Karakter uzunluğunda Olmalıdır!",
                          onNumberNotPresent: () {
                            return "Rakam İçermelidir!";
                          },
                        ),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            errorStyle: TextStyle(fontSize: 18),
                            labelText: "Şifre",
                            labelStyle: TextStyle(fontSize: 20),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    width: 1, color: Colors.purple))),
                      ),
                      SizedBox(height: 20),
                      Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width - 150,
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: ElevatedButton(
                            child: Text('Kayıt Ol',
                                style: TextStyle(fontSize: 20)),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ))),
                            onPressed: _emailSifreKayit,
                          )),
                    ],
                  ))
            ],
          )),
    );
  }

  void _emailSifreKayit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      var _firebaseUser = await _auth
          .createUserWithEmailAndPassword(email: _email, password: _sifre)
          .catchError((onError) => null);
      if (_firebaseUser != null) {
        Alert(
            type: AlertType.success,
            context: context,
            title: 'Başarıyla Kayıt Oldunuz',
            desc: 'Lütfen E-mail Adresinize Gelen Mesajı Doğrulayınız',
            buttons: [
              DialogButton(
                child: Text(
                  "KAPAT",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ]).show();
        formKey.currentState!.reset();

        _firebaseUser.user!
            .sendEmailVerification()
            .then((value) => null)
            .catchError((onError) => null);
      } else {
        Alert(
            context: context,
            type: AlertType.warning,
            title: 'Hata!',
            desc:
                "Sisteme Kayıtlı Bir Email Adresi Girdiniz. \n Lütfen Farklı Bir Email Adresi Giriniz!",
            buttons: [
              DialogButton(
                child: Text(
                  "KAPAT",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ]).show();
      }
    }
  }
}
