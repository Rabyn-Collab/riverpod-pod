

class Like{
  final int likes;
  final List<String> users;

  Like({
    required this.users,
    required this.likes
});
  factory Like.fromJson(Map<String, dynamic> json){
    return Like(
       likes: json['likes'],
      users: (json['users'] as List).map((e) => e as String).toList()
    );
  }
}


class Comment{
  final String username;
  final String userImage;
  final String comment;

  Comment({
    required this.comment,
    required this.userImage,
    required this.username
});

  factory Comment.fromJson(Map<String, dynamic> json){
    return Comment(
        comment: json['comment'],
        userImage: json['userImage'],
        username: json['username']
    );
  }


  Map<String, dynamic> toMap(){
    return {
      'comment': this.comment,
      'userImage': this.userImage,
      'username': this.username
    };
  }


}


class Post{
  final String title;
  final String detail;
  final String imageUrl;
  final String imageId;
  final String userId;
  final String postId;
  final List<Comment> comments;
  final Like like;

  Post({
    required this.detail,
    required this.imageId,
    required this.imageUrl,
    required this.postId,
    required this.title,
    required this.userId,
    required this.comments,
    required this.like
});
}