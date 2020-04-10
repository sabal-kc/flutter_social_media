import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {

  static ThemeData darkTheme = ThemeData(
      primaryColor: Color(0xff15202C),
      primaryColorDark: Color(0xff1B2939),
      disabledColor: Colors.grey,

      primaryTextTheme: TextTheme(
        title: TextStyle(color: Colors.white),
        body1:TextStyle(color:Colors.white),
        body2: TextStyle(color: Colors.grey),
        subtitle: TextStyle(color: Colors.white, fontSize: 10,
            fontWeight: FontWeight.w300),
      ),
      accentColor: Color(0xff1CA1F1),
      iconTheme: IconThemeData(color: Color(0xff1CA1F1))

  );

  static ThemeData lightTheme = ThemeData(
      primaryColor: Colors.white,
      primaryColorDark:Colors.white,
      disabledColor: Colors.black54,

      primaryTextTheme: TextTheme(
        title: TextStyle(color: Colors.black87),
        body1:TextStyle(color:Colors.black87),
        body2: TextStyle(color: Colors.black12),
        subtitle: TextStyle(color: Colors.black87, fontSize: 10,
            fontWeight: FontWeight.w300),
      ),
      accentColor: Color(0xff1CA1F1),
      iconTheme: IconThemeData(color: Color(0xff1CA1F1))

  );


  String _themeType;
  ThemeChanger (this._themeType);

  ThemeData getTheme(){
    if(_themeType == "dark")
      return darkTheme;
    else
      return lightTheme;

  }
  setTheme(String themeType){
    _themeType = themeType;
    notifyListeners();
  }
}