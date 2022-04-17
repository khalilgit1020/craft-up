import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/bloc/home_cubit.dart';
import 'package:graduation/models/craft_user_model.dart';

import '../../bloc/craft_states.dart';
import '../../constants.dart';
import 'chat_details.dart';

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
