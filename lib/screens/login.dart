import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media/data/profile.dart';
import 'package:social_media/data/user.dart';
import 'package:social_media/screens/form.dart';
import 'package:social_media/screens/home.dart';
import 'package:social_media/screens/signup.dart';
import 'package:social_media/shared_preference_utils.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/router.dart' as router;
import 'package:social_media/routes.dart';

import 'dummy_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscurePassword = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  bool _isInAsyncCall = false;
  final globalKey = GlobalKey<ScaffoldState>();

@override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text('Sign in')),
        body: ModalProgressHUD(
          inAsyncCall: _isInAsyncCall,
          opacity: 0.5,
          progressIndicator: CircularProgressIndicator(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 30.0, 24.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 80),
                Form(
                    autovalidate: _autovalidate,
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        emailField("Email", emailController),
                        SizedBox(height: 20),
                        passwordFieldWithHiddenPassword(),
                        SizedBox(height: 40),
                      ],
                    )),
                submitButton(
                    "Login", Theme.of(context).primaryColor, loginOnClick),
                SizedBox(height: 20),
                registerUserText()
              ],
            ),
          ),
        ));
  }

  void loginOnClick() {
    if (_formKey.currentState.validate()) {
      // If the form is valid, proceed
      sendLoginPostRequest(emailController.text, passwordController.text);
    } else {
      //Enable autovalidation
      print('Invalid');
      setState(() => _autovalidate = true);
    }
  }

  void sendLoginPostRequest(String email, String password) async {
    // start the modal progress HUD
    setState(() {
      _isInAsyncCall = true;
    });

    String url = Constants.BASE_URL + "auth/";
    var dio = Dio();
    //If successful post
    try {
      Response<Map> response = await dio.post(
        url,
        data: {"email": email, 'password': password},
      );
      Map responseBody = response.data;
      String token = responseBody['token'];
      //print(token);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        preferences.setString("token", token);
      });
      setState(() {
        // stop the modal progress HUD
        _isInAsyncCall = false;
      });

      //Get self user id for future requests.
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["x-auth-token"] = responseBody["token"];
      String getSelfUrl = Constants.BASE_URL + "auth/";
      response = await dio.get(getSelfUrl);
      print(response.data);
      User user = User.fromJson(response.data);

      setState(() {
        preferences.setString("userID", user.id);
      });

      String getSelfProfileUrl = Constants.BASE_URL + "profile/me";
      response = await dio.get(getSelfProfileUrl);
      Profile profile = Profile.fromJson(response.data);


      Navigator.pushNamed(context, HomePageRoute, arguments:<String, dynamic>{'user':user,'pofile':profile});

    }
    //If any error is returned
    on DioError catch (e) {
      var errors;
      if (e.response != null) {
        print(e.response.data);
        errors = e.response.data;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        errors = {
          "errors": [
            {"msg": "Server error"}
          ]
        };
        print(e.request);
        print(e.message);
      }
      setState(() {
        // stop the modal progress HUD
        _isInAsyncCall = false;
      });
      final snackBar = SnackBar(content: Text(errors["errors"][0]["msg"]));
      globalKey.currentState.showSnackBar(snackBar);
    }
  }

  Widget registerUserText() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignupPage()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text('Create a new account',
            style: new TextStyle(color: Theme.of(context).primaryColor)),
      ),
    );
  }

  Widget passwordFieldWithHiddenPassword() {
    return TextField(
      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: obscurePassword, //This will obscure text dynamically
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter password',
        suffixIcon: IconButton(
            icon:
                Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
            color: Theme.of(context).primaryColorDark,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              setState(() {
                obscurePassword = !obscurePassword;
              });
            }),
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
}
