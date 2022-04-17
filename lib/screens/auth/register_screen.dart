import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/constants.dart';
import 'package:graduation/screens/auth/login_screen.dart';
import 'package:graduation/widgets/show_taost.dart';

import '../../bloc/craft_states.dart';
import '../../bloc/home_cubit.dart';
import '../../bloc/register_cubit.dart';
import '../../helpers/cache_helper.dart';
import '../bottom_bar/home_screen.dart';


class CraftRegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var addressController = TextEditingController();
  var craftTypeController = TextEditingController();
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var ConfirmPasswordController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CraftRegisterCubit(),
      child: BlocConsumer<CraftRegisterCubit, CraftStates>(
        listener: (context, state) {


          if(state is CraftRegisterSuccessState){
            CacheHelper.saveData(
              key: 'uId',
              value: state.uid,
            ).then((value){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>const HomeScreen()));
            }).catchError((error){
              print(error.toString());
            });
          }



          if (state is CraftCreateUserSuccessState ) {

            showToast(
              state: ToastState.SUCCESS,
              msg: 'تم تسجيل الحساب بنجاح',
            );

            CraftHomeCubit().getUserData();
            Navigator.of(context).pushReplacement(

                MaterialPageRoute(builder: (_) =>const HomeScreen()));
          }


            if (state is CraftRegisterErrorState ){
                if(state.error == '[firebase_auth/email-already-in-use] The email address is already in use by another account.' ) {
                  showToast(
                    state: ToastState.ERROR,
                    msg: 'البريد الإالكتروني الذي أدخلته موجود مسبقا,الرجاء كتابة البريد الإالكتروني اخر',
                  );
                }else{
                  showToast(
                    state: ToastState.ERROR,
                    msg: 'يوجد خطأ, الرجاء تسجيل حساب جديد مرة أخرى',
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
                    child: Column(
                      children: [
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    cubit.makeIsCrafterTrue();
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        'حرفيا',
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
                                        Container(
                                          color: mainColor.withOpacity(0.5),
                                          height: 4,
                                          width: 80,
                                        ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    cubit.makeIsCrafterFalse();
                                  },
                                  child: Column(
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
                                        Container(
                                          color: mainColor.withOpacity(0.5),
                                          height: 4,
                                          width: 80,
                                        ),
                                    ],
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
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
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
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
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
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'الرجاء إدخال كلمة السر الخاصة بك';
                                    }else if(value.length < 6 ){
                                      return 'كلمة السر قصيرة,يحب ان تكون على الأقل 6 حروف او أرقام';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
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
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'الرجاء إدخال تأكيد كلمة السر الخاصة بك';
                                    } else if (value !=
                                        passwordController.text) {
                                      return 'كلمة السر غير متطابقة';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
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
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
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
                                      return 'الرجاء إدخال رقم هاتفك';
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
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
                                        keyboardType:
                                            TextInputType.text,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'الرجاء إدخال حرفتك الخاصة';
                                          }
                                        },
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
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
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                height: 60,
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
                                          'تسجيل الدخول',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 16),
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
          );
        },
      ),
    );
  }
}
