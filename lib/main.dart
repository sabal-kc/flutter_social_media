import 'package:flutter/material.dart';
import 'package:social_media/routes.dart';
import 'package:social_media/screens/home.dart';
import 'package:social_media/screens/login.dart';
import 'package:social_media/router.dart' as router;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      theme: ThemeData(
          primaryColor: Color(0xff15202C),
          primaryColorDark: Color(0xff1B2939),
          accentColor: Color(0xff1CA1F1),
          iconTheme: IconThemeData(color: Color(0xff1CA1F1))),
      initialRoute: LogInRoute,
      onGenerateRoute: router.generateRoute,
    );
  }
}
