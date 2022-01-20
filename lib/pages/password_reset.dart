import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:the_validator/the_validator.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class ResetPass extends StatefulWidget {
  const ResetPass({Key? key}) : super(key: key);

  @override
  _ResetPassState createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  var formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? _email;
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
                  'Şifre Sıfırla',
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
                        autofocus: true,
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
                      SizedBox(height: 20),
                      Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width - 150,
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: ElevatedButton(
                            child:
                                Text('Sıfırla', style: TextStyle(fontSize: 20)),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ))),
                            onPressed: _sifreSifirla,
                          )),
                    ],
                  ))
            ],
          )),
    );
  }

  void _sifreSifirla() async {
    print("********************" + _email.toString());
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        await _auth.sendPasswordResetEmail(email: _email.toString());
        Alert(
            type: AlertType.success,
            context: context,
            title: "E-postanıza Şifre Sıfırlama Linki Gönderildi",
            desc:
                "Lütfen E-postanıza Gönderilen Link ile Şifrenizi Sıfırlayınız",
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
      }
    } catch (e) {
      Alert(
          type: AlertType.warning,
          context: context,
          title: "Hata",
          desc: "Bir Hata meydana Geldi",
          buttons: [
            DialogButton(
              child: Text(
                "Kapat",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            )
          ]).show();
      print("******************* $e");
    }
  }
}
