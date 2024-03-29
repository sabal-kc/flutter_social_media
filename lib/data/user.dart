import '../constants.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String displayImageURL;
  final String dateJoined;

  User(this.id, this.name, this.email, this.displayImageURL, this.dateJoined);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['_id'],
        email = json['email'],
        displayImageURL = Constants.IMAGE_URL +
            json['displayImage'].replaceAll(r'\', r'/'),
        dateJoined = json['date'];

  Map<String, dynamic> toJson() => {'name': this.name, 'email': this.email};
}
