import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/bloc/home_cubit.dart';
import 'package:graduation/constants.dart';
import 'package:graduation/models/craft_user_model.dart';
import 'package:graduation/screens/chat/chat_details.dart';

import '../bloc/craft_states.dart';
import 'settings_screen/image_zoom_screen.dart';

class OtherUserProfile extends StatelessWidget {
  final CraftUserModel userModel;

  OtherUserProfile({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) =>
          CraftHomeCubit()..getOtherWorkImages(id: userModel.uId),
      child: BlocConsumer<CraftHomeCubit, CraftStates>(
        listener: (context, state) {
          CraftHomeCubit().getOtherWorkImages(id: userModel.uId);
        },
        builder: (context, state) {
          var cubit = CraftHomeCubit.get(context);

          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  // for background color
                  Container(
                    color: mainColor,
                    height: size.height / 5.5,
                  ),

                  // for information card and gallery works
                  userInfoAndWorks(size, userModel, context, cubit),

                  // for user picture
                  userPicture(size, userModel),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Column userPicture(Size size, CraftUserModel userModel) {
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
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(userModel.image!),
            ),
          ),
        ),
      ],
    );
  }

  Column userInfoAndWorks(
      Size size, CraftUserModel userModel, context, CraftHomeCubit cubit) {
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
                        height: size.height / 15,
                      ),
                      textUser(userModel.name, 20),
                      textUser(
                          userModel.craftType == ''
                              ? '${userModel.address}'
                              : '${userModel.craftType} | ${userModel.address}',
                          14),
                      textUser(userModel.phone, 14),
                      textUser(userModel.email, 14),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 22),
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ChatDetailsScreen(
                                      userModel: userModel,
                                    )));
                          },
                          child: const Text(
                            'مراسلة',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
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
                //cubit.getMyWorkImages();

                child: cubit.otherWorkGallery.isNotEmpty
                    ? RefreshIndicator(
                        onRefresh: () {
                          return cubit.getOtherWorkImages(id: userModel.uId);
                        },
                        child: GridView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 2),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 3 / 3,
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 14,
                          ),
                          itemCount: cubit.otherWorkGallery.length,
                          itemBuilder: (context, index) {
                            var url = cubit.otherWorkGallery[index]['image'];

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
                        ),
                      )
                    : Center(
                        child: Text(
                          'لا يوجد لديه صور في معرضك الخاص',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: mainColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
              )
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
        style: TextStyle(fontSize: size, fontWeight: FontWeight.bold),
      ),
    );
  }
}
