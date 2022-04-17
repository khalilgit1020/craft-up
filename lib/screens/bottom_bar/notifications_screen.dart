import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/constants.dart';
import 'package:graduation/widgets/build_notification.dart';

import '../../bloc/craft_states.dart';
import '../../bloc/home_cubit.dart';
import '../../widgets/my_divider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    var size = MediaQuery.of(context).size;

    return BlocConsumer<CraftHomeCubit,CraftStates>(
      listener:(context, state){}  ,
      builder:(context, state){

        var cubit = CraftHomeCubit.get(context);

        var UserModel = CraftHomeCubit.get(context).UserModel;

        return
          SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: Column(
                  children: [

                    Container(
                      color: mainColor,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      height: size.height / 8,
                      child:const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'الاشعارات ',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 12),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics:const NeverScrollableScrollPhysics(),
                        itemCount: 2,
                        separatorBuilder: (context,index)=> MyDivider(),
                        itemBuilder:(context,index){

                          // cubit.getComments(postId: model.postId);

                          return BuildNotification();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
      } ,
    );
  }
}
