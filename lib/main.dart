import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:note_code/bloc_tema/Tema_events.dart';
import 'package:note_code/pages/login.dart';
import 'package:note_code/pages/new_code.dart';
import 'package:note_code/utils/locator.dart';
import 'package:note_code/widgets/Cards.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'bloc_tema/Tema_bloc.dart';
import 'utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupLocator();
  runApp(new MaterialApp(
    home: SplashScren(),
    debugShowCheckedModeBanner: false,
  ));
}
// GetIt locator = GetIt.instance;

final utils = Utils();
final TemaBloc temaBloc = locator.get<TemaBloc>();
FirebaseAuth _auth = FirebaseAuth.instance;

var theme;
x() async {
  var x = await utils.getTheme();
  // theme = (x == 0) ? temaBloc.dark : temaBloc.light;
  if (x == 0) {
    theme = temaBloc.dark;
    temaBloc.deger = true;
    print("************ tema => $x");
  }
  if (x == 1) {
    theme = temaBloc.light;
    print("************ tema => $x");

    temaBloc.deger = false;
  }
}

class SplashScren extends StatefulWidget {
  const SplashScren({Key? key}) : super(key: key);

  @override
  _SplashScrenState createState() => _SplashScrenState();
}

class _SplashScrenState extends State<SplashScren> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    x();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 5,
        navigateAfterSeconds: Login(),
        title: new Text('Code Editor Yükleniyor'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        loaderColor: Colors.red);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() {
    print("************ CREATE STATE ÇALIŞTI");
    x();
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemeData>(
      initialData: theme,
      stream: temaBloc.tema,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Note Code',
          debugShowCheckedModeBanner: false,
          theme: snapshot.data,
          home: MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("Code Editor ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic)),
          IconButton(
              onPressed: () {
                // temaBloc.temaEventSink.add(TemaDegistirEvent());
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Settings()));
              },
              icon: Icon(Icons.settings)),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NewCode()));
          }),
      body: ListView(
        children: [
          Cards(title: "deneme"),
          Cards(title: "selam"),
          Cards(title: "merahab"),
          Cards(title: "ahahahaha"),
          Cards(title: "Main code"),
          Cards(title: "classlarım"),
          Cards(title: "1"),
          Cards(title: "2"),
          Cards(title: "3"),
          Cards(title: "4"),
          Cards(title: "5"),
          Cards(title: "6"),
        ],
      ),
    );
  }
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Column(
        children: [
          TextButton(
              onPressed: () {
                temaBloc.temaEventSink.add(TemaDegistirEvent());
              },
              child: Text('Tema değiştir')),
          TextButton(
              onPressed: () async {
                await _auth.signOut();
                print("çıkış yapıldı*****************************");
                print(await utils.getTheme());
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
