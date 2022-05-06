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
    var size = MediaQuery.of(context).size;

    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {
        if (state is CraftCreatePostSuccessState) {

          EasyLoading.showToast(
            'تم النشر',
            toastPosition: EasyLoadingToastPosition.bottom,
            duration: const Duration(milliseconds: 1500),
          );

          CraftHomeCubit.get(context).getPosts();
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
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
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.all(20),
                      color: mainColor,
                      width: size.width,
                      height: size.height / 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'انشاء اعلان',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            color: Colors.white,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.arrow_forward_ios),
                          ),
                        ],
                      ),
                    ),
                    Form(
                      key: formKey,
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
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: TextFormField(
                                    minLines: 8,
                                    maxLines: null,
                                    controller: textController,
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'اكتب نص المنشور هنا';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
//  label: Text('البريد الالكتروني'),
//  prefixIcon: Icon(Icons.email_outlined),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),

                                // for name of job field
                                Text(
                                  'اسم الوظيفة أو الخدمة ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: Colors.black,
                                      ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  width: size.width / 2,
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
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'يرجى ادخال اسم الوظيفة او الخدمة';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
//  label: Text('البريد الالكتروني'),
//  prefixIcon: Icon(Icons.email_outlined),
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
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  width: size.width / 2,
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
//  label: Text('البريد الالكتروني'),
//  prefixIcon: Icon(Icons.email_outlined),
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
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  width: size.width / 2,
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
//  label: Text('البريد الالكتروني'),
//  prefixIcon: Icon(Icons.email_outlined),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height / 15,
                          ),
                          Center(
                            child: MaterialButton(
                              onPressed: () {
                                cubit.isEmpty
                                    ? null
                                    : {
                                        if (formKey.currentState!.validate())
                                          {
                                            cubit.createPost(
                                              dateTime:
                                                  DateTime.now().toString(),
                                              text: textController.text.trim(),
                                              jobName:
                                                  nameController.text.trim(),
                                              location: locationController.text
                                                  .trim(),
                                              salary:
                                                  salaryController.text.trim(),
                                            )
                                          }
                                      };
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              height: 60,
                              color: cubit.isEmpty ? Colors.grey : mainColor,
                              child: Container(
                                width: size.width / 1.2,
                                child: const Text(
                                  'نشر',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
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
            ),
          ),
        );
      },
    );
  }
}
