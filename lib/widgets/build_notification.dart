import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/bloc/home_cubit.dart';
import 'package:graduation/models/craft_user_model.dart';
import 'package:graduation/models/post_model.dart';
import 'package:graduation/screens/post/post_screen.dart';

import '../bloc/craft_states.dart';
import '../constants.dart';
import '../screens/other_user_profile.dart';


class BuildNotification extends StatelessWidget {
 // final PostModel model;
//  final CraftUserModel userModel;

  BuildNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CraftHomeCubit,CraftStates>(
      listener:(context,state){} ,
      builder: (context,state){

        var cubit = CraftHomeCubit.get(context);
        var userModel = cubit.commentUserModel;

        return
          Row(
            children: [
              CircleAvatar(
                radius: 40,
              ),
              const SizedBox(width: 12,),
              Column(
                children: [
                  Text(
                    'اسم المستخدم',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    '  علق على منشورك ',
                    style: TextStyle(
                        fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          );

      },
    );
  }
}
