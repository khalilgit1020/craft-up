import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/bloc/home_cubit.dart';

import '../bloc/craft_states.dart';
import '../screens/other_user_profile.dart';
import '../screens/post/post_screen.dart';

class BuildNotification extends StatelessWidget {
  // final PostModel model;
  final String userId;
  final String postId;

  BuildNotification({Key? key, required this.userId, required this.postId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CraftHomeCubit()
        ..giveSpecificUserNotification(id: userId)
        ..getPostScreenFromNotification(id: postId),
      child: BlocConsumer<CraftHomeCubit, CraftStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = CraftHomeCubit.get(context);

          var notificationModel = cubit.notificationUserModel;

          return state is CraftGetPostCommentsNotificationUserLoadingState
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => OtherUserProfile(
                                    userModel: notificationModel!,
                                  )));
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              notificationModel!.image!.toString()),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      flex: 8,
                      child: InkWell(
                        onTap: () async {
                          print('${postId}');
                          cubit.getComments(postId: postId);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => PostScreen(
                                  model: cubit.notificationPostModel!)));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notificationModel.name!,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              '  علق على منشورك ',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
