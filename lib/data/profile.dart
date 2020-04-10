import 'package:social_media/data/user.dart';

import '../constants.dart';

class Profile {
  final String bio;
  final String coverImage;
  final User user;

  Profile(this.bio, this.coverImage, this.user);

  Profile.fromJson(Map<String, dynamic> json)
      : bio = json['bio'],
        coverImage =
            Constants.IMAGE_URL + json['coverImage'].replaceAll(r'\', r'/'),
        user = (json["user"] is Map<String, dynamic>)
            ? User.fromJson(json["user"])
            : null;

  Map<String, dynamic> toJson() => {
        'bio': bio,
        'coverImage': coverImage,
      };
}
