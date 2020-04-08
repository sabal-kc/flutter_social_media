import '../constants.dart';

class Profile {
  final String bio;
  final String coverImage;

  Profile(this.bio, this.coverImage);

  Profile.fromJson(Map<String, dynamic> json)
      : bio = json['bio'],
        coverImage = Constants.BASE_URL_IMAGE +
            json['coverImage'].replaceAll(r'\', r'/');

  Map<String, dynamic> toJson() => {
        'bio': bio,
        'coverImage': coverImage,
      };
}
