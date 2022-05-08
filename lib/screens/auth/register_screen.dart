import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:graduation/constants.dart';
import 'package:graduation/main.dart';
import 'package:graduation/screens/auth/login_screen.dart';

import '../../bloc/craft_states.dart';
import '../../bloc/home_cubit.dart';
import '../../bloc/register_cubit.dart';
import '../../helpers/cache_helper.dart';
import '../bottom_bar/home_screen.dart';

class CraftRegisterScreen extends StatefulWidget {
  const CraftRegisterScreen({Key? key}) : super(key: key);

  @override
  State<CraftRegisterScreen> createState() => _CraftRegisterScreenState();
}

class _CraftRegisterScreenState extends State<CraftRegisterScreen> {
  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();

  var addressController = TextEditingController();

  var craftTypeController = TextEditingController();

  var nameController = TextEditingController();

  var passwordController = TextEditingController();

  var ConfirmPasswordController = TextEditingController();

  var phoneController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    addressController.dispose();
    craftTypeController.dispose();
    nameController.dispose();
    passwordController.dispose();
    ConfirmPasswordController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CraftRegisterCubit(),
      child: BlocConsumer<CraftRegisterCubit, CraftStates>(
        listener: (context, state) {
          /*if(state is CraftRegisterSuccessState){
            CacheHelper.saveData(
              key: 'uId',
              value: state.uid,
            ).then((value){
              uId = state.uid;
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> MyApp(widget: const HomeScreen())));
            }).catchError((error){
              print(error.toString());
            });
          }*/

          if (state is CraftCreateUserSuccessState) {

            CacheHelper.saveData(
              key: 'uId',
              value: state.uId,
            ).then((value) {
              uId = state.uId;
              CraftHomeCubit().getUserData();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => MyApp(widget: const HomeScreen())));
            }).catchError((error) {
              print(error.toString());
            });
          }

          if (state is CraftRegisterErrorState) {
            if (state.error ==
                '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
              EasyLoading.showInfo(
                'البريد الإالكتروني الذي أدخلته تم استخدامه بالفعل، الرجاء استخدام بريد إلكتروني آخر',
                maskType: EasyLoadingMaskType.black,
                duration: const Duration(milliseconds: 3000),
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
          var cubit = CraftRegisterCubit.get(context);

          return SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: FadeIn(
                      duration: const Duration(milliseconds: 700),
                      child: Column(
                        children: [
                          const SizedBox(height: 25,),
                          Column(
                            children: [
                              Center(
                                child: Text(
                                  'التسجيل',
                                  style: TextStyle(
                                      color: mainColor,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),

                              // for select type of user
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      onTap: () {
                                        cubit.makeIsCrafterTrue();
                                      },
                                      child: SizedBox(
                                        height: 40,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'حرفي',
                                              style: TextStyle(
                                                color: mainColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            if (cubit.isCrafter)
                                              FadeInLeft(
                                                duration: const Duration(milliseconds: 300),
                                                child: Container(
                                                  color: mainColor.withOpacity(0.5),
                                                  height: 4,
                                                  width: 80,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      onTap: () {
                                        cubit.makeIsCrafterFalse();
                                      },
                                      child: SizedBox(
                                        height: 40,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'مستخدم',
                                              style: TextStyle(
                                                color: mainColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            if (!cubit.isCrafter)
                                              FadeInRight(
                                                duration: const Duration(milliseconds: 300),
                                                child: Container(
                                                  color: mainColor.withOpacity(0.5),
                                                  height: 4,
                                                  width: 80,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                          Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // for enter name
                                Text(
                                  'الاسم',
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
                                    controller: nameController,
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'الرجاء إدخال اسمك';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      //  label: Text('البريد الالكتروني'),
                                      //  prefixIcon: Icon(Icons.email_outlined),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                // for enter email
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
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      //  label: Text('البريد الالكتروني'),
                                      //  prefixIcon: Icon(Icons.email_outlined),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                // for enter password
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
                                    obscureText: cubit.isPassword,
                                    controller: passwordController,
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'الرجاء إدخال كلمة السر الخاصة بك';
                                      } else if (value.length < 6) {
                                        return 'كلمة السر قصيرة,يحب ان تكون على الأقل 6 حروف او أرقام';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 14),
                                      //label:const Text('كلمة السر'),
                                      // prefixIcon:const Icon(Icons.lock_outline),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          cubit.changePasswordVisibility();
                                        },
                                        icon: Icon(
                                          cubit.suffix,
                                          color: mainColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),

                                // for confirm password
                                Text(
                                  'تاكيد كلمة السر',
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
                                    obscureText: cubit.isPassword,
                                    controller: ConfirmPasswordController,
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'الرجاء إدخال تأكيد كلمة السر الخاصة بك';
                                      } else if (value !=
                                          passwordController.text) {
                                        return 'كلمة السر غير متطابقة';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 14),
                                      //label:const Text('كلمة السر'),
                                      // prefixIcon:const Icon(Icons.lock_outline),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          cubit.changePasswordVisibility();
                                        },
                                        icon: Icon(
                                          cubit.suffix,
                                          color: mainColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),

                                // for enter address
                                Text(
                                  'العنوان',
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
                                    controller: addressController,
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'الرجاء إدخال عنوانك';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      //  label: Text('البريد الالكتروني'),
                                      //  prefixIcon: Icon(Icons.email_outlined),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                // for enter phone number
                                Text(
                                  'رقم الجوال',
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
                                    controller: phoneController,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'الرجاء إدخال رقم الهاتف الخاص بك';
                                      } else if (value.length < 7) {
                                        return 'يجب أن يتكون رقم الهاتف من 7 أرقام على الأقل';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: cubit.isCrafter ? 15 : 50,
                                ),

                                if (cubit.isCrafter)
                                  // for enter craft type
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'نوع الحرفة',
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
                                              offset: Offset(0,
                                                  2), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: TextFormField(
                                          controller: craftTypeController,
                                          keyboardType: TextInputType.text,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'الرجاء إدخال حرفتك الخاصة';
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            //  label: Text('البريد الالكتروني'),
                                            //  prefixIcon: Icon(Icons.email_outlined),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                    ],
                                  ),

                                // for register button
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: mainColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  height: 50,
                                  child: state is CraftRegisterLoadingState
                                      ? const Center(
                                          child: CircularProgressIndicator
                                              .adaptive(),
                                        )
                                      : TextButton(
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              cubit.userRegister(
                                                name: nameController.text,
                                                email: emailController.text,
                                                password: passwordController.text,
                                                phone: phoneController.text,
                                                address: addressController.text,
                                                craftType:
                                                    craftTypeController.text,
                                                userType: cubit.isCrafter,
                                              );
                                            }
                                          },
                                          child: const Text(
                                            'تسجيل الحساب',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 19),
                                          ),
                                        ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),

                                // for go to login page
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'لديك حساب ؟ ',
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    CraftLoginScreen()));
                                      },
                                      child: Text(
                                        'تسجيل الدخول',
                                        style: TextStyle(color: mainColor),
                                      ),
                                    ),
                                  ],
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
      ),
    );
  }
}
