class Tweet {
  String name;
  String user;
  String text;
  List likes;
  List comments;
  String displayImage;
  String image;
  String id;

  Tweet(
      {this.name,
      this.text,
      this.likes,
      this.comments,
      this.displayImage,
      this.user,
      this.image,
      this.id});

  static Tweet fromJson(var json) {
    Tweet post = Tweet(
        name: json["name"],
        user: json["user"],
        text: json["text"],
        likes: json["likes"],
        comments: json["comments"],
        displayImage: json["displayImage"],
        image: json["image"],
        id: json["_id"]);
    return post;
  }

  static List ListfromJson(var json) {
    List<Tweet> tweets = [];
    json.forEach((item) {
      Tweet employee = Tweet(
          name: item["name"],
          user: item["user"],
          text: item["text"],
          likes: item["likes"],
          comments: item["comments"],
          displayImage: item["displayImage"],
          image: item["image"],
          id: item["_id"]);
      tweets.add(employee);
    });
    return tweets;
  }
}
