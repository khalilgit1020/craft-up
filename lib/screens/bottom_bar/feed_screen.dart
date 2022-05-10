import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:graduation/constants.dart';
import 'package:graduation/models/post_model.dart';
import 'package:graduation/screens/chat/chats_screen.dart';
import 'package:graduation/screens/other_user_profile.dart';
import 'package:graduation/widgets/styles/icon_broken.dart';

import '../../bloc/craft_states.dart';
import '../../bloc/home_cubit.dart';
import '../post/post_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {
        if (state is CraftSavePostSuccessState) {
          EasyLoading.showToast(
            'تم الحفظ',
            toastPosition: EasyLoadingToastPosition.bottom,
            duration: const Duration(milliseconds: 1000),
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
              body: NestedScrollView(
                // when scroll up the appBar will immediately show
                floatHeaderSlivers: true,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      backgroundColor: mainColor,
                      expandedHeight: size.height / 8,
                      flexibleSpace: SizedBox(
                        height: size.height / 8,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: FadeIn(
                              duration: const Duration(milliseconds: 100),
                              child: Row(
                                children: [
                                  const Text(
                                    'Craft Up',
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      cubit.getUsersChatList();
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const ChatScreen()));
                                    },
                                    icon: const Icon(IconBroken.Chat),
                                    iconSize: 33,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // when stop on scroll up the appBar will immediately show
                      snap: true,
                      floating: true,
                    ),
                  ];
                },
                body: Column(
                  children: [
                    cubit.posts!.isNotEmpty
                        ? Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FadeIn(
                                      duration: const Duration(milliseconds: 100),
                                      child: ListView.separated(
                                        reverse: true,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: cubit.posts!.length,
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(height: 20,),
                                        itemBuilder: (context, index) {
                                          return buildPost(
                                            context: context,
                                            model: cubit.posts![index],
                                            cubit: cubit,
                                            // userModel: UserModel!,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const Expanded(
                            child: SizedBox(),
                          ),
                  ],
                ),
              ),
            ),
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
    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: (){
        cubit.getComments(postId: model.postId);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => PostScreen(model: model)));
      },
      child: Column(
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
                          builder: (_) => OtherUserProfile(userModel: cubit.specialUser![model.uId]!)));
                    }
                  });
                },
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: mainColor,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: CachedNetworkImage(
                      height: double.infinity,
                      width: 70,
                      imageUrl: cubit.specialUser![model.uId]!.image!,
                      placeholder: (context, url) => CircleAvatar(
                        radius: 35.0,
                        backgroundColor: Colors.grey[300],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: (){
                  cubit.getOtherWorkImages(id: model.uId).then((value) {
                    if (model.uId == cubit.UserModel!.uId) {
                      cubit.changeBottomNv(3);
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => OtherUserProfile(userModel: cubit.specialUser![model.uId]!)));
                    }
                  });
                },
                child: Text(
                  cubit.specialUser![model.uId]!.name!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),

          const SizedBox(
            height: 10,
          ),

          // post text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Text(
              model.text!,
              style: const TextStyle(fontSize: 15, color: Colors.black),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
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
                                  fontSize: 17, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
