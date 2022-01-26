import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_code/bloc_note/note_bloc.dart';
import 'package:note_code/bloc_tema/Tema_events.dart';
import 'package:note_code/models/Code.dart';
import 'package:note_code/models/Note.dart';
import 'package:note_code/models/themes.dart';
import 'package:note_code/pages/login.dart';
import 'package:note_code/pages/new_code.dart';
import 'package:note_code/pages/settings.dart';
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
Note not = Note();

x() async {
  var x = await utils.getTheme();
  if (x == "Açık") {
    temaBloc.theme = temaBloc.light;
    temaBloc.ad = "Açık";
    temaBloc.code_theme = xcodeTheme;
    print("************ tema => $x");
  }
  if (x == "Koyu") {
    temaBloc.theme = temaBloc.dark;
    temaBloc.ad = "Koyu";
    temaBloc.code_theme = monokaiSublimeTheme;
    print("************ tema => $x");
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
        seconds: 3,
        navigateAfterSeconds: AuthController(),
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
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemeData>(
      initialData: temaBloc.theme,
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
  _MyHomePageState createState() {
    x();
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  

  @override
  void initState() {
    super.initState();
  }

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
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => NewCodeQuestion()));
            }),
        body: FutureBuilder(
          future: not.getNotes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return RefreshIndicator(
                  onRefresh: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (a, b, c) => MyApp(),
                            transitionDuration: Duration(seconds: 0)),
                        (r) => false);
                    return Future.value(false);
                  },
                  child: ListView.builder(
                    itemCount: (snapshot.data as List).length,
                    itemBuilder: (context, index) {
                      return Cards(
                        title: (snapshot.data as List)[index].title,
                        content: (snapshot.data as List)[index].content,
                        language: (snapshot.data as List)[index].language,
                      );
                    },
                  ));
            }
            return Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
          },
        ));
  }
}
