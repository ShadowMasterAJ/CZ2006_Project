import 'package:flutter/material.dart';
import '/screens/profile_screen.dart';
import '/screens/home_screen.dart';
import '/screens/auth_screen.dart';
import 'palette.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToiLocator',
      theme: ThemeData(
        primarySwatch: Palette.beige,
        backgroundColor: Palette.beige[50],
        accentColor: Colors.red,

        textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 30.0, color: Colors.black, fontWeight: FontWeight.bold),
          headline2: TextStyle(
              fontSize: 24.0, color: Colors.black, fontWeight: FontWeight.bold),
          headline3: TextStyle(fontSize: 24.0, color: Colors.black),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText1: TextStyle(fontSize: 18.0),
        ),

        // accentColorBrightness: Brightness.dark,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              primary: Palette.beige,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(33.0),
              )),
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(primary: Palette.beige)),
      ),
      home: AuthScreen(), // TODO: Need to add logic for AuthScreen
    );
  }
}
