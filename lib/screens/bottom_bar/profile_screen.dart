import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/bloc/home_cubit.dart';
import 'package:graduation/constants.dart';
import 'package:graduation/models/craft_user_model.dart';
import 'package:graduation/screens/settings_screen/image_zoom_screen.dart';
import 'package:graduation/screens/settings_screen/settings_screen.dart';
import 'package:graduation/widgets/show_bottom_sheet.dart';
import 'package:graduation/widgets/styles/icon_broken.dart';

import '../../bloc/craft_states.dart';
import '../settings_screen/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

//  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {
        CraftHomeCubit().getUserData();
        //CraftHomeCubit().getMyWorkImages();
      },
      builder: (context, state) {
        CraftHomeCubit().getMyWorkImages();

        var cubit = CraftHomeCubit.get(context);

        //  cubit.getUserData();

        var userModel = cubit.UserModel!;

        return Scaffold(
          drawer: const Drawer(
            child: SettingsProfileScreen(),
          ),
          appBar: AppBar(
            actions: [
              settingsOfProfile(context, userModel),
            ],
            elevation: 0,
            backgroundColor: mainColor,
          ),
          body: Stack(
            children: [
              // for background color
              Container(
                color: mainColor,
                height: size.height / 5.5,
              ),

              // for information card and gallery works
              userInfoAndWorks(size, userModel, cubit),

              // for user picture
              userPicture(size, userModel),
            ],
          ),
        );
      },
    );
  }

  IconButton settingsOfProfile(context, CraftUserModel userModel) {
    return IconButton(
      onPressed: () {
        userModel.userType!
            ? settingModalBottomSheet(context)
            : Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => EditProfileScreen()));
      },
      icon: const Icon(IconBroken.Edit),
      color: Colors.white,
    );
  }

  Column userPicture(Size size, CraftUserModel userModel) {
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
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(userModel.image!),
            ),
          ),
        ),
      ],
    );
  }

  Column userInfoAndWorks(
      Size size, CraftUserModel userModel, CraftHomeCubit cubit) {
    return Column(
      children: [
        SizedBox(
          height: size.height / 8.5,
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Card(
              elevation: 5,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height / 15,
                      ),
                      textUser(userModel.name, 20),
                      textUser(
                          userModel.craftType == ''
                              ? '${userModel.address}'
                              : '${userModel.craftType} | ${userModel.address}',
                          14),
                      textUser(userModel.phone, 14),
                      textUser(userModel.email, 14),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        userModel.userType!
            ? Expanded(
                //cubit.getMyWorkImages();

                child: RefreshIndicator(
                onRefresh: () {
                  return cubit.getMyWorkImages();
                },
                child: cubit.myWorkGallery.isNotEmpty
                    ? GridView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 2),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 3 / 3,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 14,
                        ),
                        itemCount: cubit.myWorkGallery.length,
                        itemBuilder: (context, index) {
                          var url = cubit.myWorkGallery[index]['image'];

                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => ImageZoomScreen(
                                        tag: index.toString(),
                                        url: url,
                                      )));
                            },
                            child: Hero(
                              tag: index.toString(),
                              child: Image.network(
                                '$url',
                                fit: BoxFit.fill,
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
                              color: mainColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
              ))
            : Expanded(
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

  Center textUser(userModel, double size) {
    return Center(
      child: Text(
        userModel,
        style: TextStyle(fontSize: size, fontWeight: FontWeight.bold),
      ),
    );
  }
}
