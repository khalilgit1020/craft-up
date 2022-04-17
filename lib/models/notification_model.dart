class NotificationModel{
  String? image;
  String? name;
  String? userId;
  String? date;
  String? postId;
  String? commentId;

  NotificationModel({
    this.image,
    this.userId,
    this.name,
    this.postId,
    this.commentId,
    this.date,
  });


  NotificationModel.fromJson(Map <String,dynamic> json){
    image = json['image']!;
    postId = json['postId']!;
    name = json['name']!;
    userId = json['userId']!;
    date = json['date']!;
    commentId = json['commentId']!;
  }


  Map <String,dynamic> toMap(){
    return {
      'name':name,
      'image':image,
      'postId':postId,
      'userId':userId,
      'date':date,
      'commentId':commentId,
    };
  }


}
