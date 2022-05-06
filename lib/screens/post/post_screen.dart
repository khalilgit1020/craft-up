import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:graduation/constants.dart';
import 'package:graduation/models/comment_model.dart';
import 'package:graduation/widgets/my_divider.dart';
import 'package:graduation/widgets/styles/icon_broken.dart';

import '../../bloc/craft_states.dart';
import '../../bloc/home_cubit.dart';
import '../../models/post_model.dart';
import '../other_user_profile.dart';

class PostScreen extends StatefulWidget {
  final PostModel model;

  const PostScreen({Key? key, required this.model}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  var commentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {
        if (state is CraftWriteCommentSuccessState) {
          EasyLoading.showToast(
            'تم إضافة التعليق',
            toastPosition: EasyLoadingToastPosition.bottom,
            duration: const Duration(milliseconds: 1000),
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
                  SizedBox(
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
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 5.0),
                                        child: Icon(
                                          Icons.location_on_outlined,
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        widget.model.location!,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
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
                                height: size.height / 4.5,
                                width: size.width / 1.1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 15,
                                      offset: const Offset(-3, 7),
                                    ),
                                  ],
                                ),
                                margin: const EdgeInsets.all(10.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10),
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
                                    horizontal: 8, vertical: 8),
                                constraints: const BoxConstraints(
                                  maxHeight: 100,
                                ),
                                width: size.width / 1.2,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        minLines: 1,
                                        maxLines: 10,
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
                                          contentPadding:
                                              EdgeInsets.symmetric(vertical: 0),
                                          border: InputBorder.none,
                                          label: Text('أضف تعليقك هنا'),
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
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
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
                                      color: cubit.currentComment == ''
                                          ? Colors.grey
                                          : Colors.blue,
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
                            if (cubit.comments!.isNotEmpty)
                              ListView.separated(
                                reverse: true,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: cubit.comments!.length,
                                separatorBuilder: (context, index) =>
                                    MyDivider(startIndent: 15, endIndent: 15),
                                itemBuilder: (context, index) {
                                  // cubit.getComments(postId: model.postId);

                                  return buildComment(
                                      context: context,
                                      index: index,
                                      model: cubit.comments![index],
                                      cubit: cubit);
                                },
                              ),
                            if (cubit.comments!.isEmpty)
                              SizedBox(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'لا توجد تعليقات حتى الآن',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(fontSize: 17, height: 1),
                                    ),
                                    Text(
                                      'كن أول من يعلق',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(fontSize: 14, height: 1.3),
                                    ),
                                  ],
                                ),
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

  Widget buildComment({
    required BuildContext context,
    required int index,
    required CommentModel model,
    required CraftHomeCubit cubit,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () {
                cubit.getOtherWorkImages(id: model.userId).then((value) {
                  if (model.userId != cubit.UserModel!.uId) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => OtherUserProfile(
                            userModel: cubit.specialUser![model.userId]!)));
                  }
                });
              },
              child: CircleAvatar(
                radius: 35,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: CachedNetworkImage(
                    height: double.infinity,
                    width: double.infinity,
                    imageUrl: cubit.specialUser![model.userId]!.image!,
                    placeholder: (context, url) => CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Colors.grey[300],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cubit.specialUser![model.userId]!.name!,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  model.comment.toString(),
                  style: const TextStyle(
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
