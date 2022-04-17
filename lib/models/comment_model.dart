class CommentModel{
  String? comment;
  String? userId;
  String? date;
  String? commentId;

  CommentModel({
    this.comment,
    this.userId,
    this.date,
    this.commentId,
  });


  CommentModel.fromJson(Map <String,dynamic> json){
    comment = json['comment']!;
    userId = json['userId']!;
    date = json['date']!;
    commentId = json['commentId']!;
  }


  Map <String,dynamic> toMap(){
    return {
      'comment':comment,
      'userId':userId,
      'date':date,
      'commentId':commentId,
    };
  }


}
