import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/bloc/home_cubit.dart';
import 'package:graduation/constants.dart';
import 'package:graduation/models/craft_user_model.dart';
import 'package:graduation/screens/chat/chat_details.dart';

import '../bloc/craft_states.dart';
import '../widgets/user_info_and_works.dart';
import 'settings_screen/image_zoom_screen.dart';

class OtherUserProfile extends StatelessWidget {
  final CraftUserModel userModel;

  OtherUserProfile({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => CraftHomeCubit()..getOtherWorkImages(id: userModel.uId),
      child: BlocConsumer<CraftHomeCubit, CraftStates>(
        listener: (context, state) {},
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
                  userInfoAndWorks(size, userModel, cubit, context),

                  // for user picture
                  userPicture(context, size, userModel),

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

  Column userPicture(context, Size size, CraftUserModel userModel) {
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
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ImageZoomScreen(
                          tag: 'profile 1'.toString(),
                          url: userModel.image!,
                        )));
              },
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

  Column userInfoAndWorks(
    Size size,
    CraftUserModel userModel,
    CraftHomeCubit cubit,
    BuildContext context,
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
                      if (userModel.craftType != '')
                        textUser(userModel.craftType, 14),
                      textUser('${userModel.address} | ${userModel.phone}', 14),
                      textUser(userModel.email, 14),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          CraftHomeCubit.get(context)
                              .getMessage(receiverId: userModel.uId!);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ChatDetailsScreen(userModel: userModel)));
                        },
                        child: Container(
                          width: size.width / 4.5,
                          height: size.height / 25,
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Text(
                              'مراسلة',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
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
                child: RefreshIndicator(
                onRefresh: () {
                  return cubit.getOtherWorkImages(id: userModel.uId);
                },
                child: cubit.otherWorkGallery.isNotEmpty
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
                      )
                    : Center(
                        child: Text(
                          'لا يوجد لديه صور في معرضه الخاص بعد',
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
}
