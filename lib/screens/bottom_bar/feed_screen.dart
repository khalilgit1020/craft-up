import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/constants.dart';
import 'package:graduation/screens/chat/chats_screen.dart';
import 'package:graduation/widgets/my_divider.dart';

import '../../bloc/craft_states.dart';
import '../../bloc/home_cubit.dart';
import '../../widgets/build_post.dart';
import '../../widgets/show_taost.dart';

class FeedScreen extends StatelessWidget {
   FeedScreen({Key? key}) : super(key: key);

   var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {


    var size = MediaQuery.of(context).size;

    return BlocConsumer<CraftHomeCubit,CraftStates>(
      listener:(context, state){

      if (state is CraftSavePostSuccessState) {
        print('تم الحفظ بنجاح');
        showToast(
          state: ToastState.SUCCESS,
          msg: 'تم حفظ المنشور بنجاح',
        );
        CraftHomeCubit().getMySavedPostsId();
      }

      if (state is CraftGetPostErrorState) {

        print('${state.error.toString()} +++++++++');
      }

      if (state is CraftGetAllUsersErrorState) {

        print('${state.error.toString()} +++++++++');
      }

      }  ,
      builder:(context, state){

        var cubit = CraftHomeCubit.get(context);

      var UserModel = CraftHomeCubit.get(context).UserModel;

        return  SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: Colors.white,
              body :
              Column(
                children: [

                  Container(
                    height: size.height / 8,
                    padding:const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
                    decoration: BoxDecoration(
                      color: mainColor,
                    ),
                    child: Center(
                      child:
                        Row(
                          children: [
                            Expanded(
                              child: Row(

                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(UserModel!.image!),
                                  ),
                                  const SizedBox(width: 8,),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        UserModel.name!,
                                        style:const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20
                                        ),
                                      ),
                                      Text(
                                        UserModel.craftType!,
                                        style:const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 4,),
                            IconButton(
                              onPressed:(){
                                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const ChatScreen()));
                              },
                              icon:const Icon(Icons.message),
                              iconSize: 33,
                              color: Colors.white,
                            ),
                          ],
                        ),
                    ),
                  ),

                  cubit.posts!.isNotEmpty ?

                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20,),
                            ListView.separated(
                              shrinkWrap: true,
                              physics:const NeverScrollableScrollPhysics(),
                              itemCount: cubit.posts!.length,
                              separatorBuilder: (context,index)=> MyDivider(),
                              itemBuilder:(context,index){
                                return BuildPost(
                                  model: cubit.posts![index],
                                 // userModel: UserModel!,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ) :
                  const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                ],
              )
            ),
          ),);
      } ,
    );
  }

}
