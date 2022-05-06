import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/bloc/craft_states.dart';
import 'package:graduation/bloc/home_cubit.dart';
import 'package:graduation/constants.dart';
import 'package:graduation/models/craft_user_model.dart';
import 'package:graduation/widgets/styles/icon_broken.dart';

class ChatImageZoom extends StatefulWidget {
  CraftUserModel? model;
  int? index;

  ChatImageZoom({this.model, this.index, Key? key}) : super(key: key);

  @override
  State<ChatImageZoom> createState() => _ChatImageZoomState();
}

class _ChatImageZoomState extends State<ChatImageZoom> {
  var captionController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    captionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {
        if (state is CraftSendMessageSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        var cubit = CraftHomeCubit.get(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Colors.black87,
            body: SafeArea(
              child: widget.index == null
                  ? Column(
                      children: [
                        if (state is CraftUploadMessageImageLoadingState)
                          const LinearProgressIndicator(),
                        Expanded(
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Image.file(
                                cubit.messageImage!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.fitWidth,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white54,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      cubit.messageImage = null;
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.black,
                                    ),
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 10,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: Colors.white38,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15.0),
                                            child: TextFormField(
                                              enabled: true,
                                              controller: captionController,
                                              decoration: const InputDecoration(
                                                hintText: 'أضف وصف...',
                                                border: InputBorder.none,
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
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color: mainColor,
                                          ),
                                          child: MaterialButton(
                                            onPressed: () {
                                              cubit.uploadMessageImage(
                                                dateTime:
                                                    DateTime.now().toString(),
                                                text: captionController.text,
                                                receiverId: widget.model!.uId!,
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Hero(
                                tag: cubit.messages[widget.index!].messageImage!,
                                child: Image.network(
                                  cubit.messages[widget.index!].messageImage!,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white54,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.black,
                                    ),
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
