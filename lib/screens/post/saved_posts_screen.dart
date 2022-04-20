import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/craft_states.dart';
import '../../bloc/home_cubit.dart';
import '../../constants.dart';
import '../../widgets/build_post.dart';
import '../../widgets/my_divider.dart';

class SavedPostsScreen extends StatelessWidget {
  const SavedPostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    var size = MediaQuery.of(context).size;

    return BlocConsumer<CraftHomeCubit,CraftStates>(
      listener:(context,state){
      } ,
      builder: (context,state){


        var cubit = CraftHomeCubit.get(context);

        return SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: mainColor,
                    width: size.width,
                    height: size.width / 4,
                    child:const Center(
                      child:  Text(
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
                  Expanded(

                    child:cubit.mySavedPostsDetails!.isNotEmpty ?
                    RefreshIndicator(
                      onRefresh: ()async{
                        await cubit.getMySavedPostsId();
                        //192.168.1.101
                      },
                      child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 20),
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics:const NeverScrollableScrollPhysics(),
                              itemCount: cubit.mySavedPostsDetails!.length,
                              separatorBuilder: (context,index)=> MyDivider(),
                              itemBuilder:(context,index){
                                return BuildPost(
                                  model: cubit.mySavedPostsDetails![index],
                                  //userModel: cubit.UserModel!,
                                );
                              },
                            ),
                          )
                      ),
                    ):
                     const Center(
                      child: Text(
                        'لا يوجد لديك منشورات محفوظة',
                      ),
                    ),
                  )
                ],
              )
            ),
          ),
        );
      },
    );
  }
}
