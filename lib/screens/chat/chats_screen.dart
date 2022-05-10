import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/bloc/home_cubit.dart';
import 'package:graduation/models/craft_user_model.dart';

import '../../bloc/craft_states.dart';
import '../../constants.dart';
import 'chat_details.dart';

/*
class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {},
      builder: (context, state) {

        var cubit = CraftHomeCubit.get(context);

       // cubit.getUsersChatList();

        return SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: mainColor,
                    width: size.width,
                    height: size.width / 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'الرسائل',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.arrow_forward_ios),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  cubit.users!.isNotEmpty
                      ? Expanded(
                        child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) =>
                                buildChatItem(cubit.users![index], context),
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: cubit.users!.length,
                          ),
                      )
                      : const Expanded(
                          child: Center(
                            child: Text(
                              'لا يوجد لديك مراسلات حتى الأن...',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18),
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

  Widget buildChatItem(CraftUserModel model, context) {
    return InkWell(
      onTap: () {
         Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ChatDetailsScreen(userModel: model)));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                '${model.image}',
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Text('${model.name}'),
          ],
        ),
      ),
    );
  }
}
*/

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = CraftHomeCubit.get(context);

        // cubit.getUsersChatList();

        return SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(size.height / 8),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  flexibleSpace: FadeIn(
                    duration: const Duration(milliseconds: 100),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'المحادثات',
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
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    cubit.usersMessenger!.isNotEmpty
                        ? Expanded(
                            child: FadeIn(
                              child: ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) => buildChatItem(
                                    cubit.usersMessenger![index], context, cubit),
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                  height: 30,
                                ),
                                itemCount: cubit.usersMessenger!.length,
                              ),
                            ),
                          )
                        : Expanded(
                            child: FadeIn(
                              child: const Center(
                                child: Text(
                                  'لا يوجد لديك مراسلات حتى الأن...',
                                  style:
                                      TextStyle(color: Colors.grey, fontSize: 18),
                                ),
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

  Widget buildChatItem(CraftUserModel model, context, CraftHomeCubit cubit) {
    return InkWell(
      onTap: () {
        cubit.getMessage(receiverId: model.uId!);
        cubit.getOtherLocation(userId: model.uId!);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChatDetailsScreen(userModel: model)));
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            child: ClipRRect(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              borderRadius: BorderRadius.circular(50.0),
              child: CachedNetworkImage(
                height: double.infinity,
                width: 70,
                imageUrl: model.image!,
                placeholder: (context, url) => CircleAvatar(
                  radius: 35.0,
                  backgroundColor: Colors.grey[300],
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            '${model.name}',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
