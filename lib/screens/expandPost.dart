import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/model/Post.dart';
import 'package:social_media/routes.dart';
import 'package:dio/dio.dart';

class ExpandPostPage extends StatefulWidget {
  final String arguments;

  ExpandPostPage({this.arguments});

  @override
  _ExpandPostPageState createState() => _ExpandPostPageState();
}

class _ExpandPostPageState extends State<ExpandPostPage> {
  Future<Tweet> futureTweet;
  String tempComment = '';
  TextEditingController commentController = TextEditingController();
  bool _isInAsyncCall = false;

  // ignore: missing_return
  Future<Tweet> getPost() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token");
    var dio = new Dio();
    String url = Constants.BASE_URL + "posts/${widget.arguments}";

    try {
      Response response = await dio.get(url,
          options: Options(headers: {"x-auth-token": token}));
      return Tweet.fromJson(response.data);
    } catch (error) {
      print("Error$error");
    }
  }

  @override
  Widget build(BuildContext context) {
    futureTweet = getPost();

    //***************************************************************************
    //************************NAME SECTION***************************************
    //***************************************************************************

    Widget nameSection(String name, String displayImage, String user) {
      var defaultImageUrl = Constants.IMAGE_URL + 'default.jpg';
      return Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(width: 0.3, color: Colors.white))),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 60.0,
                height: 60.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: NetworkImage(
                      displayImage == null
                          ? defaultImageUrl
                          : Constants.IMAGE_URL +
                              displayImage
                                  .replaceAll(RegExp("\\\\"), '')
                                  .replaceAll(RegExp('uploads'), ''),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: Theme.of(context).primaryTextTheme.body1,
                  ),
                  Text(
                    user,
                    style: TextStyle(color: Theme.of(context).disabledColor),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }

    //***************************************************************************
    //************************TIME DATE SECTION***************************************
    //***************************************************************************

    Widget timeDateSection = Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 0.3, color: Colors.white70))),
      child: Row(
        children: <Widget>[
          Text(
            "12:45",
            style: TextStyle(color: Theme.of(context).disabledColor),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "08 Apr 20",
            style: TextStyle(color: Theme.of(context).disabledColor),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "Nepwer For Android",
            style: TextStyle(color: Colors.blue),
          ),
        ],
      ),
    );

    //***************************************************************************
    //************************POSTINFO SECTION***************************************
    //***************************************************************************


    Widget postInfoSection(List likes, List comments) => Container(
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 0.3, color: Colors.white70))),
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Text(
              "${comments.length}",
              style: Theme.of(context).primaryTextTheme.body1,
            ),
            Text(" Comments", style:TextStyle(color:Theme.of(context).disabledColor)),
            SizedBox(
              width: 15,
            ),
            Text(
              "${likes.length}",
              style: Theme.of(context).primaryTextTheme.body1,
            ),
            Text(" Likes", style: TextStyle(color: Theme.of(context).disabledColor))
          ],
        ));



    //************************ICON SECTION***************************************

    Widget iconSection = Container(
      padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 0.3, color: Colors.white70))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.comment),
          Icon(Icons.favorite_border),
          Icon(Icons.repeat),
          Icon(Icons.share)
        ],
      ),
    );


    //***************************************************************************
    //************************POST SECTION***************************************
    //***************************************************************************


    Widget postSection(String text) => Text(text,
        style:Theme.of(context).primaryTextTheme.body1.merge(TextStyle(
          fontSize: 18.0,
          height: 1.5,
        )));

    //***************************************************************************
    //************************IMAGE SECTION***************************************
    //***************************************************************************

    Widget imageSection (String imageUrl){
      var url = Constants.IMAGE_URL+imageUrl.replaceAll("uploads", "");
      return Container(
        padding: EdgeInsets.all(10),
        child:SizedBox(
          height: 250,
          width:200,
          child: Image(
            image: NetworkImage(url)
          ),
        )

        );

    }



    //***************************************************************************
    //************************COMMENTS SECTION***************************************
    //***************************************************************************



    List<Widget> commentSection(List comments) {
      List<Widget> commentWidgets = [];
      var defaultImageUrl = Constants.IMAGE_URL + 'default.jpg';
      for (int i = 0; i < comments.length; i++) {
        commentWidgets.add(Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 0.3, color: Colors.white70))),
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: NetworkImage(defaultImageUrl),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(comments[i]["name"],
                            style: Theme.of(context).primaryTextTheme.body1,),
                        Text("Replying to @dwight_k_schrutte",
                            style: TextStyle(color: Theme.of(context).disabledColor)),
                        SizedBox(height: 8),
                        Text(comments[i]["text"],
                            style:Theme.of(context).primaryTextTheme.body1.merge(
                                TextStyle(fontSize: 15,
                                    height: 1.5,))),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.favorite_border, size: 20),
                              SizedBox(width: 40),
                              Icon(Icons.share, size: 20),
                              SizedBox(width: 40),
                              Text("Report",
                                  style: TextStyle(color: Colors.blue))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )));
      }
      return commentWidgets;
    }

    //***************************************************************************
    //************************HANDLER SECTION***************************************
    //***************************************************************************


    void addCommentClickHandler() async {
      setState(() {
        _isInAsyncCall = true;
      });

      String url = Constants.BASE_URL + "posts/comment/";
      String id = widget.arguments;
      String text = commentController.text;
      print(text);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var token = preferences.getString('token');

      FormData formData = new FormData.fromMap({
        'text': text,
      });
      Map<String, dynamic> commentData = {"text": text};

      var dio = Dio();
      dio.options.connectTimeout = 10000;
      dio.options.receiveTimeout = 5000;
      //If successful post
      try {
        var response = await dio.post(url + id,
            data: commentData,
            options: Options(headers: {
              "x-auth-token": token,
              'Content-Type': 'application/json'
            }));
        print(response);
        setState(() {
          // stop the modal progress HUD
          commentController.text = '';
          _isInAsyncCall = false;
        });
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
          print(">> ${e.request}");
          print("<<<${e.message}");
        }
        setState(() {
          // stop the modal progress HUD
          _isInAsyncCall = false;
        });
      }
    }

    Future<void> _refreshPage()async{
      setState(() {

      });
    }

    //***************************************************************************
    //************************MAIN SECTION***************************************
    //***************************************************************************

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Post"),
        actions: <Widget>[
          tempComment == ''
              ? Container()
              : Container(
                  padding: EdgeInsets.all(10),
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () => addCommentClickHandler(),
                    child: Text(
                      "Comment",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: ModalProgressHUD(
          inAsyncCall: _isInAsyncCall,
          opacity: 0.5,
          progressIndicator: CircularProgressIndicator(),
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Stack(
                children: [
                  FutureBuilder(
                      future: futureTweet,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView(
                            children: <Widget>[
                              nameSection(snapshot.data.name,
                                  snapshot.data.displayImage, snapshot.data.user),
                              postSection(snapshot.data.text),
                              snapshot.data.image==null?Container():
                              imageSection(snapshot.data.image),
                              timeDateSection,
                              postInfoSection(
                                  snapshot.data.likes, snapshot.data.comments),
                              iconSection,
                              Column(
                                children: commentSection(snapshot.data.comments),
                              ),
                              SizedBox(height: 70,)

                            ],
                          );
                        } else if (snapshot.hasError)
                          return Text("Error");
                        else
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                      }),



              Positioned(
                  left: 10,
                  right: 0,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          tempComment = value;
                        });
                      },
                      controller: commentController,
                      maxLines: null,
                      maxLength: 160,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(color: Colors.white),
                      enabled: true,
                      decoration: InputDecoration(
                          enabled: true,
                          hintText: "Add Your Comment",
                          hintStyle: TextStyle(color: Colors.white),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                    ),
                  ))
            ]),
          ),
        ),
      ),
    );
  }
}
