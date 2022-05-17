import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:graduation/bloc/craft_states.dart';
import 'package:graduation/bloc/home_cubit.dart';
import 'package:graduation/helpers/cache_helper.dart';
import 'package:graduation/helpers/custom_error.dart';
import 'package:graduation/screens/bottom_bar/home_screen.dart';
import 'package:graduation/screens/onBoarding.dart';

import 'bloc/bloc_observer.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(22, 98, 115, 0.9),
      systemNavigationBarColor: Colors.white,
    ),
  );



  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  customErrorScreen();

  await Firebase.initializeApp();

  await CacheHelper.init();

  Widget widget;
  uId = CacheHelper.getData(key: 'uId');

  if (uId != null) {
    widget = const HomeScreen();
  } else {
    widget = const OnBoardingScreen();
  }

  BlocOverrides.runZoned(
    () {
      // Use cubits...
      runApp(MyApp(
        widget: widget,
      ));
    },
    blocObserver: SimpleBlocObserver(),
  );
}

class MyApp extends StatefulWidget {
  Widget widget;

  MyApp({required this.widget});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState(){
    super.initState();

    Future.delayed(const Duration(milliseconds: 1000)).then((value) => FlutterNativeSplash.remove());
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CraftHomeCubit()
        ..getUserData()
        ..checkIfLocationPermissionAllowed(),
      child: BlocConsumer<CraftHomeCubit, CraftStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'graduation project',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: SafeArea(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: widget.widget,
              ),
            ),
            builder: EasyLoading.init(),
          );
        },
      ),
    );
  }
}
