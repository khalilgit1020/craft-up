import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/screens/post/post_screen.dart';

import '../../bloc/craft_states.dart';
import '../../bloc/home_cubit.dart';
import '../../constants.dart';
import '../../models/post_model.dart';
import '../../widgets/my_divider.dart';
import '../mah_other_design.dart';

class SavedPostsScreen extends StatelessWidget {
  const SavedPostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = CraftHomeCubit.get(context);

        return SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(size.height / 8),
                child: AppBar(
                  flexibleSpace: FadeIn(
                    child: const Center(
                      child: Text(
                        'المنشورات المحفوظة',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                        // textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  backgroundColor: mainColor,
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: cubit.mySavedPostsDetails!.isNotEmpty
                        ? FadeIn(
                            duration: const Duration(milliseconds: 500),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 20),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: cubit.mySavedPostsDetails!.length,
                                  separatorBuilder: (context, index) =>
                                      MyDivider(),
                                  itemBuilder: (context, index) {
                                    return buildPost(
                                      context: context,
                                      model: cubit.mySavedPostsDetails![index],
                                      cubit: cubit,
                                      //userModel: cubit.UserModel!,
                                    );
                                  },
                                ),
                              ),
                            ),
                          )
                        : FadeIn(
                            duration: const Duration(milliseconds: 500),
                            child: const Center(
                              child: Text(
                                'لا يوجد لديك منشورات محفوظة',
                              ),
                            ),
                          ),
                  ),
                ],
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
      onTap: () {
        cubit.getComments(postId: model.postId);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => PostScreen(model: model)));
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
                  cubit.getOtherWorkImages(id: model.uId);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => MahOtherDesign(
                          userModel: cubit.specialUser![model.uId]!)));
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
                onTap: () {
                  cubit.getOtherWorkImages(id: model.uId);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => MahOtherDesign(
                          userModel: cubit.specialUser![model.uId]!)));
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
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
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
