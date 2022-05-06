import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:graduation/bloc/home_cubit.dart';
import 'package:graduation/bloc/login_cubit.dart';
import 'package:graduation/constants.dart';
import 'package:graduation/main.dart';
import 'package:graduation/screens/auth/forgot_password.dart';
import 'package:graduation/screens/bottom_bar/home_screen.dart';
import 'package:graduation/screens/auth/register_screen.dart';

import '../../bloc/craft_states.dart';
import '../../helpers/cache_helper.dart';

class CraftLoginScreen extends StatefulWidget {
  const CraftLoginScreen({Key? key}) : super(key: key);

  @override
  State<CraftLoginScreen> createState() => _CraftLoginScreenState();
}

class _CraftLoginScreenState extends State<CraftLoginScreen> {
  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  var cubit = SocialLoginCubit.get(context);

    return BlocProvider(
      create: (context) => CraftLoginCubit(),
      child: BlocConsumer<CraftLoginCubit, CraftStates>(
        listener: (context, state) {
          if (state is CraftLoginSuccessState) {
            print('تم التسجيل بنجاح');
            CacheHelper.saveData(
              key: 'uId',
              value: state.uid,
            ).then((value) {
              uId = state.uid;
              CraftHomeCubit().getUserData();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => MyApp(widget: const HomeScreen())));
            }).catchError((error) {
              print(error.toString());
            });
          }

          if (state is CraftLoginErrorState) {
            if (state.error ==
                '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.') {

              EasyLoading.showInfo(
                'لا يمكن تسجيل الدخول، الرجاء التأكد من البريد الإلكتروني أو كلمة المرور',
                maskType: EasyLoadingMaskType.black,
                duration: const Duration(milliseconds: 3000),
              );

            } else if (state.error ==
                '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.') {

              EasyLoading.showInfo(
                'لم يتم العثور على الحساب، الرجاء التأكد من البريد الإلكتروني',
                maskType: EasyLoadingMaskType.black,
                duration: const Duration(milliseconds: 2500),
              );

            } else {

              EasyLoading.showInfo(
                'حدث خطأ، الرجاء المحاولة مرة آخرى',
                maskType: EasyLoadingMaskType.black,
                duration: const Duration(milliseconds: 2000),
              );

            }
            print(state.error);
          }
        },
        builder: (context, state) {
          var cubit = CraftLoginCubit.get(context);

          return Directionality(
            textDirection: TextDirection.rtl,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'تسجيل الدخول',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                      color: mainColor,
                                    ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),

                            // for email field
                            Text(
                              'البريد الالكتروني',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                              child: TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'الرجاء إدخال الإيميل الخاص بك';
                                  } else if (!value.contains('@')) {
                                    return 'الرجاء إدخال الإيميل بالصيغة الرسمية';
                                  }else{
                                    return null;
                                  }
                                },
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                                  //  label: Text('البريد الالكتروني'),
                                  //  prefixIcon: Icon(Icons.email_outlined),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),

                            // for password field
                            Text(
                              'كلمة السر',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                              child: TextFormField(
                                obscureText: cubit.isPasswordShown,
                                controller: passwordController,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'الرجاء إدخال كلمة السر الخاصة بك';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14),
                                  //label:const Text('كلمة السر'),
                                  // prefixIcon:const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      cubit.changePasswordVisibility();
                                    },
                                    icon: Icon(
                                      cubit.suffixIcon,
                                      color: mainColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => ForgotPassword()));
                              },
                              child: Text(
                                'هل نسيت كلمة السر ؟',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: mainColor,
                                    ),
                              ),
                            ),

                            // for login button
                            const SizedBox(
                              height: 50,
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              height: 60,
                              child: state is CraftLoginLoadingState
                                  ? const Center(
                                      child:
                                          CircularProgressIndicator.adaptive())
                                  : TextButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          cubit.userLogin(
                                            email: emailController.text,
                                            password: passwordController.text,
                                          );
                                        }
                                      },
                                      child: const Text(
                                        'تسجيل الدخول',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),

                            // go to sign up page
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'ليس لديك حساب ؟',
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                CraftRegisterScreen()));
                                  },
                                  child: Text(
                                    'تسجيل مستخدم جديد',
                                    style: TextStyle(color: mainColor),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
