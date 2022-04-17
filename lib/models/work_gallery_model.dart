class WorkGalleryModel{
  String? imageUrl;

  WorkGalleryModel({
    this.imageUrl,
  });


  WorkGalleryModel.fromJson(Map <String,dynamic> json){
    imageUrl = json['imageUrl']!;
  }


  Map <String,dynamic> toMap(){
    return {
      'imageUrl':imageUrl,
    };
  }


}
