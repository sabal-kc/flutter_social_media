import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/router.dart' as router;
import 'package:social_media/routes.dart';
import 'form.dart';
import 'home.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool obscurePassword = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  bool _isInAsyncCall = false;
  final globalKey = GlobalKey<ScaffoldState>();

  Future<File> file;
  String base64Image;
  File tmpFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text('Sign Up')),
        body: ModalProgressHUD(
          inAsyncCall: _isInAsyncCall,
          opacity: 0.5,
          progressIndicator: CircularProgressIndicator(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 16.0, 30.0, 24.0),
              child: Column(
                children: <Widget>[
                  showImage(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      imagePickBtn(Icons.camera_alt, startCamera),
                      imagePickBtn(Icons.photo_album, startGallery)
                    ],
                  ),
                  Form(
                      autovalidate: _autovalidate,
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 30),
                          emailField("Email", emailController),
                          SizedBox(height: 20),
                          displayNameField("Display name", nameController),
                          SizedBox(height: 20),
                          passwordField("Password", passwordController),
                          SizedBox(height: 20),
                          passwordField(
                              "Confirm password", confirmPasswordController,
                              mirror: passwordController),
                          SizedBox(height: 40),
                        ],
                      )),
                  submitButton(
                      "Sign up", Theme.of(context).primaryColor, submitOnClick),
                ],
              ),
            ),
          ),
        ));
  }

  void startCamera() {
    chooseImage(ImageSource.camera);
  }

  void startGallery() {
    chooseImage(ImageSource.gallery);
  }

  void chooseImage(ImageSource source) {
    setState(() {
      file = ImagePicker.pickImage(source: source);
    });
  }

  Widget showImage() {
    //Wait for the file to be chosen and display it as a rounded circleavatar.
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<File>(
        future: file,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            tmpFile = snapshot.data;
            base64Image = base64Encode(snapshot.data.readAsBytesSync());

            return CircleAvatar(
                radius: 60,
                backgroundImage:
                    Image.file(snapshot.data, fit: BoxFit.fill).image);
          } else if (snapshot.error != null) {
            return Text('Error selecting image');
          } else {
            return CircleAvatar(
              radius: 60,
            );
          }
        },
      ),
    );
  }

  void submitOnClick() {
    if (_formKey.currentState.validate()) {
      // If the form is valid, proceed
      sendSignUpPostRequest(
          nameController.text, emailController.text, passwordController.text);
    } else {
      //Enable autovalidation
      print('Invalid');
      setState(() => _autovalidate = true);
    }
  }

  void sendSignUpPostRequest(String name, String email, String password) async {
    // start the modal progress HUD
    setState(() {
      _isInAsyncCall = true;
    });

    //Send post to the api
    FormData formData = new FormData.fromMap({
      'name': name,
      'email': email,
      'password': password,
      "displayImage": await MultipartFile.fromFile(tmpFile.path),
    });

    String url = Constants.BASE_URL + "users/";
    var dio = Dio();
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 5000;

    //If successful post
    try {
      Response<Map> response = await dio.post(url, data: formData);
      Map responseBody = response.data;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = responseBody['token'];
      print(token);
      setState(() {
        prefs.setString("token", token);
      });
      setState(() {
        // stop the modal progress HUD
        _isInAsyncCall = false;
      });
      Navigator.pushNamed(context, LogInRoute);
    }
    //If any error is returned
    on DioError catch (e) {
      var errors;
      if (e.response != null) {
        print(e.response.data);
        errors = e.response.data;
        // print(e.response.headers);
        // print(e.response.request);
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

    // Map data = {
    //   'name': name,
    //   'email': email,
    //   'password': password,
    //   'displayImage': base64Image == null ? '' : base64Image
    // };
    // Map<String, String> headers = {
    //   // 'Content-type': 'multipart/form-data',
    //   "Content-Type": "application/x-www-form-urlencoded",
    //   'Accept': 'application/json',
    // };
    // var response = await http.post(url,
    //     headers: headers,
    //     body: "body" + '=' + Uri.encodeQueryComponent(json.encode(data)));
    // print(response.body);
    // if (response.statusCode == 200) {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   var jsonData = json.decode(response.body);
    //   setState(() {
    //     prefs.setString("token", jsonData['response']['token']);
    //   });
    // } else {
    //   print(response.body);
    // }
  }
}
