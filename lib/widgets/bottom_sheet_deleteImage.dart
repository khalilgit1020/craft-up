
import 'package:flutter/material.dart';
import 'package:graduation/constants.dart';

import '../bloc/home_cubit.dart';
import '../screens/settings_screen/edit_profile_screen.dart';

deleteImageModalBottomSheet(context,uid) {


  var cubit = CraftHomeCubit.get(context);

  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: MediaQuery.of(context).size.height / 3.5,
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12), topLeft: Radius.circular(12)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Container(
                      height: 3,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'هل تريد حذف الصورة ؟',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: mainColor),
                  ),
                ),

                // for edit image and personal information
                ListTile(
                  leading: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'نعم إحذف الصورة',
                    style: TextStyle(
                        fontSize: 22,
                        // fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  onTap: () => {
                    Navigator.of(context).pop(),
                    cubit.deleteImageFromWork(id: uid)
                  },
                ),


                // for add picture to work gallery
                ListTile(
                  leading: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                  title: const Text(
                    'لا',
                    style: TextStyle(
                        fontSize: 22,
                        //fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  onTap: () => {
                    Navigator.of(context).pop()
                  },
                ),
              ],
            ),
          ),
        );
      });
}
