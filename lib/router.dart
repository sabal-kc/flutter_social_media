
import 'package:flutter/material.dart';
import 'package:social_media/screens/create_edit_profile.dart';
import 'screens/login.dart';
import 'package:social_media/screens/signup.dart';
import 'package:social_media/screens/home.dart';
import 'package:social_media/screens/createPost.dart';
import 'package:social_media/screens/expandPost.dart';
import 'routes.dart';

import 'package:flutter/services.dart';


Route<dynamic> generateRoute (RouteSettings settings) {
  switch(settings.name){
    case HomePageRoute:
      //Map arguments = settings.arguments;
//      var user = arguments['user'];
//      var profile = arguments ['pofile'];
      return MaterialPageRoute(builder: (context) => HomePage());
    case LogInRoute:
      return MaterialPageRoute(builder:(context)=>LoginPage());
    case SignUpRoute:
      return MaterialPageRoute(builder:(context)=>SignupPage());
    case CreatePostRoute:
      var arguments = settings.arguments;
      return MaterialPageRoute(builder: (context)=>CreatePostPage(displayImageUrl: arguments,));
    case ExpandPostRoute:
      Map arguments = settings.arguments;
      return MaterialPageRoute(builder: (context)=>ExpandPostPage(
          postID:arguments['id'], isLiked:arguments['isLiked'],
          userID:arguments["userID"]));
    case CreateProfileRoute:
      Map arguments = settings.arguments;
      return MaterialPageRoute(builder: (context)=>CreateEditProfile(user: arguments["user"],profile: arguments["profile"]));
    default:
      return MaterialPageRoute(builder: (context) => HomePage());
  }

}
