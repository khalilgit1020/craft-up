import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/bloc/craft_states.dart';
import 'package:graduation/bloc/home_cubit.dart';
import 'package:graduation/constants.dart';
import 'package:graduation/screens/settings_screen/image_zoom_screen.dart';
import 'package:graduation/widgets/styles/icon_broken.dart';

import '../models/craft_user_model.dart';
import 'chat/chat_details.dart';

class MahOtherDesign extends StatelessWidget {
  final CraftUserModel userModel;

  const MahOtherDesign({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = CraftHomeCubit.get(context);

        return Directionality(
          textDirection: TextDirection.rtl,
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
              backgroundColor: mainColor,
              elevation: 0,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FadeIn(
                    duration: const Duration(milliseconds: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 4, color: mainColor.withOpacity(.2)),
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => ImageZoomScreen(
                                        tag: 'profile'.toString(),
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
                                    radius: 50.0,
                                    backgroundColor: Colors.grey[300],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          userModel.name!,
                          style: const TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (userModel.craftType != '')
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: mainColor.withOpacity(.2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 3,
                                    blurRadius: 12,
                                    offset: const Offset(-1, 6),
                                  )
                                ]),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 5,
                                  child: Icon(IconBroken.Work),
                                ),
                                Expanded(
                                    child: SizedBox(
                                        child: Center(
                                            child: Text(
                                  userModel.craftType!,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                )))),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                        if (userModel.craftType != '')
                          const SizedBox(
                            height: 5,
                          ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: mainColor.withOpacity(.2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 12,
                                  offset: const Offset(-1, 6),
                                )
                              ]),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 5,
                                child: Icon(IconBroken.Location),
                              ),
                              Expanded(
                                child: SizedBox(
                                  child: Center(
                                    child: Text(
                                      userModel.address!,
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: mainColor.withOpacity(.2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 12,
                                  offset: const Offset(-1, 6),
                                )
                              ]),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 5,
                                child: Icon(IconBroken.Call),
                              ),
                              Expanded(
                                child: SizedBox(
                                  child: Center(
                                    child: Text(
                                      userModel.phone!,
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(mainColor),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                            onPressed: () {
                              cubit.getMessage(receiverId: userModel.uId!);
                              cubit.getOtherLocation(userId: userModel.uId!);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ChatDetailsScreen(userModel: userModel)));
                            },
                            child: const Text(
                              'محادثة',
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 10,
                        ),
                        if (userModel.userType!)
                          Row(
                            children: const [
                              Icon(
                                IconBroken.Image_2,
                                size: 27,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'معرض الأعمال',
                                style: TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        if (userModel.userType!)
                          SizedBox(
                            height: cubit.otherWorkGallery.isNotEmpty ? 15 : 50,
                          ),
                        if (!userModel.userType!)
                          const SizedBox(
                            height: 20,
                          ),
                        userModel.userType!
                            ? cubit.otherWorkGallery.isNotEmpty
                                ? GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 200,
                                      childAspectRatio: 3 / 3,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                    itemCount: cubit.otherWorkGallery.length,
                                    itemBuilder: (context, index) {
                                      var url = cubit.otherWorkGallery[index]
                                          ['image'];

                                      return InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      ImageZoomScreen(
                                                        tag: index.toString(),
                                                        url: url,
                                                      )));
                                        },
                                        child: Hero(
                                          tag: index.toString(),
                                          child: CachedNetworkImage(
                                            imageUrl: url,
                                            placeholder: (context, url) =>
                                                Container(
                                              color: Colors.grey[300],
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Center(
                                    child: Text(
                                      'لا يوجد لديه صور في معرضه الخاص بعد',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: mainColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                            : Center(
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: const Alignment(-2, -0.7),
                                      child: Image.asset(
                                          'assets/images/profile2.png'),
                                    ),
                                    Align(
                                      alignment: const Alignment(0, -1),
                                      child: Image.asset(
                                          'assets/images/profile.png'),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
