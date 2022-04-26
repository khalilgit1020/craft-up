import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/bloc/home_cubit.dart';
import 'package:graduation/constants.dart';
import 'package:graduation/screens/map_screen.dart';
import 'package:graduation/screens/onBoarding.dart';

import '../../bloc/craft_states.dart';
import '../../models/chat_model.dart';
import '../../models/craft_user_model.dart';
import '../../widgets/styles/icon_broken.dart';

class ChatDetailsScreen extends StatelessWidget {
  final CraftUserModel userModel;

  ChatDetailsScreen({required this.userModel});

  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = CraftHomeCubit.get(context);

        return Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: mainColor,
              leading: IconButton(
                onPressed: (){
                  //cubit.getUsersChatList();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white,),
              ),
              title: Column(
                children: [
                  Text(
                    userModel.name!,style:const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  ),

                  Text(
                    userModel.address!,style:const TextStyle(
                    fontSize: 14,
                  ),
                  ),

                ],
              ),
              actions: [
                IconButton(
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=> MapScreen(
                      cubit: userModel,
                      long: cubit.cPosition.longitude,
                      lat: cubit.cPosition.latitude,
                    )));
                  },
                  icon:const Icon(Icons.location_on_sharp),
                ),
              ],
            ),
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: [
                  Expanded(
                    child: cubit.messages.length > 0
                        ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              reverse:true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                var message = cubit.messages[index];

                                if (cubit.UserModel!.uId ==
                                    message.senderId)
                                  return buildMyMessage(
                                      message, context);

                                return buildMessage(message);
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(
                                    height: 15,
                                  ),
                              itemCount: cubit.messages.length,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    )
                        : const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          'لا توجد رسائل بعد, قل مرحبا...',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.grey.shade300,
                            ),
                            padding:
                            const EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextFormField(
                              enabled: true,
                              controller: textController,
                              decoration:  InputDecoration(
                                hintText: 'أكتب هنا',
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  onPressed: (){
                                    cubit.getMessageImage();
                                  },
                                  icon:  Icon(
                                    IconBroken.Image,
                                    color: mainColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: mainColor,
                          ),
                          child: MaterialButton(
                            onPressed: () {

                              cubit.messageImage == null ?
                              cubit.sendMessage(
                                receiverId: userModel.uId!,
                                dateTime: DateTime.now().toString(),
                                text: textController.text,
                              ):cubit.uploadMessageImage(
                                dateTime: DateTime.now().toString(),
                                text: textController.text,
                                receiverId: userModel.uId!,
                              );




                              if (cubit.messageImage == '') {
                                cubit.sendMessage(
                                  receiverId: userModel.uId!,
                                  dateTime: DateTime.now().toString(),
                                  text: textController.text,
                                );
                              }


                            },
                            minWidth: 1,
                            child:const Icon(
                              IconBroken.Send,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ));
      },
    );
  }

  Widget buildMessage(MessageModel model) => Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadiusDirectional.only(
          topEnd: Radius.circular(10),
          topStart: Radius.circular(10),
          //   bottomEnd: Radius.circular(6),
          bottomStart: Radius.circular(10),
        ),
      ),
      child: Text(
        model.text.toString(),
        style: TextStyle(fontSize: 17),
      ),
    ),
  );

  Widget buildMyMessage(MessageModel model, context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: const BorderRadiusDirectional.only(
              topEnd: Radius.circular(10),
              topStart: Radius.circular(10),
              bottomEnd: Radius.circular(10),
              //  bottomStart: Radius.circular(6),
            ),
          ),
          child: Column(
            children: [
              if (model.messageImage != '')
                Column(
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(model.messageImage.toString()),
                          //  fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      model.text.toString(),
                      style:const TextStyle(fontSize: 17,color: Colors.white),
                    ),
                  ],
                ),
              if (model.messageImage == '')
                Text(
                  model.text.toString(),
                  style:const TextStyle(fontSize: 17,color: Colors.white),
                ),
            ],
          )),
    );
  }
}


