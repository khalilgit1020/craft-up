import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/bloc/home_cubit.dart';
import 'package:graduation/constants.dart';
import 'package:graduation/screens/chat/chat_image_zoom.dart';
import 'package:graduation/screens/map_screen.dart';

import '../../bloc/craft_states.dart';
import '../../models/chat_model.dart';
import '../../models/craft_user_model.dart';
import '../../widgets/styles/icon_broken.dart';

class ChatDetailsScreen extends StatefulWidget {
  final CraftUserModel userModel;

  const ChatDetailsScreen({Key? key, required this.userModel})
      : super(key: key);

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  var textController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {
        if (state is CraftMessageImagePickedSuccessState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatImageZoom(
                        model: widget.userModel,
                      )));
        }
        if (state is CraftSendMessageToOtherUserSuccessState) {
          CraftHomeCubit.get(context).messageImage = null;
        }
      },
      builder: (context, state) {
        var cubit = CraftHomeCubit.get(context);

        return Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: mainColor,
              leading: IconButton(
                onPressed: () {
                  //cubit.getUsersChatList();
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              title: Column(
                children: [
                  Text(
                    widget.userModel.name!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.userModel.address!,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    cubit.updateLocation();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MapScreen(
                          cubit: widget.userModel,
                          lat: cubit.otherLat!,
                          long: cubit.otherLong!,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.location_on_sharp),
                ),
              ],
            ),
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: cubit.messages.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView.separated(
                                      reverse: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        var message = cubit.messages[index];

                                        if (cubit.UserModel!.uId ==
                                            message.senderId) {
                                          return buildMyMessage(
                                              message, context, index);
                                        }
                                        return buildMessage(
                                            message, context, index);
                                      },
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                        height: 10,
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
                    const SizedBox(height: 10,),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              constraints: const BoxConstraints(
                                maxHeight: 150,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.grey.shade300,
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: TextFormField(
                                minLines: 1,
                                maxLines: 15,
                                enabled: true,
                                controller: textController,
                                decoration: const InputDecoration(
                                  hintText: 'أكتب رسالة...',
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.multiline,
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
                            child: IconButton(
                              onPressed: () {
                                cubit.getMessageImage();
                              },
                              icon: const Icon(
                                IconBroken.Image,
                                color: Colors.white,
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
                                cubit.sendMessage(
                                  receiverId: widget.userModel.uId!,
                                  dateTime: DateTime.now().toString(),
                                  text: textController.text,
                                );
                              },
                              minWidth: 1,
                              child: const Icon(
                                IconBroken.Send,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  Widget buildMessage(MessageModel model, BuildContext context, int index) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: model.messageImage == '' ? 10 : 5,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadiusDirectional.only(
              topEnd: Radius.circular(10),
              topStart: Radius.circular(10),
              bottomStart: Radius.circular(10),
              //  bottomStart: Radius.circular(6),
            ),
          ),
          child: Column(
            children: [
              if (model.messageImage != '')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatImageZoom(
                                      index: index,
                                    )));
                      },
                      child: Hero(
                        tag: CraftHomeCubit.get(context)
                            .messages[index]
                            .messageImage!,
                        child: Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: model.messageImage!,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) {
                                return Container(
                                  color: Colors.white60,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: downloadProgress.progress,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                              repeat: ImageRepeat.repeat,
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                    if (model.text != '')
                      const SizedBox(
                        height: 5,
                      ),
                    if (model.text != '')
                      SelectableText(
                        model.text.toString(),
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                        toolbarOptions:
                            const ToolbarOptions(copy: true, selectAll: true),
                      ),
                  ],
                ),
              if (model.messageImage == '')
                SelectableText(
                  model.text.toString(),
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                  toolbarOptions:
                      const ToolbarOptions(copy: true, selectAll: true),
                ),
            ],
          )),
    );
  }

  Widget buildMyMessage(MessageModel model, context, int index) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: model.messageImage == '' ? 10 : 5,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatImageZoom(
                                    index: index,
                                  )));
                    },
                    child: Hero(
                      tag: CraftHomeCubit.get(context)
                          .messages[index]
                          .messageImage!,
                      child: Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: model.messageImage!,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) {
                            return Container(
                              color: Colors.white60,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                          repeat: ImageRepeat.repeat,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  if (model.text != '')
                    const SizedBox(
                      height: 5,
                    ),
                  if (model.text != '')
                    SelectableText(
                      model.text.toString(),
                      style: const TextStyle(fontSize: 17, color: Colors.white),
                      toolbarOptions:
                          const ToolbarOptions(copy: true, selectAll: true),
                      enableInteractiveSelection: false,
                    ),
                ],
              ),
            if (model.messageImage == '')
              SelectableText(
                model.text.toString(),
                style: const TextStyle(fontSize: 17, color: Colors.white),
                toolbarOptions: const ToolbarOptions(
                  copy: true,
                  selectAll: true,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
