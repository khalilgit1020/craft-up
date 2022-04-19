

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/models/comment_model.dart';

import '../bloc/craft_states.dart';
import '../bloc/home_cubit.dart';
import '../screens/other_user_profile.dart';

class BuildComment extends StatelessWidget {
  final CommentModel commentModel;
   BuildComment({Key? key,required this.commentModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CraftHomeCubit()..giveSpecificUser(id: commentModel.userId.toString()),
      child: BlocConsumer<CraftHomeCubit,CraftStates>(
        listener:(context,state){


          if (state is CraftWriteCommentSuccessState) {

           // CraftHomeCubit().getComments(postId: model.postId);


          }

          if (state is CraftWriteCommentErrorState) {
            if (kDebugMode) {
              print(state.error.toString());
            }
            // CraftHomeCubit().getComments(postId: model.postId);
          }

        } ,
        builder: (context,state){

          var cubit = CraftHomeCubit.get(context);
           var userModel = cubit.commentUserModel;

          return
            state is CraftGetPostCommentsUserSuccessState ?
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => OtherUserProfile(
                              userModel: userModel!,
                            )));
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(userModel!.image!),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8,),
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userModel.name!,
                          style:const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          commentModel.comment.toString(),
                          style:const TextStyle(
                            fontSize: 14,

                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ) : Container();

        },
      ),
    );
  }
}

