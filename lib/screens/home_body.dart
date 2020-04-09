import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/model/Post.dart';
import 'package:social_media/routes.dart';


class TwitterBody extends StatefulWidget {
  @override
  _TwitterBodyState createState() => _TwitterBodyState();
}

class _TwitterBodyState extends State<TwitterBody> {

  Future<List> futureTweets;
  var token;
    @override
    void initState(){
      super.initState();
    }

    // ignore: missing_return
    Future<List> getPosts(token) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var token = preferences.getString("token");
      var dio = new Dio();
      String url = Constants.BASE_URL + "posts/";

      try{
        Response response = await dio.get(url,options: Options(headers: {"x-auth-token":token}));
        return Tweet.ListfromJson(response.data);

      }
      catch(error){
            print("Error$error");
      }

    }

    void likePostClick(var postId)async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var token = preferences.getString("token");

      String url = Constants.BASE_URL + "posts/like/" + postId;
      var dio = new Dio ();
      try {
        Response response = await dio.put(url,options: Options(headers: {"x-auth-token":token}));
        setState(() {

        });
      }
      catch(error){
        print("Error$error");
      }
    }

  Widget getList(snapshotData) {
      var imageUrl = Constants.BASE_URL.replaceAll(RegExp('api'), '');
      var defaultImageUrl = imageUrl + 'default.jpg';
    return ListView.builder(
      itemCount: snapshotData.length,
      itemBuilder: (context, index) =>
          InkWell(
            onTap: ()=>Navigator.pushNamed(context, ExpandPostRoute, arguments: snapshotData[index].id),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: NetworkImage(snapshotData[index].displayImage==null?defaultImageUrl:imageUrl+snapshotData[index].displayImage.replaceAll(RegExp("\\\\"),'')
                              .replaceAll(RegExp('uploads'),''),

                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      snapshotData[index].name,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        snapshotData[index].user,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 0.0, bottom: 8.0),
                              child: Text(
                                snapshotData[index].text,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              child: snapshotData[index].image == null
                                  ? null
                                  : Container(
                                      width: double.infinity,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                              imageUrl+snapshotData[index].image.replaceAll(RegExp("\\\\"),'')
                                                  .replaceAll(RegExp('uploads'),'')
                                          )),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 15.0,
                                        width: 18.0,
                                        child: IconButton(
                                          padding: new EdgeInsets.all(0.0),
                                          icon: Icon(
                                            Icons.chat_bubble_outline,
                                            size: 18.0,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {},
                                        ),
                                      ),
                                      SizedBox(
                                          height: 15.0,
                                          width: 18.0,
                                          child: Text(
                                            snapshotData[index].comments.length.toString(),
                                            style: TextStyle(color: Colors.grey),
                                          )),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 15.0,
                                        width: 18.0,
                                        child: IconButton(
                                          padding: new EdgeInsets.all(0.0),
                                          icon: Icon(
                                            Icons.replay,
                                            size: 18.0,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {},
                                        ),
                                      ),
                                      SizedBox(
                                          height: 15.0,
                                          width: 18.0,
                                          child: Text(
                                            '0',
                                            style: TextStyle(color: Colors.grey),
                                          )),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 15.0,
                                        width: 18.0,
                                        child: IconButton(
                                          padding: new EdgeInsets.all(0.0),
                                          icon: Icon(
                                            Icons.favorite_border,
                                            size: 18.0,
                                            color: Colors.grey,
                                          ),
                                          onPressed: ()=>likePostClick(snapshotData[index].id),
                                        ),
                                      ),
                                      SizedBox(
                                          height: 15.0,
                                          width: 18.0,
                                          child: Text(
                                            snapshotData[index].likes.length.toString(),
                                            style: TextStyle(color: Colors.grey),
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                    width: 10.0,
                                    child: IconButton(
                                      padding: new EdgeInsets.all(0.0),
                                      icon: Icon(
                                        Icons.share,
                                        size: 18.0,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 18),

                  child: Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: 0.5,
                  ),
                )
              ],
            ),
          ),
    );
  }


  @override
  Widget build(BuildContext context) {
    futureTweets= getPosts(token);
    return Container(
      color: Theme.of(context).primaryColor,
      child: FutureBuilder(
          future: futureTweets,
          builder: (context, snapshot){

          if(snapshot.hasData){
            return getList(snapshot.data);
          }
          else if(snapshot.hasError)
            return Text("Error");
          else
            return Center(
              child: CircularProgressIndicator(),
            );
        }
      ),
    );
  }
}