import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:graduation/constants.dart';

import '../../bloc/craft_states.dart';
import '../../bloc/home_cubit.dart';
import '../../models/craft_user_model.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  var addressController = TextEditingController();
  var craftTypeController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {
        if (state is CraftUserUpdateSuccessState) {

          EasyLoading.showToast('تم تعديل البيانات', toastPosition: EasyLoadingToastPosition.bottom, duration: const Duration(milliseconds: 1500));

          CraftHomeCubit.get(context).getUserData();
          Navigator.of(context).pop();

        }
      },
      builder: (context, state) {
        var cubit = CraftHomeCubit.get(context);

        var userModel = CraftHomeCubit.get(context).UserModel!;
        var profileImage = CraftHomeCubit.get(context).profileImage;


/*

        nameController.text = userModel.name!;
        phoneController.text = userModel.phone!;
        addressController.text = userModel.address!;
        craftTypeController.text = userModel.craftType!;
        //  emailController.text = userModel.email!;
*/

        return SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    color: mainColor,
                    width: size.width,
                    height: size.height / 8.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'تعديل الملف الشخصي',
                          style: TextStyle(
                            fontSize: 18,
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
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // for user picture
                            Column(
                              children: [
                                userPicture(size, userModel,profileImage),
                                TextButton(
                                  onPressed: () {
                                    cubit.getProfileImage();
                                  },
                                  child: const Text(
                                    'تغيير الصورة الشخصيَّة',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),

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
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                                  //  label: Text('البريد الالكتروني'),
                                  //  prefixIcon: Icon(Icons.email_outlined),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            if(userModel.userType == true)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                // for enter job name
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
                                        offset: Offset(
                                            0, 2), // changes position of shadow
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
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                                       // label: Text(name),
                                      //  prefixIcon: Icon(Icons.email_outlined),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
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
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
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
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
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
                                initialValue: userModel.email!,
                                style: const TextStyle(color: Colors.grey),
                                enabled: false,
                                //   controller: emailController,

                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                                  //  label: Text('البريد الالكتروني'),
                                  //  prefixIcon: Icon(Icons.email_outlined),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            // for edit button
                            Center(
                              child: Container(
                                width: size.width / 1.3,
                                decoration: BoxDecoration(
                                  color: mainColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                height: 60,
                                child: state is CraftUserUpdateLoadingState
                                    ? const Center(
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      )
                                    : TextButton(
                                        onPressed: () {
                                          cubit.profileImage == null
                                              ? cubit.updateUser(
                                                  name:nameController.text == ''? userModel.name :nameController.text,
                                                  phone:phoneController.text == ''? userModel.phone : phoneController.text,
                                                  address:
                                                  addressController.text == ''? userModel.address : addressController.text,
                                                  craftType:
                                                  craftTypeController.text == ''? userModel.craftType : craftTypeController.text,
                                                )
                                              : cubit.uploadProfileImage(
                                            name:nameController.text == ''? userModel.name :nameController.text,
                                            phone:phoneController.text == ''? userModel.phone : phoneController.text,
                                            address:
                                            addressController.text == ''? userModel.address : addressController.text,
                                            craftType:
                                            craftTypeController.text == ''? userModel.craftType : craftTypeController.text,
                                          );
                                        },
                                        child: const Text(
                                          'حفظ التغييرات',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Column userPicture(Size size, CraftUserModel userModel,profileImage) {
    return Column(
      children: [
        SizedBox(
          height: size.height / 30,
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 4, color: Colors.blue.shade200),
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: profileImage == null
                  ? NetworkImage('${userModel.image}'):
              FileImage(profileImage) as ImageProvider,
            ),
          ),
        ),
      ],
    );
  }
}


