import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media/data/profile.dart';
import 'package:social_media/model/Post.dart';
import 'package:social_media/routes.dart';

import '../constants.dart';
import 'create_edit_profile.dart';
import 'home_body.dart';

class ProfilePage extends StatelessWidget {
  final String userId;
  bool _isMyProfile = false;
  Profile profile;
  bool showAppBar;

  ProfilePage(this.userId, {this.showAppBar = true});

  Future<Profile> getData() async {
    print("from profile:$userId");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token");

    var dio = new Dio();
    var id;
    if (this.userId == "") {
      _isMyProfile = true;
      id = preferences.getString("user_id");
    } else
      id = this.userId;
    String url = Constants.BASE_URL + "profile/user/" + id;
    print("From profile.dart:User id: " + id);
    print(url);
    try {
      Response response = await dio.get(url,
          options: Options(headers: {"x-auth-token": token}));
      print("From profile.dart ${response.data}");
      profile = Profile.fromJson(response.data);
      return profile;
    } catch (error) {
      print("Error$error");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: this.showAppBar == true
            ? AppBar(
                title: Text('Profile'),
              )
            : null,
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor
          ),
          child: FutureBuilder<Profile>(
              future: getData(),
              builder: (context, AsyncSnapshot<Profile> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      upperProfileArea(
                          Theme.of(context).primaryColor, snapshot.data, context),
                      FutureBuilder(
                          future: getPostsHandler(),
                          builder: (context, snapshot1) {
                            if (snapshot1.hasData)
                              return TwitterBody(
                                  snapshot1.data, snapshot.data.user.id
                              );


                            else
                              return Container(
                                height:1000
                              );
                          }),
                    ],
                  );
                }
                return Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Theme.of(context).primaryColor,
                    child: Center(child: CircularProgressIndicator()));
              }),
        ));
  }

  // ignore: missing_return
  Future<String> getPostsHandler() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var id;
    if (this.userId == "")
      id = preferences.getString("user_id");
    else
      id = this.userId;
    print("User id: " + id);

    String url = Constants.BASE_URL + "posts/user/" + id;
    return url;
  }

  onEditProfileClicked(BuildContext context) async {
    Navigator.pushNamed(context, CreateProfileRoute,
        arguments: {"user": profile.user, "profile": profile});
  }

  Widget upperProfileArea(Color color, Profile profile, BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(bottom: 60),
      color: color,
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: NetworkImage(profile.coverImage.replaceAll("uploads", "")),
            )),
          ),
          Visibility(
            visible: _isMyProfile,
            child: Positioned(
              right: 0,
              top: 190,
              child: FlatButton(
                onPressed: () {
                  onEditProfileClicked(context);
                },
                child: new Text(
                  'Edit Profile',
                  style: new TextStyle(
                      color: (Color(0xff1CA1F1)), fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 125,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      decoration:
                          ShapeDecoration(shape: CircleBorder(), color: color),
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: DecoratedBox(
                          decoration: ShapeDecoration(
                            shape: CircleBorder(),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(profile.user.displayImageURL
                                    .replaceAll("uploads", ""))),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(profile.user.name,
                    style: Theme.of(context).primaryTextTheme.title),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  profile.user.email,
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 12.0),
                child: Text(
                    "Joined on " + profile.user.dateJoined.substring(0, 10),
                    style: TextStyle(color: Theme.of(context).disabledColor)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  profile.bio,
                  style: Theme.of(context).primaryTextTheme.body1,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 8.0, top: 24, bottom: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Theme.of(context).disabledColor,
                            width: 0.4))),
                child: Text(
                  'Recent Posts',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
