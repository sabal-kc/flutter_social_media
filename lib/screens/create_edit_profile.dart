import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/data/profile.dart';
import 'package:social_media/data/user.dart';
import 'package:social_media/screens/dummy_page.dart';
import 'package:social_media/screens/profile.dart';

import 'form.dart';
import 'home.dart';

class CreateEditProfile extends StatefulWidget {
  final User user;
  final Profile profile;

  CreateEditProfile(this.user, this.profile);

  @override
  _CreateEditProfileState createState() => _CreateEditProfileState();
}

class _CreateEditProfileState extends State<CreateEditProfile> {
  bool _autovalidate = false;
  bool _isInAsyncCall = false;
  final globalKey = GlobalKey<ScaffoldState>();
  double coverImageHeight = 200.0;

  Future<File> file;
  String base64Image;
  File tmpFile;
  String displayTitle = "Create";

  TextEditingController bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //IF it is the edit route
    if (widget.profile != null) {
      displayTitle = "Edit";
      bioController.text = widget.profile.bio;
      print(widget.profile.coverImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.user.displayImageURL);
    return Scaffold(
        key: globalKey,

        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            displayTitle + ' Profile',
          ),
          actions: <Widget>[
            FlatButton(
              textColor: Theme.of(context).accentColor,
              child: Text("SAVE"),
              onPressed: () {
                onSaveClicked();
              },
            )
          ],
        ),
        body: Container(
          height: double.infinity,
          color: Theme.of(context).primaryColor,
          child: ModalProgressHUD(
            inAsyncCall: _isInAsyncCall,
            opacity: 0.5,
            progressIndicator: CircularProgressIndicator(),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      showCoverImage(),
                      Container(
                        alignment: Alignment.bottomCenter,
                        padding: new EdgeInsets.only(
                            top: 3 / 4 * coverImageHeight,
                            right: 10.0,
                            left: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            showDisplayImage(),
                            Row(
                              children: <Widget>[
                                imagePickBtn(Icons.camera_alt, startCamera),
                                imagePickBtn(Icons.photo_album, startGallery)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 12.0),
                        child: Text(widget.user.name,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).primaryTextTheme.title),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 4.0),
                        child: Text(
                          widget.user.email,
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 12.0),
                        child: Text(
                          "Joined on " +
                              widget.user.dateJoined.substring(0, 10),
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: bioField("Bio", bioController),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void onSaveClicked() async {
    // start the modal progress HUD
    setState(() {
      _isInAsyncCall = true;
    });

    FormData formData = new FormData.fromMap({
      'bio': bioController.text,
      "user": {"id": widget.user.id},
      "coverImage":
          tmpFile == null ? "" : await MultipartFile.fromFile(tmpFile.path),
    });

    String saveProfileURL = Constants.BASE_URL + "profile";
    var dio = Dio();
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 5000;
    dio.options.headers['content-Type'] = 'application/json';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dio.options.headers["x-auth-token"] = prefs.getString('token');
    //If successful post
    try {
      Response<Map> response = await dio.post(saveProfileURL, data: formData);
      Map responseBody = response.data;
      print(responseBody);
      Profile profile = Profile.fromJson(responseBody);
      setState(() {
        // stop the modal progress HUD
        _isInAsyncCall = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage("")),
      );
    }
    //If any error is returned
    on DioError catch (e) {
      print("Error");
      handleRequestError(e);
    }
  }

  void handleRequestError(DioError e) {
    var errors;

    if (e.response != null) {
      print(e.response);
      errors = e.response.data;
    } else {
      errors = {
        "errors": [
          {"msg": "Server error"}
        ]
      };
    }
    setState(() {
      // stop the modal progress HUD
      _isInAsyncCall = false;
    });
    final snackBar = SnackBar(content: Text(errors["errors"][0]["msg"]));
    globalKey.currentState.showSnackBar(snackBar);
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

  Widget showCoverImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());

          return Container(
            color: Theme.of(context).primaryColor,
            height: coverImageHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: (Image.file(snapshot.data, fit: BoxFit.fill).image),
                fit: BoxFit.fill,
              ),
            ),
          );
        } else if (snapshot.error != null) {
          return Text('Error selecting image');
        } else {
          if (widget.profile != null) {
            return Container(
              height: coverImageHeight,
              width: double.infinity,
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl: widget.profile.coverImage.replaceAll("uploads", ""),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            );
          } else {
            return Container(
              height: coverImageHeight,
              width: double.infinity,
              color: Colors.black,
            );
          }
        }
      },
    );
  }

  Widget showDisplayImage() {
    return CachedNetworkImage(
      imageUrl: widget.user.displayImageURL.replaceAll("uploads", ""),
      imageBuilder: (context, imageProvider) =>
          CircleAvatar(radius: 50, backgroundImage: imageProvider),
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
