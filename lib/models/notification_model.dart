class NotificationModel{
  String? image;
  String? name;
  String? userId;
  String? date;
  String? postId;

  NotificationModel({
    this.image,
    this.userId,
    this.name,
    this.postId,
    this.date,
  });


  NotificationModel.fromJson(Map <String,dynamic> json){
    image = json['image']!;
    postId = json['postId']!;
    name = json['name']!;
    userId = json['userId']!;
    date = json['date']!;
  }


  Map <String,dynamic> toMap(){
    return {
      'name':name,
      'image':image,
      'postId':postId,
      'userId':userId,
      'date':date,
    };
  }


}
