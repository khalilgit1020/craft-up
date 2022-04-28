import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/helpers/cache_helper.dart';
import 'package:graduation/screens/auth/login_screen.dart';
import 'package:graduation/screens/settings_screen/write_suggestion.dart';
import 'package:graduation/widgets/my_divider.dart';

import '../../bloc/craft_states.dart';
import '../../bloc/home_cubit.dart';
import '../../constants.dart';
import '../../widgets/styles/icon_broken.dart';
import 'app_information.dart';

class SettingsProfileScreen extends StatelessWidget {
  const SettingsProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {
        if(state is CraftLogoutSuccessState){
          CacheHelper.removeData(key: 'uId').then((value){
            if(value){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> CraftLoginScreen()));
            }
          });

        }
      },
      builder: (context, state) {
        // var userModel = CraftHomeCubit.get(context).UserModel;

        var cubit = CraftHomeCubit.get(context);

        return SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: mainColor,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                     Container(
                       padding: const EdgeInsets.symmetric(horizontal: 30),
                      height: size.height / 6,
                       child:const Align(
                         alignment: Alignment.center,
                         child: Text(
                           'الاعدادات ',
                           style: TextStyle(
                             fontSize: 22,
                             fontWeight: FontWeight.bold,
                             color: Colors.white,
                           ),
                           textAlign: TextAlign.start,
                         ),
                       ),
                     ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 20),
                      width: size.width,
                      height: size.height,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //buildListTileForSettings(IconBroken.Profile,'البيانات الشخصية',true,(){}),
                          buildListTileForSettings(IconBroken.Info_Circle,'معلومات التطبيق',(){
                            Navigator.of(context).push(MaterialPageRoute(builder:(_)=>const AppInformation()));
                          }),
                          buildListTileForSettings(Icons.add_to_photos,'كتابة اقتراح',(){
                            Navigator.of(context).push(MaterialPageRoute(builder:(_)=> WriteSuggetion()));
                          }),
                          buildListTileForSettings(Icons.share,'مشاركة التطبيق ',(){
                          //  cubit.getNotifications();
                          }),
                          buildListTileForSettings(IconBroken.Logout,'تسجيل الخروج',(){
                            cubit.logOut();
                          }),
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

  Column buildListTileForSettings(IconData icon,title,Function() onTap) {
    return Column(
      children: [
        ListTile(
          onTap:onTap ,
          leading: Icon(
            icon,
            color: Colors.black,
          ),
          title: Text(
            title,
            style:const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        MyDivider(),
      ],
    );
  }
}
