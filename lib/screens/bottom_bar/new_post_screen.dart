import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:graduation/constants.dart';

import '../../bloc/craft_states.dart';
import '../../bloc/home_cubit.dart';
import 'home_screen.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  var formKey = GlobalKey<FormState>();

  TextEditingController textController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController locationController = TextEditingController();

  TextEditingController salaryController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textController.dispose();
    nameController.dispose();
    locationController.dispose();
    salaryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;

    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {
        if (state is CraftCreatePostSuccessState) {
          EasyLoading.showToast(
            'تم النشر',
            toastPosition: EasyLoadingToastPosition.bottom,
            duration: const Duration(milliseconds: 1500),
          );

          CraftHomeCubit.get(context).getPosts();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()));
        }

        if (state is CraftCreatePostErrorState) {
          EasyLoading.showToast(
            'حدث خطأ، الرجاء المحاولة مرة آخرى',
            toastPosition: EasyLoadingToastPosition.bottom,
            duration: const Duration(milliseconds: 2000),
          );
        }
      },
      builder: (context, state) {
        var cubit = CraftHomeCubit.get(context);

        cubit.checkEmpty(
          text: textController.text,
          name: nameController.text,
          location: locationController.text,
          salary: salaryController.text,
        );

        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(size.height / 8),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  flexibleSpace: FadeIn(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'إنشاء إعلان',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  backgroundColor: mainColor,
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: formKey,
                      child: FadeIn(
                        duration: const Duration(milliseconds: 500),
                        child: Column(
                          children: [
                            Container(
                              width: size.width,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // for post text field
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Theme
                                          .of(context)
                                          .scaffoldBackgroundColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 3,
                                          blurRadius: 15,
                                          offset: const Offset(-3,
                                              7), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      style: const TextStyle(fontSize: 19, height: 1.5),
                                      minLines: 8,
                                      maxLines: 15,
                                      controller: textController,
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'يجب إدخال نص الإعلان';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                        'أخبر الحِرَفي، ما الخدمة التي تريدها؟',
                                        hintStyle: TextStyle(fontSize: 19),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),

                                  // for name of job field
                                  /*Text(
                                    'اسم الوظيفة أو الخدمة ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    width: size.width / 2,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: nameController,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'يرجى ادخال اسم الوظيفة او الخدمة';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),

                                  // for location field
                                  Text(
                                    'الموقع ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    width: size.width / 2,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: locationController,
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'يرجى تحديد موقع الوظيفة او الخدمة';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),

                                  // for salary field
                                  Text(
                                    'الأجر',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    width: size.width / 2,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: salaryController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'يرجى إدخال سعر الوظيفة او الخدمة المعلن عنها';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),*/
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    width: size.width / 1.1,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 60,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: const [
                                              Text(
                                                'إسم الحرفة',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        VerticalDivider(
                                          color: mainColor,
                                          thickness: 3,
                                          width: 40,
                                          indent: 3,
                                          endIndent: 3,
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            height: 60,
                                            child: TextFormField(
                                              controller: nameController,
                                              textAlign: TextAlign.center,
                                              keyboardType: TextInputType.text,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'يجب إدخال اسم الحرفة';
                                                }
                                                return null;
                                              },
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                'الحرفة المراد الإعلان عنها',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    width: size.width / 1.1,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 60,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: const [
                                              Text(
                                                'الموقع',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        VerticalDivider(
                                          color: mainColor,
                                          thickness: 3,
                                          width: 40,
                                          indent: 3,
                                          endIndent: 3,
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            height: 60,
                                            child: TextFormField(
                                              controller: locationController,
                                              textAlign: TextAlign.center,
                                              keyboardType: TextInputType.text,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'يجب إدخال موقع الصيانة';
                                                }
                                                return null;
                                              },
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding:
                                                EdgeInsets.all(0),
                                                hintText:
                                                'موقع الصيانة المراد إنجازها',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    width: size.width / 1.1,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 60,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: const [
                                              Text(
                                                'الميزانية',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        VerticalDivider(
                                          color: mainColor,
                                          thickness: 3,
                                          width: 40,
                                          indent: 3,
                                          endIndent: 3,
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            height: 60,
                                            child: TextFormField(
                                              controller: salaryController,
                                              textAlign: TextAlign.center,
                                              keyboardType:
                                              TextInputType.number,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'يجب إدخال الميزانية';
                                                }
                                                return null;
                                              },
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                'الأجر المُتوقَع للحرفي',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: size.height / 25,
                            ),
                            Center(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .all(
                                          cubit.isEmpty
                                              ? Colors.grey
                                              : mainColor)),
                                  onPressed: cubit.isEmpty
                                      ? null
                                      : () {
                                    if (formKey.currentState!.validate()) {
                                      cubit.createPost(
                                        dateTime: DateTime.now().toString(),
                                        text: textController.text.trim(),
                                        jobName: nameController.text.trim(),
                                        location:
                                        locationController.text.trim(),
                                        salary:
                                        salaryController.text.trim(),
                                      );
                                    }
                                  },
                                  child: SizedBox(
                                    height: 50,
                                    width: size.width / 1.2,
                                    child: const Center(
                                      child: Text(
                                        'نشر',
                                        style: TextStyle(
                                            fontSize: 21,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                            ),
                          ],
                        ),
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
