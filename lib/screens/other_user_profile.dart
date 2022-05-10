import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/bloc/home_cubit.dart';
import 'package:graduation/constants.dart';
import 'package:graduation/models/craft_user_model.dart';
import 'package:graduation/screens/chat/chat_details.dart';

import '../bloc/craft_states.dart';
import '../widgets/styles/icon_broken.dart';
import '../widgets/user_info_and_works.dart';
import 'settings_screen/image_zoom_screen.dart';

class OtherUserProfile extends StatelessWidget {
  final CraftUserModel userModel;

  const OtherUserProfile({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = CraftHomeCubit.get(context);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
                elevation: 0,
                backgroundColor: mainColor,
              ),
              body: SingleChildScrollView(
                child: Stack(
                  children: [
                    // for background color
                    Container(
                      color: mainColor,
                      height: size.height / 5.5,
                    ),

                    // for information card and gallery works
                    userInfoAndWorks(size, userModel, cubit, context),

                    // for user picture
                    userPicture(context, size, userModel),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Column userPicture(context, Size size, CraftUserModel userModel) {
    return Column(
      children: [
        SizedBox(
          height: size.height / 16,
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 4, color: Colors.blue.shade200),
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ImageZoomScreen(
                          tag: 'profile 1'.toString(),
                          url: userModel.image!,
                        )));
              },
              child: CircleAvatar(
                radius: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: CachedNetworkImage(
                    height: double.infinity,
                    width: double.infinity,
                    imageUrl: userModel.image!,
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
        ),
      ],
    );
  }

  Column userInfoAndWorks(
    Size size,
    CraftUserModel userModel,
    CraftHomeCubit cubit,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: size.height / 8.5,
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300]!,
                  blurRadius: 6,
                  spreadRadius: 0,
                  offset: const Offset(0, 3),
                )
              ]
            ),
            child: FadeIn(
              duration: const Duration(milliseconds: 500),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height / 16,
                  ),
                  textUser(userModel.name, 20),
                  const SizedBox(
                    height: 15,
                  ),
                  if (userModel.craftType != '')
                    Padding(
                      padding: EdgeInsets.only(right: size.width / 3.5),
                      child: Row(
                        children: [
                          const Icon(IconBroken.Work),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            userModel.craftType!,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                  //textUser(userModel.craftType, 14),
                  if (userModel.craftType != '')
                    const SizedBox(
                      height: 5,
                    ),
                  Padding(
                    padding: EdgeInsets.only(right: size.width / 3.5),
                    child: Row(
                      children: [
                        const Icon(IconBroken.Location),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          userModel.address!,
                          style: const TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                  //textUser('${userModel.address} | ${userModel.phone}', 14),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: size.width / 3.5),
                    child: Row(
                      children: [
                        const Icon(IconBroken.Call),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          userModel.phone!,
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //textUser(userModel.email, 14),
                  const SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    onTap: () {
                      cubit.getMessage(receiverId: userModel.uId!);
                      cubit.getOtherLocation(userId: userModel.uId!);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ChatDetailsScreen(userModel: userModel)));
                    },
                    child: Container(
                      width: size.width / 2.5,
                      height: 45,
                      decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Text(
                          'محادثة',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        if (userModel.userType!)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: FadeIn(
              duration: const Duration(milliseconds: 500),
              child: const Text(
                'معرض الأعمال',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        if (userModel.userType!)
          SizedBox(
            height: cubit.otherWorkGallery.isNotEmpty ? 15 : 70,
          ),
        if (!userModel.userType!)
          const SizedBox(
            height: 20,
          ),
        userModel.userType!
            ? cubit.otherWorkGallery.isNotEmpty
                ? FadeIn(
                    duration: const Duration(milliseconds: 500),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 2),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 3 / 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: cubit.otherWorkGallery.length,
                      itemBuilder: (context, index) {
                        var url = cubit.otherWorkGallery[index]['image'];

                        return InkWell(
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ImageZoomScreen(
                                      tag: index.toString(),
                                      url: url,
                                    )));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.0),
                            child: Hero(
                              tag: index.toString(),
                              child: CachedNetworkImage(
                                imageUrl: url,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[300],
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : FadeIn(
                    duration: const Duration(milliseconds: 500),
                    child: Center(
                      child: Text(
                        'لا يوجد لديه صور في معرضه الخاص بعد',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
            : FadeIn(
                duration: const Duration(milliseconds: 500),
                child: Center(
                  child: Stack(
                    children: [
                      Align(
                        alignment: const Alignment(-2, -0.7),
                        child: Image.asset('assets/images/profile2.png'),
                      ),
                      Align(
                        alignment: const Alignment(0, -1),
                        child: Image.asset('assets/images/profile.png'),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}
