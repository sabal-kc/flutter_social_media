import 'package:flutter/material.dart';
import 'package:social_media/theme.dart';

TextFormField emailField(String title, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.emailAddress,
    validator: (value) {
      if (value.isEmpty) {
        return 'Please enter some text';
      }
      if (!isEmail(value)) {
        return 'Please enter correct email';
      }
      return null;
    },
    decoration: InputDecoration(
      labelText: title,
      hintText: 'Enter ' + title,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
      ),
      filled: true,
      contentPadding: EdgeInsets.all(20),
      fillColor: Colors.white60,
    ),
  );
}

bool isEmail(String em) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = new RegExp(p);

  return regExp.hasMatch(em);
}

MaterialButton imagePickBtn(IconData data, Function onClick) {
  return MaterialButton(
    onPressed: () {
      onClick();
    },
    color: Colors.blue,
    textColor: Colors.white,
    child: Icon(
      data,
      size: 24,
    ),
    padding: EdgeInsets.all(8),
    shape: CircleBorder(),
  );
}

TextFormField displayNameField(String title, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.text,
    validator: (value) {
      if (value.isEmpty) {
        return 'Please enter some text';
      }
      return null;
    },
    decoration: InputDecoration(
      labelText: title,
      hintText: 'Enter ' + title,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
      ),
      filled: true,
      contentPadding: EdgeInsets.all(20),
      fillColor: Colors.white60,
    ),
  );
}

TextFormField passwordField(String title, TextEditingController controller,
    {TextEditingController mirror}) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.text,
    obscureText: true, //This will obscure text dynamically
    validator: (value) {
      if (value.isEmpty) {
        return 'Please enter some text';
      }
      if (mirror != null && controller.text != mirror.text) {
        return 'Password does not match';
      }
      if (value.length < 6) {
        return 'Password must be more than 6 characters';
      }
      return null;
    },
    decoration: InputDecoration(
      labelText: title,
      hintText: 'Enter ' + title,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
      ),
      filled: true,
      contentPadding: EdgeInsets.all(20),
      fillColor: Colors.white70,
    ),
  );
}

SizedBox submitButton(String title, Color color, Function onClick) {
  return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        padding: EdgeInsets.all(12),
        onPressed: () {
          onClick();
        },
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.transparent)),
        color: color,
        child: Text(title, style: TextStyle(fontSize: 16, color: Colors.white)),
      ));
}

TextFormField bioField(String title, TextEditingController controller) {
  return TextFormField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      minLines: 3,
      maxLines: null,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        labelText: title,
        labelStyle: TextStyle(
          color: ThemeChanger.darkTheme.accentColor,
        ),
        hintText: 'Enter ' + title,
        filled: true,
        fillColor: ThemeChanger.darkTheme.primaryColorDark,
      ));
}
