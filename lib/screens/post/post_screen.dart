import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/constants.dart';
import 'package:graduation/models/comment_model.dart';
import 'package:graduation/widgets/my_divider.dart';
import 'package:graduation/widgets/styles/icon_broken.dart';

import '../../bloc/craft_states.dart';
import '../../bloc/home_cubit.dart';
import '../../models/craft_user_model.dart';
import '../../models/post_model.dart';
import '../../widgets/build_comment.dart';
import '../../widgets/show_taost.dart';
import '../other_user_profile.dart';

class PostScreen extends StatefulWidget {
  final PostModel model;

  PostScreen({Key? key, required this.model}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  var commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {
        if (state is CraftWriteCommentSuccessState) {
          showToast(
            state: ToastState.SUCCESS,
            msg: 'تم نشر تعليقك',
          );
          //CraftHomeCubit().getNotifications();
        }
      },
      builder: (context, state) {
        var cubit = CraftHomeCubit.get(context);

        // var userModel = CraftHomeCubit.get(context).UserModel;

        return SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: mainColor,
              body: Column(
                children: [
                  Container(
                    width: size.width,
                    height: size.height / 7.5,
                    child: Stack(
                      children: [
                        const Align(
                          alignment: Alignment(0, -0.4),
                          child: Text(
                            'تفاصيل الوظيفة',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Align(
                          alignment: const Alignment(-0.9, -0.4),
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.arrow_forward),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: size.width,
                      height: size.height,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: size.width / 15,
                            ),

                            // post title
                            Center(
                              child: Text(
                                widget.model.jobName!,
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: size.width / 30,
                            ),

                            // post details
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.model.location!,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${widget.model.salary!} \$',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: size.width / 30,
                            ),

                            // post text
                            Center(
                              child: Container(
                                height: size.height / 3,
                                width: size.width / 1.1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                ),
                                margin: const EdgeInsets.all(10.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5),
                                child: SingleChildScrollView(
                                  child: Text(
                                    widget.model.text!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.width / 10,
                            ),

                            // for enter comment
                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                width: size.width / 1.2,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 0.1,
                                      blurRadius: 4,
                                      offset: Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: commentController,
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'تعليقك فارغ,يرجى ادخال تعليق مناسب للمنشور';
                                          }
                                          return null;
                                        },
                                        onChanged: (String value) {
                                          if (!RegExp(r'^[ ]*$')
                                              .hasMatch(value)) {
                                            cubit.enableCommentButton(
                                                comment: value);
                                          } else {
                                            cubit.unableCommentButton(
                                                comment: value);
                                          }
                                        },
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          label: Text('اكتب تعليقك هنا'),
/*suffixIcon: Icon(
                                          IconBroken.Send,
                                          color: Colors.blue,
                                        ),*/
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: cubit.currentComment == ''
                                          ? null
                                          : () {
                                              cubit.sendComment(
                                                text: commentController.text
                                                    .toString(),
                                                postId: widget.model.postId,
                                              );
                                              commentController.clear();
                                              FocusManager.instance.primaryFocus?.unfocus();
                                            }
                                      /*(){
                                          if(commentController.text.isNotEmpty){
                                            cubit.sendComment(
                                              text: commentController.text.toString(),
                                              postId: model.postId,
                                            );
                                          }

                                        }*/
                                      ,
                                      color: cubit.currentComment == '' ? Colors.grey : Colors.blue,
                                      icon: const Icon(IconBroken.Send),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'رؤية التعليقات ',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: mainColor,
                                ),
                              ),
                            ),
                            MyDivider(),

                            const SizedBox(
                              height: 20,
                            ),

                            ListView.separated(
                              reverse: true,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: cubit.comments!.length,
                              separatorBuilder: (context, index) => MyDivider(),
                              itemBuilder: (context, index) {
                                // cubit.getComments(postId: model.postId);

                                return buildComment(context: context, index: index, model: cubit.comments![index], cubit: cubit);
                              },
                            ),

                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
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

  Widget buildComment({required BuildContext context, required int index, required CommentModel model, required CraftHomeCubit cubit,}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () {
                print(cubit.specialUser![model.userId]!.uId);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => OtherUserProfile(
                      userModel: cubit.specialUser![model.userId]!,
                    )));
              },
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(cubit.specialUser![model.userId]!.image!),
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
                  cubit.specialUser![model.userId]!.name!,
                  style:const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  model.comment.toString(),
                  style:const TextStyle(
                    fontSize: 14,

                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
