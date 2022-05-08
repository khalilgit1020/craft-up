import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/bloc/home_cubit.dart';
import 'package:graduation/constants.dart';
import 'package:graduation/models/craft_user_model.dart';
import 'package:graduation/screens/settings_screen/settings_screen.dart';
import 'package:graduation/widgets/show_bottom_sheet.dart';
import 'package:graduation/widgets/styles/icon_broken.dart';

import '../../bloc/craft_states.dart';
import '../../widgets/user_info_and_works.dart';
import '../settings_screen/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

//  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {
        //CraftHomeCubit().getMyWorkImages();
      },
      builder: (context, state) {
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
              UserInfoAndWorks(size, userModel, cubit),

              // for user picture
              UserPicture(context,size, userModel),
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
                .push(MaterialPageRoute(builder: (_) => const EditProfileScreen()));
      },
      icon: const Icon(IconBroken.Edit),
      color: Colors.white,
    );
  }

}
