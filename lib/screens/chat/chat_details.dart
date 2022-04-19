import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/bloc/home_cubit.dart';
import 'package:graduation/constants.dart';
import 'package:graduation/screens/map_screen.dart';

import '../../bloc/craft_states.dart';
import '../../models/chat_model.dart';
import '../../models/craft_user_model.dart';
import '../../widgets/styles/icon_broken.dart';


/*
class ChatDetailsScreen extends StatefulWidget {
  CraftUserModel? userModel;

  ChatDetailsScreen({this.userModel, Key? key}) : super(key: key);

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  var messageController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {},
      builder: (context, state) {

        var cubit = CraftHomeCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                CircleAvatar(
                  radius: 15.0,
                  backgroundImage: NetworkImage(widget.userModel!.image!),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: CachedNetworkImage(
                      height: double.infinity,
                      width: double.infinity,
                      imageUrl: widget.userModel!.image!,
                      placeholder: (context, url) => CircleAvatar(
                        radius: 15.0,
                        backgroundColor: Colors.grey[300],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  widget.userModel!.name!,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.black),
                )
              ],
            ),
            titleSpacing: 5.0,
            leading: IconButton(
              icon: const Icon(
                IconBroken.Arrow___Left_2,
                color: Colors.black,
                size: 28,
              ),
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                messageController.clear();
                CraftHomeCubit.get(context).currentMessage = '';
                Navigator.pop(context);
              },
            ),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (cubit.messages.isNotEmpty)
                  Expanded(
                    child: ListView.separated(
                      reverse: true,
                      itemCount: cubit.messages.length,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 8,
                      ),
                      itemBuilder: (context, index) {
                        return cubit
                            .messages[index]
                            .senderId ==
                            cubit.UserModel!.uId
                            ? buildMyMessage(
                            cubit.messages[index], index)
                            : buildMessage(
                            cubit.messages[index],
                            index);
                      },
                    ),
                  ),
                if (cubit.messages.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text('No messages yet'),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40.0,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextFormField(
                            controller: messageController,
                            onChanged: (String value) {
                              if (!RegExp(r'^[ ]*$').hasMatch(value)) {
                                cubit
                                    .enableMessageButton(message: value);
                              } else {
                                cubit
                                    .unableMessageButton(message: value);
                              }
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Message',
                              hintStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: IconButton(
                        color: Theme.of(context).primaryColor,
                        splashRadius: 20,
                        onPressed: cubit.currentMessage == ''
                            ? null
                            : () {
                          cubit.sendMessage(
                            receiverId: widget.userModel!.uId!,
                            dateTime: DateTime.now().toString(),
                            text: messageController.text,
                          );
                          cubit.currentMessage = '';
                          messageController.clear();
                        },
                        icon: const Icon(IconBroken.Send),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Align buildMyMessage(MessageModel messageModel, int index) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.2),
          borderRadius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(10.0),
            topEnd: Radius.circular(10.0),
            bottomStart: Radius.circular(10.0),
          ),
        ),
        child: Text(
          messageModel.text!,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Align buildMessage(MessageModel messageModel, int index) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(10.0),
            topEnd: Radius.circular(10.0),
            bottomEnd: Radius.circular(10.0),
          ),
        ),
        child: Text(
          messageModel.text!,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

*/
/*

class ChatDetailsScreen extends StatelessWidget {
  final CraftUserModel userModel;

  ChatDetailsScreen({required this.userModel});

  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        var cubit = CraftHomeCubit.get(context);

         //cubit.getMessage(receiverId: userModel.uId!);

        return BlocConsumer<CraftHomeCubit, CraftStates>(
          listener: (context, state) {

          },
          builder: (context, state) {


            // MessageModel? mmodel;
            //    var index = cubit.messageImageIndex;

            return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  centerTitle: true,
                  backgroundColor: mainColor,
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
                        Navigator.of(context).push(MaterialPageRoute(builder:(_)=>MapScreen()));
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
*/



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
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=> MapScreen()));
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


