class CraftUserModel{
  late String? name;
  late String? email;
  late String? phone;
  late String? uId;
  late String? image;
  late String? address;
  late String? craftType;
  late bool? userType;

  CraftUserModel({
    this.name,
    this.email,
    this.phone,
    this.uId,
    this.image,
    this.address,
    this.craftType,
    this.userType,
  });


  CraftUserModel.fromJson(Map <String,dynamic> json){
    name = json['name']!;
    email = json['email']!;
    phone = json['phone']!;
    uId = json['uId']!;
    address = json['address']!;
    image = json['image']!;
    craftType = json['craftType']!;
    userType = json['userType']!;
  }


  Map <String,dynamic> toMap(){
    return {
      'name':name,
      'email':email,
      'phone':phone,
      'uId':uId,
      'image':image,
      'address':address,
      'craftType':craftType,
      'userType':userType,
    };
  }


}

