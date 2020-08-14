import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media/data/profile.dart';
import 'package:social_media/data/user.dart';
import 'package:social_media/screens/profile.dart';

class UserSearch extends SearchDelegate<Profile> {
  List<Profile> profiles;
  UserSearch(this.profiles);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
    // final ThemeData theme = Theme.of(context);
    // return theme.copyWith(
    //     primaryColor: theme.primaryColor,
    //     primaryIconTheme: theme.primaryIconTheme,
    //     primaryColorBrightness: theme.primaryColorBrightness,
    //     primaryTextTheme: theme.primaryTextTheme,
    //     // primaryColor: Colors.white,
    //     textTheme: theme.textTheme.copyWith(
    //         title: theme.textTheme.title.copyWith(color: Colors.white)));
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () => close(context, null));
  }

  String currentUserID;

  @override
  Widget buildResults(BuildContext context) {
    return ProfilePage(
      currentUserID,
      showAppBar: false,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Profile> suggestionList = query.isEmpty
        ? profiles
        : profiles
            .where((profile) => profile.user.name.toLowerCase().contains(query))
            .toList();
    return ListView.builder(
      itemBuilder: (context, index) {
        Profile profile = suggestionList[index];
        String displayName = profile.user.name;
        return ListTile(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => ProfilePage(profile.user.id)));
              currentUserID = profile.user.id;
              showResults(context);
            },
            title: RichText(
              text: TextSpan(
                text: displayName,
                style: TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.normal),
              ),
            ));
      },
      itemCount: suggestionList.length,
    );
  }
}
