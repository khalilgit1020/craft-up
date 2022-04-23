class CommentModel{
  String? comment;
  String? userId;
  String? date;
  String? commentId;
  String? postId;

  CommentModel({
    this.comment,
    this.userId,
    this.date,
    this.commentId,
    this.postId,
  });


  CommentModel.fromJson(Map <String,dynamic> json){
    comment = json['comment']!;
    userId = json['userId']!;
    date = json['date']!;
    commentId = json['commentId']!;
    postId = json['postId']!;
  }


  Map <String,dynamic> toMap(){
    return {
      'comment':comment,
      'userId':userId,
      'date':date,
      'commentId':commentId,
      'postId':postId,
    };
  }


}
