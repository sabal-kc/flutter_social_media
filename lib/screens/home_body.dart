import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/model/Post.dart';
import 'package:social_media/routes.dart';

class TwitterBody extends StatefulWidget {
  final String url;
  final String userID;

  TwitterBody(this.url, this.userID);

  @override
  _TwitterBodyState createState() => _TwitterBodyState();
}

class _TwitterBodyState extends State<TwitterBody> {
  //Future<List> futureTweets;

  @override
  void initState() {
    super.initState();

  }

  void likePostClick(var postId, bool isLiked) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token");
    String url;
    if (!isLiked)
      url = Constants.BASE_URL + "posts/like/" + postId;
    else
      url = Constants.BASE_URL + "posts/unlike/" + postId;
    var dio = new Dio();
    try {
      Response response = await dio.put(url,
          options: Options(headers: {"x-auth-token": token}));
      setState(() {});
    } catch (e) {
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
    }
  }

  Future<List> _getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token");
    var dio = Dio();

    try {
      Response response = await dio.get(widget.url,
          options: Options(headers: {"x-auth-token": token}));
      return Tweet.ListfromJson(response.data);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Widget getList(snapshotData) {
    var imageUrl = Constants.BASE_URL.replaceAll(RegExp('api'), '');
    var defaultImageUrl = imageUrl + 'default.jpg';
    return ListView.builder(
        itemCount: snapshotData.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          bool isLiked = false;
          snapshotData[index].likes.forEach((item) {
            if (item["user"] == widget.userID) isLiked = true;
          });
          return InkWell(
            onTap: () =>
                Navigator.pushNamed(context, ExpandPostRoute, arguments: {
              'id': snapshotData[index].id,
              'isLiked': isLiked,
              'userID': snapshotData[index].user
            }),
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
                            image: NetworkImage(
                              snapshotData[index].displayImage == null
                                  ? defaultImageUrl
                                  : imageUrl +
                                      snapshotData[index]
                                          .displayImage
                                          .replaceAll(RegExp("\\\\"), '')
                                          .replaceAll(RegExp('uploads'), ''),
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
                                    Text(snapshotData[index].name,
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .body1
                                            .merge(TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        "@${snapshotData[index].name.replaceAll(" ", "_").toLowerCase()}",
                                        style: TextStyle(
                                          color:
                                              Theme.of(context).disabledColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Theme.of(context).disabledColor,
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 0.0, bottom: 8.0),
                              child: Text(
                                snapshotData[index].text,
                                style: Theme.of(context).primaryTextTheme.body1,
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
                                          child: Image.network(imageUrl +
                                              snapshotData[index]
                                                  .image
                                                  .replaceAll(
                                                      RegExp("\\\\"), '')
                                                  .replaceAll(
                                                      RegExp('uploads'), ''))),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                            color:
                                                Theme.of(context).disabledColor,
                                          ),
                                          onPressed: () {},
                                        ),
                                      ),
                                      SizedBox(
                                          height: 15.0,
                                          width: 18.0,
                                          child: Text(
                                            snapshotData[index]
                                                .comments
                                                .length
                                                .toString(),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .disabledColor),
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
                                          icon: Transform.rotate(
                                            angle: 22 / 14,
                                            child: Icon(
                                              Icons.repeat,
                                              size: 18.0,
                                              color: Theme.of(context)
                                                  .disabledColor,
                                            ),
                                          ),
                                          onPressed: () {},
                                        ),
                                      ),
                                      SizedBox(
                                          height: 15.0,
                                          width: 18.0,
                                          child: Text(
                                            '0',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .disabledColor),
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
                                            isLiked
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            size: 18.0,
                                            color:
                                                Theme.of(context).disabledColor,
                                          ),
                                          onPressed: () => likePostClick(
                                              snapshotData[index].id, isLiked),
                                        ),
                                      ),
                                      SizedBox(
                                          height: 15.0,
                                          width: 18.0,
                                          child: Text(
                                            snapshotData[index]
                                                .likes
                                                .length
                                                .toString(),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .disabledColor),
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
                                        color: Theme.of(context).disabledColor,
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
                    color: Theme.of(context).disabledColor,
                    height: 0.5,
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<void> _refreshPost() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    

    return Container(
      color: Theme.of(context).primaryColor,
      child: RefreshIndicator(
        // ignore: missing_return
        onRefresh: _refreshPost,
        child: FutureBuilder(
            future: _getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return getList(snapshot.data);
              } else if (snapshot.hasError)
                return Text("Error");
              else
                return Center(
                  child: CircularProgressIndicator(),
                );
            }),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
