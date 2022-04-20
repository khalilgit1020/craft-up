
import 'package:flutter/material.dart';

import '../bloc/home_cubit.dart';
import '../constants.dart';
import '../models/craft_user_model.dart';
import '../screens/settings_screen/image_zoom_screen.dart';


Column UserInfoAndWorks(
    Size size, CraftUserModel userModel, CraftHomeCubit cubit,
    ) {
  return Column(
    children: [
      SizedBox(
        height: size.height / 8.5,
      ),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Card(
            elevation: 5,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height / 20,
                    ),
                    textUser(userModel.name, 20),
                    if(userModel.craftType != '')
                      textUser(userModel.craftType, 14),

                    textUser('${userModel.address} | ${userModel.phone}', 14),
                    textUser(userModel.email, 14),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      userModel.userType!
          ? Expanded(

          child: RefreshIndicator(
            onRefresh: () {
              return cubit.getMyWorkImages();
            },
            child: cubit.myWorkGallery.isNotEmpty
                ? GridView.builder(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 2),
              gridDelegate:
              const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 3,
                crossAxisSpacing: 18,
                mainAxisSpacing: 14,
              ),
              itemCount: cubit.myWorkGallery.length,
              itemBuilder: (context, index) {
                var url = cubit.myWorkGallery[index]['image'];

                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ImageZoomScreen(
                          tag: index.toString(),
                          url: url,
                        )));
                  },
                  child: Hero(
                    tag: index.toString(),
                    child: Image.network(
                      '$url',
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              },
            )
                : Center(
              child: Text(
                'لا يوجد لديك صور في معرضك الخاص, أضف بعض الصور...',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ))
          : Expanded(
        child: Center(
          child: Stack(
            children: [
              Align(
                alignment: const Alignment(-2, -0.7),
                child: Image.asset('assets/images/profile2.png'),
              ),
              Align(
                alignment: const Alignment(0, -1),
                child: Image.asset('assets/images/profile.png'),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}


Center textUser(userModel, double size) {
  return Center(
    child: Text(
      userModel,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),

    ),
  );
}


Column UserPicture(context,Size size, CraftUserModel userModel) {
  return Column(
    children: [
      SizedBox(
        height: size.height / 16,
      ),
      Center(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 4, color: Colors.blue.shade200),
          ),
          child: InkWell(
            onTap:(){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ImageZoomScreen(
                    tag: 'profile'.toString(),
                    url: userModel.image!,
                  )));
            } ,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(userModel.image!),

            ),
          ),
        ),
      ),
    ],
  );
}

