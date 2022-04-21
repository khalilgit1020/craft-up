import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/bloc/home_cubit.dart';
import 'package:graduation/constants.dart';
import 'package:graduation/screens/bottom_bar/new_post_screen.dart';

import '../../bloc/craft_states.dart';
import '../../helpers/cache_helper.dart';
import '../../widgets/show_taost.dart';
import '../../widgets/styles/icon_broken.dart';
import '../onBoarding.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CraftHomeCubit()..getUserData()
        ..getPosts()
        ..getMySavedPostsId()
        ..getNotifications()
      ,
      child: BlocConsumer<CraftHomeCubit, CraftStates>(
        listener: (context, state) {

          // CraftSavePostSuccessState
          /*
          if (state is CraftSavePostSuccessState) {
            print('تم الحفظ بنجاح');
            showToast(
              state: ToastState.SUCCESS,
              msg: 'تم حفظ المنشور بنجاح',
            );
            CraftHomeCubit().getMySavedPostsId();
          }*/
        },
        builder: (context, state) {
          var cubit = CraftHomeCubit.get(context);

          return cubit.posts != null && cubit.UserModel != null ? SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                backgroundColor: Colors.white,
                body: cubit.isCrafter
                    ? cubit.crafterScreens[cubit.currentIndex]
                    : cubit.userScreens[cubit.currentIndex],
                floatingActionButton: !cubit.isCrafter
                    ?
                FloatingActionButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => NewPostScreen()));
                        },
                        backgroundColor: mainColor,
                        child: const Icon(Icons.add),
                      )
                    :Container(
                  height: 1,
                  width: 1,
                  decoration:const BoxDecoration(
                    shape: BoxShape.circle
                  ),
                ),

                  floatingActionButtonLocation:
                  !cubit.isCrafter ?
                  FloatingActionButtonLocation.centerDocked:
                    FloatingActionButtonLocation.endTop,
                bottomNavigationBar:AnimatedBottomNavigationBar(
                  icons: [
                    IconBroken.Home,
                    !cubit.isCrafter ?
                    IconBroken.Notification:Icons.bookmark_outline_sharp,
                    IconBroken.Search,
                    IconBroken.Profile,
                  ],
                  activeIndex: cubit.currentIndex,
                  gapLocation: !cubit.isCrafter ? GapLocation.center : GapLocation.none,
                  activeColor: mainColor,
                  notchSmoothness: NotchSmoothness.defaultEdge,
                  leftCornerRadius: 0,
                  rightCornerRadius: 0,
                  onTap: (index) {
                    cubit.changeBottomNv(index);
                  },
                  //other params
                )

                /* BottomNavigationBar(
                  currentIndex: cubit.currentIndex,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: mainColor,
                  unselectedItemColor: Colors.grey,
                  backgroundColor: Colors.white,
                  elevation: 20,
                  onTap: (index) {
                    cubit.changeBottomNv(index);
                  },
                  items: [
                    const BottomNavigationBarItem(
                      icon: Icon(IconBroken.Home),
                      label: '',
                    ),
                    !cubit.isCrafter
                        ? const BottomNavigationBarItem(
                            icon: Icon(IconBroken.Notification),
                            label: '',
                          )
                        : const BottomNavigationBarItem(
                            icon: Icon(Icons.save),
                            label: '',
                          ),
                    const BottomNavigationBarItem(
                      icon: Icon(IconBroken.Search),
                      label: '',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(IconBroken.Profile),
                      label: '',
                    ),
                  ],
                )*/,
              ),
            ),
          ) : const Scaffold(body: Center(child: CircularProgressIndicator(),),);
        },
      ),
    );
  }
}
