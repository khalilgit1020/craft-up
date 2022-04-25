import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/constants.dart';
import 'package:graduation/models/post_model.dart';
import 'package:graduation/screens/chat/chats_screen.dart';
import 'package:graduation/widgets/my_divider.dart';

import '../../bloc/craft_states.dart';
import '../../bloc/home_cubit.dart';
import '../../widgets/show_taost.dart';
import '../onBoarding.dart';
import '../other_user_profile.dart';
import '../post/post_screen.dart';

class FeedScreen extends StatefulWidget {
  FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  var searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();/*
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
            {'longitude': cPosition.longitude, 'latitude': cPosition.latitude});*/
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {
        if (state is CraftSavePostSuccessState) {
          showToast(
            state: ToastState.SUCCESS,
            msg: 'تم حفظ المنشور بنجاح',
          );

          if (kDebugMode) {
            print('تم الحفظ بنجاح');
          }
        }

        if (state is CraftGetPostErrorState) {
          if (kDebugMode) {
            print('${state.error.toString()} +++++++++');
          }
        }

        if (state is CraftGetAllUsersErrorState) {
          if (kDebugMode) {
            print('${state.error.toString()} +++++++++');
          }
        }
      },
      builder: (context, state) {
        var cubit = CraftHomeCubit.get(context);

        // var UserModel = CraftHomeCubit.get(context).UserModel;

        return SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                backgroundColor: Colors.white,
                body: Column(
                  children: [
                    Container(
                      height: size.height / 8,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: mainColor,
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Craft Up',
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                              /*Row(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage:
                                        NetworkImage(UserModel!.image!),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        UserModel.name!,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      Text(
                                        UserModel.craftType!,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ],
                                  )
                                ],
                              )*/
                              ,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            IconButton(
                              onPressed: () {
                                cubit.getUsersChatList();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => const ChatScreen()));
                              },
                              icon: const Icon(Icons.message),
                              iconSize: 33,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    cubit.posts!.isNotEmpty
                        ? Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ListView.separated(
                                      reverse: true,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: cubit.posts!.length,
                                      separatorBuilder: (context, index) =>
                                          MyDivider(),
                                      itemBuilder: (context, index) {
                                        return buildPost(
                                          context: context,
                                          model: cubit.posts![index],
                                          cubit: cubit,
                                          // userModel: UserModel!,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const Expanded(
                            child: Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          )
                  ],
                )),
          ),
        );
      },
    );
  }

  Widget buildPost({
    required BuildContext context,
    required PostModel model,
    required CraftHomeCubit cubit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),

        // name and photo of user
        Row(
          children: [
            InkWell(
              onTap: () {
                cubit.getOtherWorkImages(id: model.uId).then((value) {
                  if (model.uId == cubit.UserModel!.uId) {
                    cubit.changeBottomNv(3);
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => OtherUserProfile(
                            userModel: cubit.specialUser![model.uId]!)));
                  }
                }).catchError((error) {
                  if (kDebugMode) {
                    print(error.toString());
                  }
                });
              },
              child: CircleAvatar(
                radius: 40,
                backgroundColor: mainColor,
                backgroundImage: NetworkImage(model.image!),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              model.name!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),

        const SizedBox(
          height: 10,
        ),

        // post text
        InkWell(
          onTap: () {
            cubit.getComments(postId: model.postId);
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PostScreen(model: model)));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Text(
              model.text!,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
          ),
        ),

        // post details
        Card(
          elevation: 5,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shadowColor: Colors.grey[100],
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: InkWell(
                  onTap: () {
                    cubit.getComments(postId: model.postId);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => PostScreen(
                              model: model,
                            )));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.only(
                          right: 20.0, top: 20, bottom: 20, left: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Text(
                              model.jobName!,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on_sharp),
                              const SizedBox(width: 8),
                              Text(
                                model.location!,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.attach_money_sharp),
                              const SizedBox(width: 8),
                              Text(
                                model.salary!,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (cubit.isCrafter)
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {
                      cubit.savePost(postId: model.postId);
                    },
                    icon: cubit.mySavedPostsId!
                            .any((element) => element == model.postId)
                        ? Icon(
                            Icons.bookmark_sharp,
                            color: mainColor,
                          )
                        : const Icon(Icons.bookmark_outline_sharp),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
