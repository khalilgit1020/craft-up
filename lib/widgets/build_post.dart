import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/bloc/home_cubit.dart';
import 'package:graduation/models/craft_user_model.dart';
import 'package:graduation/models/post_model.dart';
import 'package:graduation/screens/post/post_screen.dart';

import '../bloc/craft_states.dart';
import '../constants.dart';
import '../screens/other_user_profile.dart';

class BuildPost extends StatelessWidget {
  final PostModel model;

//  final CraftUserModel userModel;

  BuildPost({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = CraftHomeCubit.get(context);
        var userModel = cubit.users.firstWhere((element) => element.uId == model.uId);
        var userModel1 = cubit.commentUserModel;

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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => OtherUserProfile(
                              userModel: userModel,
                            )));
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => PostScreen(
                          model: model,
                        )));
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
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
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
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
                          print('${cubit.mySavedPostsDetails!.length} | ${cubit.mySavedPostsId!.length}');
                          cubit.savePost(postId: model.postId);
                        },
                        icon: const Icon(
                          Icons.bookmark_outline_sharp,
                        ),
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
      },
    );
  }
}
