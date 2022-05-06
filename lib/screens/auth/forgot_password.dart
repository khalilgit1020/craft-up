import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:graduation/bloc/reset_passord_cubit.dart';
import 'package:graduation/constants.dart';

import '../../bloc/craft_states.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);

  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CraftResetPasswordCubit(),
      child: BlocConsumer<CraftResetPasswordCubit, CraftStates>(
        listener: (context, state) {
          if (state is CraftResetPasswordSuccessState) {

            EasyLoading.showSuccess(
              'تم الإرسال، الرجاء فحص البريد الإلكتروني',
              maskType: EasyLoadingMaskType.black,
              duration: const Duration(milliseconds: 2000),
            );
          }

          if (state is CraftResetPasswordErrorState) {
            EasyLoading.showInfo(
              'الرجاء التأكد من البريد الإلكتروني',
              maskType: EasyLoadingMaskType.black,
              duration: const Duration(milliseconds: 2000),
            );
          }
        },
        builder: (context, state) {
          var cubit = CraftResetPasswordCubit.get(context);
          return SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                backgroundColor: Colors.white,
                /*appBar: AppBar(

              elevation: 0,
              backgroundColor: Colors.white,
              title: Text(
                'نسيت كلمة السر',
                style: TextStyle(
                  color: mainColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),*/
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // icon to get back
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'نسيت كلمة السر',
                            style: TextStyle(
                                color: mainColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.arrow_forward_ios),
                            color: mainColor,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),

                      // the email icon
                      Center(
                        child: Image.asset(
                          'assets/images/re_email.png',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      const Center(
                        child: Text(
                          'انتظر الرسالة على البريد الالكتروني',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),

                      Text(
                        'أدخل بريدك الالكتروني',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                                /*boxShadow:const [
                              BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 0.1,
                                blurRadius: 4,
                                offset: Offset(0, 2), // changes position of shadow
                              ),
                            ],*/
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
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              height: 50,
                              child: TextButton(
                                onPressed: () {
                                  cubit.resetPassword(
                                      email: emailController.text);
                                },
                                child: const Text(
                                  'التالي',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
