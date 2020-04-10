import 'package:flutter/material.dart';
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
      Map arguments = settings.arguments;
      var user = arguments['user'];
      var profile = arguments ['pofile'];
      return MaterialPageRoute(builder: (context) => HomePage(user:user));
    case LogInRoute:
      return MaterialPageRoute(builder:(context)=>LoginPage());
    case SignUpRoute:
      return MaterialPageRoute(builder:(context)=>SignupPage());
    case CreatePostRoute:
      var arguments = settings.arguments;
      return MaterialPageRoute(builder: (context)=>CreatePostPage());
    case ExpandPostRoute:
      var arguments = settings.arguments;
      return MaterialPageRoute(builder: (context)=>ExpandPostPage(arguments:arguments));
    default:
      return MaterialPageRoute(builder: (context) => HomePage());
  }

}
