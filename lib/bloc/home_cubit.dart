import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graduation/models/comment_model.dart';
import 'package:graduation/screens/bottom_bar/profile_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_staorage;
import 'package:graduation/screens/bottom_bar/search_screen.dart';
import 'package:graduation/screens/post/saved_posts_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';
import '../helpers/cache_helper.dart';
import '../models/chat_model.dart';
import '../models/craft_user_model.dart';
import '../models/post_model.dart';
import '../screens/bottom_bar/feed_screen.dart';
import '../screens/bottom_bar/notifications_screen.dart';
import '../screens/onBoarding.dart';
import 'craft_states.dart';

class CraftHomeCubit extends Cubit<CraftStates> {
  CraftHomeCubit() : super(CraftInitialState());

  static CraftHomeCubit get(context) => BlocProvider.of(context);

  CraftUserModel? UserModel;
  bool isCrafter = true;

  // FirebaseAuth.instance.currentUser!.uid
  void getUserData() {
    emit(CraftGetUserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(CacheHelper.getData(key: 'uId'))
        .get()
        .then((value) {
      if (kDebugMode) {
        print(value.data());
      }
      UserModel = CraftUserModel.fromJson(value.data()!);
      getUsers();
      if (kDebugMode) {
        print('${UserModel!.name} ++++++++');
        print('${UserModel!.uId} ++++++++');
      }

      if (UserModel!.userType!) {
        isCrafter = true;
        emit(CraftMakeIsCrafterTrueState());
      } else {
        isCrafter = false;
        emit(CraftMakeIsCrafterFalseState());
      }
      getMyWorkImages();
      getMySavedPostsId();
      emit(CraftGetUserSuccessState());
    }).catchError((error) {
      emit(CraftGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;

  List crafterScreens = [
    FeedScreen(),
    // const NotificationsScreen(),
    const SavedPostsScreen(),
    SearchsScreen(),
    ProfileScreen(),
  ];

  List userScreens = [
    FeedScreen(),
    const NotificationsScreen(),
    //const SavedPostsScreen(),
    SearchsScreen(),
    ProfileScreen(),
  ];

  List<String> titles = const [
    'الرئيسية',
    'الإشعارات',
    'جديد',
    'المحفوظات',
    'البروفايل',
  ];

  void changeBottomNv(int index) {
    if (index == 1) {
      getMySavedPostsId();
    }
    currentIndex = index;

    emit(CraftChangeBottomNavState());
  }

  bool isEmpty = true;

  checkEmpty({
    required String text,
    required String name,
    required String location,
    required String salary,
  }) {
    if (text.isNotEmpty &&
        name.isNotEmpty &&
        location.isNotEmpty &&
        salary.isNotEmpty) {
      isEmpty = false;
    } else {
      isEmpty = true;
    }
  }

  void createPost({
    required String? dateTime,
    required String? text,
    required String? jobName,
    required String? location,
    required String? salary,
  }) {
    emit(CraftCreatePostLoadingState());

    PostModel model = PostModel(
      name: UserModel!.name,
      image: UserModel!.image,
      uId: UserModel!.uId,
      dateTime: dateTime,
      text: text,
      salary: salary,
      jobName: jobName,
      location: location,
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      value.update({
        'postId': value.id,
      }).then((value) {
        getPosts();
      });
      emit(CraftCreatePostSuccessState());
    }).catchError((error) {
      emit(CraftCreatePostErrorState());
    });
  }

  List<PostModel>? posts = [];
  List<String>? postId = [];
  List<CommentModel>? comments = [];

  bool enableComment({required String text}) {
    if (text == '') {
      emit(CraftChangeCommentStateState());
      return false;
    } else {
      emit(CraftChangeCommentStateState());
      return true;
    }
  }

  void sendComment({
    required String? text,
    required String? postId,
   // required String?
  }) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add({
      'comment': text,
      'userId': uId,
      'date': DateTime.now().toString(),
      'postId': postId,
    }).then((value) {
      value.update({
        'commentId': value.id,
      });
      getComments(postId: postId);
      emit(CraftWriteCommentSuccessState());
    }).catchError((error) {
      emit(CraftWriteCommentErrorState(error.toString()));
    });
  }

  void getPosts() {
    posts!.clear();

    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      for (var element in event.docs) {
        postId!.add(element.id);
        posts!.add(PostModel.fromJson(element.data()));
      }
      emit(CraftGetPostSuccessState());
    });
  }

  Future<void> getComments({required String? postId}) async {
    comments = [];
    usersComment = [];
    emit(CraftGetPostCommentsUserLoadingState());

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments').orderBy('date')
        .get()
        .then((value) {
      print('************** Get Comments ***************');
      for (var element in value.docs) {
        comments!.add(CommentModel.fromJson(element.data()));
        usersComment!.add(specialUser![element.data()['userId']]!);
      }
      emit(CraftGetPostCommentsSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(CraftGetPostCommentsErrorState(error.toString()));
    });
  }

  List<CraftUserModel>? usersComment = [];

  /*getCommentModel({required String? userId}) {
    usersComment = specialUser![userId];
    emit(CraftGetUserCommentState());
  }*/

  List notifications = [];
  CraftUserModel? notificationUserModel;

  giveSpecificUserNotification({
    required String? id,
  }) async {
    emit(CraftGetPostCommentsNotificationUserLoadingState());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get()
        .then((value) {
      if (kDebugMode) {
        print(value.data());
      }
      notificationUserModel = CraftUserModel.fromJson(value.data()!);
      //notifications!.add(CraftUserModel.fromJson(value.data()!));

      emit(CraftGetPostCommentsNotificationUserSuccessState());
    }).catchError((error) {
      emit(CraftGetPostCommentsNotificationUserErrorState(error.toString()));
    });
  }

  PostModel? notificationPostModel;
  getPostScreenFromNotification({
    required String? id
} )async{

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(id)
        .get()
        .then((value){
          notificationPostModel = PostModel.fromJson(value.data()!);
    })
        .catchError((erro){

    });


  }

  Future<void> getNotifications( )  // required String? postId
      async {
    notifications.clear();

    await FirebaseFirestore.instance.collection('posts').get().then((value) {
      for (var element in value.docs) {
        if (FirebaseAuth.instance.currentUser!.uid == element['uId']) {
          element.reference.collection('comments').get().then((val) {
            for (var el in val.docs) {
              if (kDebugMode) {
                print('${el['userId']} 3333333333');
              }
              notifications.add({
                'userId':el['userId'],
                'postId':el['postId'],
              });
              // giveSpecificUserNotification(id: el['userId']);

              emit(CraftGetPostCommentsNotificationUserSuccessState());
            }
            if (kDebugMode) {
              print(notifications.length.toString());
            }
          }).catchError((error) {});

          //print('${element.data()} 3333333333' );
        }

        /* if (kDebugMode) {
            print('${element.data()} 3333333333' );
          }*/
      }
    }).catchError((error) {});
  }

  CraftUserModel? commentUserModel;

  giveSpecificUser({
    required String? id,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get()
        .then((value) {
      if (kDebugMode) {
        print(value.data());
      }
      commentUserModel = CraftUserModel.fromJson(value.data()!);
      emit(CraftGetPostCommentsUserSuccessState());
    }).catchError((error) {
      emit(CraftGetPostCommentsUserErrorState(error.toString()));
    });
  }

  File? profileImage;
  var picker = ImagePicker();

  Future getProfileImage() async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      if (kDebugMode) {
        print(pickedFile.path);
      }
      emit(CraftProfileImagePickedSuccessState());
    } else {
      if (kDebugMode) {
        print('no image');
      }

      emit(CraftProfileImagePickedErrorState());
    }
  }

  File? workImage;

  Future getWorkImage() async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      workImage = File(pickedFile.path);
      if (kDebugMode) {
        print(pickedFile.path);
      }
      uploadWorkImage();
      emit(CraftWorkImagePickedSuccessState());
    } else {
      if (kDebugMode) {
        print('no image');
      }

      emit(CraftWorkImagePickedErrorState());
    }
  }

  void uploadProfileImage({
    required String? name,
    required String? phone,
    String? bio,
    required String? address,
    required String? craftType,
  }) {
    emit(CraftUserUpdateLoadingState());

    firebase_staorage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        if (kDebugMode) {
          print(value);
        }
        updateUser(
          name: name,
          phone: phone,
          address: address,
          craftType: craftType,
          image: value,
        );
        getUserData();
        emit(CraftUploadProfileImageSuccessState());
      }).catchError((error) {
        emit(CraftUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(CraftUploadProfileImageErrorState());
    });
  }

  List<Map> myWorkGallery = [];

  Future getMyWorkImages() async {
    emit(CraftGetMyWorkImageLoadingState());

    myWorkGallery.clear();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('workGallery')
        .get()
        .then((value) {
      for (var element in value.docs) {
        myWorkGallery.add({
          'image': element['imageUrl'],
          'id': element.id,
        });

        if (kDebugMode) {
          print(element['imageUrl']);
        }
      }

      emit(CraftGetMyWorkImageSuccessState());

      // print('${value.docs.forEach((element) {element})}  ***********');
    }).catchError((error) {
      emit(CraftGetMyWorkImageErrorState());
    });
  }

  List<Map> otherWorkGallery = [];

  Future<void> getOtherWorkImages({required String? id}) async {
    emit(CraftGetOtherWorkImageLoadingState());

    otherWorkGallery.clear();

    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('workGallery')
        .get()
        .then((value) {
      for (var element in value.docs) {
        otherWorkGallery.add({
          'image': element['imageUrl'],
          'id': element.id,
        });

        if (kDebugMode) {
          print(element['imageUrl']);
        }
      }

      emit(CraftGetOtherWorkImageSuccessState());
      // print('${value.docs.forEach((element) {element})}  ***********');
    }).catchError((error) {
      emit(CraftGetOtherWorkImageErrorState());
    });
  }

  List<String>? mySavedPostsId = [];
  List<PostModel>? mySavedPostsDetails = [];

  getMySavedPostsId() {
    emit(CraftGetSavedPostsLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('savedPosts')
        .get()
        .then((value) {
      mySavedPostsId = [];
      mySavedPostsDetails = [];
      for (var element in value.docs) {
        mySavedPostsId!.add(element['postId']);
        mySavedPostsDetails!
            .add(posts!.firstWhere((item) => item.postId == element['postId']));

        /*FirebaseFirestore.instance.collection('posts').get().then((value) {
          for (var el in value.docs) {
            if (kDebugMode) {
              print('${element['postId']} 555555');
            }
            if (element['postId'] == el.id) {
              mySavedPostsDetails!.add(PostModel.fromJson(el.data()));
            }
          }
        });*/
      }
      emit(CraftGetSavedPostsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CraftGetSavedPostsErrorState());
    });
  }

/*

  Future<bool>? isSaved({
  required String? id,
})async{

     var a =  await FirebaseFirestore.instance
        .collection('users')
        .doc(UserModel!.uId)
        .collection('savedPosts')
        .doc(id)
        .get();


    if(a.exists){
      print('Exists');
      return true;
    }
    if(!a.exists){
      print('Not exists');
      return false;
    }


  }
*/
  bool checkPostSaved({required String postId}) {
    if (mySavedPostsId!.any((element) => element == postId)) {
      return true;
    }
    return false;
  }

  Future<void> savePost({required String? postId}) {
    if (!mySavedPostsId!.any((element) => element == postId)) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('savedPosts')
          .doc(postId)
          .set({
        'postId': postId,
      }).then((value) {
        getMySavedPostsId();
        emit(CraftSavePostSuccessState());
      }).catchError((error) {
        emit(CraftSavePostErrorState());
      });
    } else {
      return deleteSavedPost(postId: postId);
    }
  }

  Future<void> deleteSavedPost({required String? postId}) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('savedPosts')
        .doc(postId)
        .delete()
        .then((value) {
      getMySavedPostsId();
      emit(CraftDeleteSavePostSuccessState());
    }).catchError((error) {
      emit(CraftDeleteSavePostErrorState());
    });
  }

  void deleteImageFromWork({
    required String? id,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('workGallery')
        .doc(id)
        .delete()
        .then((value) {
      getMyWorkImages();
      emit(CraftDeleteWorkImageSuccessState());
    }).catchError((error) {
      emit(CraftDeleteWorkImageErrorState());
    });
  }

  void uploadWorkImage() async {
    emit(CraftUploadWorkImageLoadingState());

    await firebase_staorage.FirebaseStorage.instance
        .ref()
        .child('workGallery/${Uri.file(workImage!.path).pathSegments.last}')
        .putFile(workImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        if (kDebugMode) {
          print(value);
        }
        FirebaseFirestore.instance
            .collection('users')
            .doc(uId)
            .collection('workGallery')
            .add({
          'imageUrl': value,
        }).then((value) {
          emit(CraftUploadWorkImageSuccessState());
        }).catchError((error) {
          emit(CraftUploadWorkImageErrorState());
        });
      }).catchError((error) {
        emit(CraftUploadWorkImageErrorState());
      });
    }).catchError((error) {
      emit(CraftUploadWorkImageErrorState());
    });
  }

  void updateUser({
    required String? name,
    required String? phone,
    required String? address,
    required String? craftType,
    String? image,
  }) {
    emit(CraftUserUpdateLoadingState());

    CraftUserModel model = CraftUserModel(
      name: name,
      phone: phone,
      craftType: craftType,
      address: address,
      email: UserModel!.email,
      uId: UserModel!.uId,
      userType: UserModel!.userType,
      image: image ?? UserModel!.image,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(UserModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
      emit(CraftUserUpdateSuccessState());
    }).catchError((error) {
      emit(CraftUserUpdateErrorState());
    });
  }

  List<CraftUserModel> users = [];
  Map<String, CraftUserModel>? specialUser = {};

  void getUsers() {
    users = [];
    emit(CraftGetAllUsersLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {
        if (element.data()['uId'] != UserModel!.uId) {
          users.add(CraftUserModel.fromJson(element.data()));
        }
        specialUser!.addAll(
            {element.data()['uId']: CraftUserModel.fromJson(element.data())});
      }
      if (kDebugMode) {
        print(
            "${users.length}ssssssssssssssssssssssssssssssssssssssssssssssssssssssss");
      }

      emit(CraftGetAllUsersSuccessState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(CraftGetAllUsersErrorState(error.toString()));
    });
  }

  List<CraftUserModel>? usersMessenger = [];

  void selectUserMessenger(String userId){

  }

  Future<void> getUsersChatList() async {
    print('***************');
    emit(CraftGetAllUsersMessengerLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(UserModel!.uId)
        .collection('chats').orderBy('dateTime').snapshots().listen((value) {
          usersMessenger = [];
          print('****************** ${value.docs.length} *******************');
          for(var item in value.docs){
            print('helloooooooooooooooooooooo');
            usersMessenger!.insert(0, specialUser![item.id]!);
          }
          emit(CraftGetAllUsersMessengerSuccessState());
    });
  }

  List<MessageModel> messages = [];
  String currentMessage = '';

  enableMessageButton({required String message}) {
    currentMessage = message;
    emit(CraftEnableMessageButtonState());
  }

  unableMessageButton({required String message}) {
    currentMessage = '';
    emit(CraftUnableMessageButtonState());
  }

  void getMessage({
    required String receiverId,
  }) {
    emit(CraftGetMessageLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];

      for (var element in event.docs) {
        messages.insert(0, MessageModel.fromJson(element.data()));
        //    print (element.data());
      }

      emit(CraftGetMessageSuccessState());
    });
  }

  void sendMessage({
    required String receiverId,
    required String? dateTime,
    required String? text,
    String? messageImage,
  }) {
    MessageModel model = MessageModel(
      receiverId: receiverId,
      senderId: UserModel!.uId,
      dateTime: dateTime,
      text: text,
      messageImage: messageImage ?? '',
    );

    // set my chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(UserModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
          FirebaseFirestore.instance.collection('users').doc(UserModel!.uId)
              .collection('chats')
              .doc(receiverId)
              .set({'dateTime': dateTime});
      emit(CraftSendMessageSuccessState());
    }).catchError((error) {
      emit(CraftSendMessageErrorState());
    });

    // set receiver chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(UserModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
          FirebaseFirestore.instance.collection('users')
              .doc(receiverId)
              .collection('chats')
              .doc(UserModel!.uId)
              .set({'dateTime': dateTime});

      emit(CraftSendMessageSuccessState());
    }).catchError((error) {
      emit(CraftSendMessageErrorState());
    });
  }

  var messageImageIndex = 0;
  File? messageImage;

  Future getMessageImage() async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      messageImage = File(pickedFile.path);
      if (kDebugMode) {
        print(pickedFile.path);
      }
      emit(CraftMessageImagePickedSuccessState());
    } else {
      if (kDebugMode) {
        print('no image');
      }

      emit(CraftMessageImagePickedErrorState());
    }
  }

  void uploadMessageImage({
    required String dateTime,
    required String text,
    required String? receiverId,
  }) {
    emit(CraftUploadMessageImageLoadingState());

    firebase_staorage.FirebaseStorage.instance
        .ref()
        .child('messages/${Uri.file(messageImage!.path).pathSegments.last}')
        .putFile(messageImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //  emit(CraftUploadCoverImageSuccessState());
        //  print(value);
        sendMessage(
          receiverId: receiverId!,
          dateTime: dateTime,
          text: text,
          messageImage: value,
        );

        messageImage = File('');
      }).catchError((error) {
        sendMessage(
          receiverId: receiverId!,
          dateTime: dateTime,
          text: text,
          messageImage: '',
        );
        emit(CraftUploadMessageImageErrorState());
      });
    }).catchError((error) {
      emit(CraftUploadMessageImageErrorState());
    });

    //  messageImage = File('');
  }

  void writeSuggestion({
    required String? date,
    required String? content,
    required String? uId,
  }) async {
    emit(CraftWriteSuggestionLoadingState());

    await FirebaseFirestore.instance.collection('suggestions').add({
      'content': content,
      'date': date,
      'userId': uId,
    }).then((value) {
      emit(CraftWriteSuggestionSuccessState());
    }).catchError((error) {
      emit(CraftWriteSuggestionErrorState(error.toString()));
    });
  }

  List<PostModel>? search = [];

  void getSearch({required String? text}) async {
    search = [];

    await FirebaseFirestore.instance.collection('posts').get().then((value) {
      emit(NewsSearchLoadingStates());
      for (var element in value.docs) {
        if (element['jobName'].toString().contains(text!) ||
            element['text'].toString().contains(text)) {
          search!.add(PostModel.fromJson(element.data()));

          emit(CraftSearchSuccessStates());
        }
      }
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(CraftSearchErrorStates(error));
    });
  }

  void logOut(context) {
    emit(CraftLogoutLoadingState());

    FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.removeData(
        key: 'uId',
      ).then((value) {
        emit(CraftLogoutSuccessState());
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const OnBoardingScreen()));
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(CraftLogoutErrorState());
      });
    });
  }

  String currentComment = '';

  enableCommentButton({required String comment}) {
    currentComment = comment;
    emit(CraftEnableCommentButtonState());
  }

  unableCommentButton({required String comment}) {
    currentComment = '';
    emit(CraftUnableCommentButtonState());
  }





  late Position cPosition;
  LocationPermission? locationPermission;
  checkIfLocationPermissionAllowedd() async {

    locationPermission = await Geolocator.requestPermission().then((value) {
      getPositionn();
      //emit(CraftGetLocationSuccessState());
    }).catchError((error){
      emit(CraftGetLocationErrorState(error.toString()));

    });

    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission().then((value) {
        getPositionn();
       // emit(CraftGetLocationSuccessState());
      }).catchError((error){
        emit(CraftGetLocationErrorState(error.toString()));

      });
    }
  }
  getPositionn()async{

    cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    emit(CraftGetLocationSuccessState());
  }




}
