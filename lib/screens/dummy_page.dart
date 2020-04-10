import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media/data/profile.dart';
import 'package:social_media/data/user.dart';
import 'package:social_media/routes.dart';

class Dummy extends StatelessWidget {
  final User user;
  final Profile profile;
  Dummy(this.user, this.profile);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dummy page',
        ),
      ),
      body: Column(
        children: <Widget>[
          Text("Name: " + this.user.name + "\n\n"),
          Text("Disp image url: " + this.user.displayImageURL + "\n\n"),
          Text("Date joined: " + this.user.dateJoined + "\n\n"),
          Text("Bio: " + this.profile.bio + "\n\n"),
          Text("Cover image url: " + this.profile.coverImage + "\n\n"),
          RaisedButton(
              child: Text("Edit profile"),
              onPressed: () {
                Navigator.pushNamed(context, CreateProfileRoute,arguments:{"user":user,"profile":profile});
              }),
        ],
      ),
    );
  }
}
