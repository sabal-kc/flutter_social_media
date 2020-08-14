import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/routes.dart';
import 'package:social_media/screens/home_body.dart';
import 'package:social_media/screens/profile.dart';
import 'package:social_media/data/user.dart';
import 'package:social_media/theme.dart';
import '../constants.dart';

class HomePage extends StatelessWidget {

  Future<User> getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token");
    var dio = Dio();
    var url = Constants.BASE_URL + "auth/";
    Response response =
        await dio.get(url, options: Options(headers: {"x-auth-token": token}));
    User user = User.fromJson(response.data);
    return user;
  }

  Future<String> getUserID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("user_id");
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return Scaffold(
              appBar: AppBar(
                leading: Builder(
                    builder: (context) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () => Scaffold.of(context).openDrawer(),
                            child: Container(
                              width: 60.0,
                              height: 60.0,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fitHeight,
                                  image: NetworkImage(
                                      "${snapshot.data.displayImageURL.replaceAll("uploads", "")}"),
                                ),
                              ),
                            ),
                          ),
                        )),
                backgroundColor: Theme.of(context).primaryColorDark,
                title: Text('Home'),
              ),
              //MainBody

              body: FutureBuilder(
                  future: getUserID(),
                  builder: (context, snapshot) =>
                      TwitterBody(getPostsHandler(), snapshot.data)),

              drawer: Drawer(
                child: Container(
                    color: Theme.of(context).primaryColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 40.0, 0.0, 8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfilePage("")));
                            },
                            child: Container(
                              width: 75.0,
                              height: 75.0,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fitHeight,
                                    image: NetworkImage(
                                        "${snapshot.data.displayImageURL.replaceAll("uploads", "")}")),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                snapshot.data.name,
                                style: Theme.of(context).primaryTextTheme.title
                                    .merge(TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Icon(Icons.arrow_drop_down)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          child: Text(
                            "@${snapshot.data.name.toLowerCase().replaceAll(" ", "_")}",
                            style: TextStyle(
                                color: Theme.of(context).disabledColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          color: Theme.of(context).disabledColor,
                          height: 0.5,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfilePage("")));
                                  },
                                  child: ListTile(
                                    title: Text(
                                      'Profile',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .body1,
                                    ),
                                    leading: Icon(
                                      Icons.person,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Lists',
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .body1,
                                  ),
                                  leading: Icon(
                                    Icons.list,
                                    color: Theme.of(context).disabledColor,
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Bookmarks',
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .body1,
                                  ),
                                  leading: Icon(
                                    Icons.bookmark_border,
                                    color: Theme.of(context).disabledColor,
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Moments',
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .body1,
                                  ),
                                  leading: Icon(
                                    Icons.apps,
                                    color: Theme.of(context).disabledColor,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  color: Theme.of(context).disabledColor,
                                  height: 0.5,
                                ),
                                ListTile(
                                  title: Text(
                                    'Settings and Privacy',
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .body1,
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Help center',
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .body1,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          color: Theme.of(context).disabledColor,
                          height: 0.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SizedBox(
                                height: 30.0,
                                width: 30.0,
                                child: IconButton(
                                  padding: new EdgeInsets.all(0.0),
                                  icon: Icon(
                                    Icons.wb_incandescent,
                                    size: 32.0,
                                  ),
                                  onPressed: () =>
                                      _themeChanger.setTheme("light"),
                                ),
                              ),
                              SizedBox(
                                height: 30.0,
                                width: 30.0,
                                child: IconButton(
                                  padding: new EdgeInsets.all(0.0),
                                  icon: Icon(
                                    Icons.lightbulb_outline,
                                    size: 32.0,
                                  ),
                                  onPressed: () =>
                                      _themeChanger.setTheme("dark"),
                                ),
                              ),
                              SizedBox(
                                height: 30.0,
                                width: 30.0,
                                child: IconButton(
                                  padding: new EdgeInsets.all(0.0),
                                  icon: Icon(
                                    Icons.camera_alt,
                                    size: 32.0,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        )

                      ],
                    )),
              ),

              floatingActionButton: FloatingActionButton(
                onPressed: () => Navigator.pushNamed(context, CreatePostRoute,
                    arguments: snapshot.data.displayImageURL),
                child: Icon(Icons.edit),
                backgroundColor: Theme.of(context).accentColor,
              ),

              bottomNavigationBar: Container(
                height: 50.0,
                color: Theme.of(context).primaryColorDark,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.home),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: null,
                    ),
                    IconButton(
                        icon: Icon(Icons.notifications), onPressed: null),
                    IconButton(
                      icon: Icon(Icons.mail),
                      onPressed: null,
                    ),
                  ],
                ),
              ),
            );
          else
            return Container();
        });
  }

  String getPostsHandler() {
    String url = Constants.BASE_URL + "posts/";
    return url;
  }
}
