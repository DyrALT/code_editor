import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:note_code/models/Code.dart';
import 'package:note_code/models/languages.dart';
import 'package:note_code/main.dart';

class NewCode extends StatefulWidget {
  const NewCode({Key? key}) : super(key: key);

  @override
  _NewCodeState createState() => _NewCodeState();
}

class _NewCodeState extends State<NewCode> {
  CodeController? _codeController;
  List<DropDownItemModel> _dropDownItemModelList = [
    DropDownItemModel(
      text: "Python",
    ),
    DropDownItemModel(
      text: "JavaScript",
    ),
    DropDownItemModel(
      text: "C++",
    ),
    DropDownItemModel(
      text: "C#",
    ),
    DropDownItemModel(
      text: "Java",
    ),
    DropDownItemModel(
      text: "Arduino",
    ),
    DropDownItemModel(
      text: "Bash",
    ),
    DropDownItemModel(
      text: "Css",
    ),
    DropDownItemModel(
      text: "Kotlin",
    ),
    DropDownItemModel(
      text: "Json",
    ),
    DropDownItemModel(
      text: "Perl",
    ),
    DropDownItemModel(
      text: "Go",
    ),
    DropDownItemModel(
      text: "Php",
    ),
    DropDownItemModel(
      text: "Ruby",
    ),
    DropDownItemModel(
      text: "Xml",
    ),
    DropDownItemModel(
      text: "Swift",
    ),
    DropDownItemModel(
      text: "Sql",
    ),
    DropDownItemModel(
      text: "Objective-C",
    ),
    DropDownItemModel(
      text: "Gradle",
    ),
    DropDownItemModel(
      text: "Rust",
    )
  ];
  late DropDownItemModel _dropDownItemModel;
  @override
  void initState() {
    _dropDownItemModel = _dropDownItemModelList[0];
    super.initState();
    final source = """
def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader('UTF-8') { reader ->
        localProperties.load(reader)
    }
}

def flutterRoot = localProperties.getProperty('flutter.sdk')
if (flutterRoot == null) {
    throw new GradleException("Flutter SDK not found. Define location with flutter.sdk in the local.properties file.")
}

def flutterVersionCode = localProperties.getProperty('flutter.versionCode')
if (flutterVersionCode == null) {
    flutterVersionCode = '1'
}

def flutterVersionName = localProperties.getProperty('flutter.versionName')
if (flutterVersionName == null) {
    flutterVersionName = '1.0'
}

apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'
apply from: "\$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"
apply plugin: 'com.google.gms.google-services'

android {
    compileSdkVersion 30

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId "com.example.note_code"
        minSdkVersion 16
        targetSdkVersion 30
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig signingConfigs.debug
        }
    }
}

flutter {
    source '../..'
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:\$kotlin_version"
}

""";
    // Instantiate the CodeController
    _codeController = CodeController(
      text: source,
      language: gradle,
      theme: monokaiSublimeTheme,
    );
  }

  @override
  void dispose() {
    _codeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(""),
            DropdownButton(
              items: _dropDownItemModelList
                  .map((e) => DropdownMenuItem<DropDownItemModel>(
                        child: Row(
                          children: [Text(e.text)],
                        ),
                        value: e,
                      ))
                  .toList(),
              onChanged: (DropDownItemModel? dropDownItemModel) {
                setState(() {
                  _dropDownItemModel = dropDownItemModel!;
                  print(dropDownItemModel.text);
                });
              },
              hint: Row(children: [Text(_dropDownItemModel.text)]),
            ),
            IconButton(
                onPressed: () {
                  print(_codeController!.text);
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                },
                icon: Icon(Icons.check)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: CodeField(
          controller: _codeController!,
          textStyle: TextStyle(fontFamily: 'SourceCode'),
        ),
      ),
    );
  }
}
