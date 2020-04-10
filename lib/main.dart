import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/routes.dart';
import 'package:social_media/screens/home.dart';
import 'package:social_media/screens/login.dart';
import 'package:social_media/router.dart' as router;
import 'package:social_media/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      builder: (_)=>ThemeChanger("dark"),
      child:new MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

  final theme = Provider.of<ThemeChanger>(context);


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme.getTheme(),
      initialRoute: LogInRoute,
      onGenerateRoute: router.generateRoute,
    );
  }
}
