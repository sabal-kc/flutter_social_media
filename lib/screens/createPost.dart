import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/shared_preference_utils.dart';

import 'home.dart';

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  File _file;
  String base64Image;
  File tmpFile;
  String text;
  TextEditingController postController = TextEditingController();
  String tempText;
  bool _isInAsyncCall= false;

  @override
  void initState(){
    super.initState();
    tempText = '';
  }

  void pickImage() async {
    var file  = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _file = file;
    });
  }

  void _createNewPostRequest() async {
    setState(() {
      _isInAsyncCall = true;
    });

    String newText = postController.text;
    File newFile = _file;
    FormData formData;
    if(newFile==null){
      formData = new FormData.fromMap({
        'text': newText,
      });
    }
    else{
      String fileName = newFile.path.split('/').last;
      //Send post to the api
      formData = new FormData.fromMap({
        'text': newText,
        "displayImage": await MultipartFile.fromFile(newFile.path, filename: fileName),
      });
    }

    String url = Constants.BASE_URL + "posts/";
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token");
    var dio = Dio();
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 5000;
    //If successful post
    try {
      Response<Map> response = await dio.post(url, data: formData,options: Options(headers: {"x-auth-token":token}));
      Map responseBody = response.data;
      setState(() {
        // stop the modal progress HUD
        _isInAsyncCall = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
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
    }

  }



  @override
  Widget build(BuildContext context) {
    Widget getBottomRow(){
      return Container(
        padding: EdgeInsets.all(20),
        child:Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.image),
              onPressed: ()=>pickImage(),
            ),
            SizedBox(width: 30,),
            Icon(Icons.gif),
            SizedBox(width: 30,),
            Icon(Icons.poll),
            SizedBox(width: 30,),
            Icon(Icons.location_on)
          ],
        ) ,
      );
    }


    Widget getBody(){
      return Stack(
        children: [
          Container(
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(20),
              child:Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: NetworkImage("https://theofficeanalytics.files.wordpress.com/2017/11/dwight.jpeg?w=1200"),

                            ),
                          ),
                        ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left:10),
                          child: TextFormField(
                            onChanged: (value){
                              setState(() {
                                tempText = value;
                              });
                            },
                            controller: postController,
                            style: TextStyle(color: Colors.white),
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            maxLength: 160,
                            autofocus: true,
                            enabled: true,

                            decoration: InputDecoration(
                              helperStyle: TextStyle(color: Colors.white),
                              hintText: "What's on your mind?",
                              hintStyle: TextStyle(color: Colors.white70),
                              enabled: true,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 0.3,
                                )
                              )

                            ),
                          ),
                        ),
                        _file==null?Container(child: Text ("Still Loading"),):
                            Container(
                              child: SizedBox(
                                height: 100,
                                width: 200,
                                child:Image.file(_file, fit: BoxFit.fitHeight,),
                              ),
                            )

                      ],
                    ),
                  ),
                ],
              )
          ),

          Positioned(
            left:20,
            right:0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
            child:getBottomRow()
          )
      ]);
    }


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(""),
        actions: <Widget>[
          RaisedButton(

            child: Text ("Post",style: TextStyle(color: Colors.white),),
            color: Theme.of(context).primaryColor,
            onPressed: _file==null && tempText==''?null:()=>_createNewPostRequest(),
          )
        ],
      ),
      body: ModalProgressHUD(
          inAsyncCall: _isInAsyncCall,
          opacity: 0.5,
          progressIndicator: CircularProgressIndicator(),
          child: getBody(),
      )
    );
  }
}
