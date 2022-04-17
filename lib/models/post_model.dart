class PostModel{
  String? name;
  String? uId;
  String? image;
  String? dateTime;
  String? text;
  String? salary;
  String? location;
  String? jobName;
  String? postId;

  PostModel({
    this.name,
    this.uId,
    this.image,
    this.dateTime,
    this.text,
    this.salary,
    this.location,
    this.jobName,
    this.postId,

  });


  PostModel.fromJson(Map <String,dynamic> json){
    name = json['name']!;
    uId = json['uId']!;
    image = json['image']!;
    dateTime = json['dateTime']!;
    text = json['text']!;
    salary = json['salary']!;
    location = json['location']!;
    jobName = json['jobName']!;
    postId = json['postId']!;
  }


  Map <String,dynamic> toMap(){
    return {
      'name':name,
      'uId':uId,
      'image':image,
      'dateTime':dateTime,
      'text': text,
      'salary':salary,
      'location':location,
      'jobName':jobName,
      'postId':postId,
    };
  }


}
