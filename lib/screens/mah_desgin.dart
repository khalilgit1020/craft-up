import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/bloc/craft_states.dart';
import 'package:graduation/bloc/home_cubit.dart';
import 'package:graduation/constants.dart';
import 'package:graduation/screens/settings_screen/edit_profile_screen.dart';
import 'package:graduation/screens/settings_screen/image_zoom_screen.dart';
import 'package:graduation/screens/settings_screen/settings_screen.dart';
import 'package:graduation/widgets/styles/icon_broken.dart';

import '../widgets/show_bottom_sheet.dart';

class MahDesign extends StatelessWidget {
  const MahDesign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = CraftHomeCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  cubit.UserModel!.userType!
                      ? settingModalBottomSheet(context)
                      : Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                },
                icon: const Icon(IconBroken.Edit),
              ),
            ],
            backgroundColor: mainColor,
            elevation: 0,
          ),
          drawer: const Drawer(
            child: SettingsProfileScreen(),
          ),
          body: SingleChildScrollView(
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
                        border:
                            Border.all(width: 4, color: mainColor.withOpacity(.2)),
                      ),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ImageZoomScreen(
                                    tag: 'profile'.toString(),
                                    url: cubit.UserModel!.image!,
                                  )));
                        },
                        child: CircleAvatar(
                          radius: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: CachedNetworkImage(
                              height: double.infinity,
                              width: double.infinity,
                              imageUrl: cubit.UserModel!.image!,
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
                      cubit.UserModel!.name!,
                      style:
                          const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    if (cubit.UserModel!.craftType != '')
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
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
                              cubit.UserModel!.craftType!,
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            )))),
                            const SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                    if (cubit.UserModel!.craftType != '')
                      const SizedBox(
                        height: 12,
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
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
                                  cubit.UserModel!.address!,
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
                      height: 12,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
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
                                  cubit.UserModel!.phone!,
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
                      height: 12,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
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
                            child: Icon(IconBroken.Message),
                          ),
                          Expanded(
                            child: SizedBox(
                              child: Center(
                                child: Text(
                                  cubit.UserModel!.email!,
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
                      height: 25,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    if (cubit.UserModel!.userType!)
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
                    if (cubit.UserModel!.userType!)
                    SizedBox(
                      height: cubit.myWorkGallery.isNotEmpty ? 15 : 50,
                    ),
                    if (!cubit.UserModel!.userType!)
                      const SizedBox(height: 20,),
                    cubit.UserModel!.userType!
                        ? cubit.myWorkGallery.isNotEmpty
                            ? GridView.builder(
                      shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: 3 / 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemCount: cubit.myWorkGallery.length,
                                itemBuilder: (context, index) {
                                  var url =
                                      cubit.myWorkGallery[index]['image'];

                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  ImageZoomScreen(
                                                    tag: index.toString(),
                                                    url: url!,
                                                  )));
                                    },
                                    child: Hero(
                                      tag: index.toString(),
                                      child: CachedNetworkImage(
                                        imageUrl: url!,
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
                                  'لا يوجد لديك صور في معرضك الخاص, أضف بعض الصور...',
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
                                  child:
                                      Image.asset('assets/images/profile2.png'),
                                ),
                                Align(
                                  alignment: const Alignment(0, -1),
                                  child:
                                      Image.asset('assets/images/profile.png'),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
