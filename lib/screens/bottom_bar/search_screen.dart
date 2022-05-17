import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/craft_states.dart';
import '../../bloc/home_cubit.dart';
import '../../constants.dart';
import '../../models/post_model.dart';
import '../../widgets/my_divider.dart';
import '../../widgets/styles/icon_broken.dart';
import '../other_user_profile.dart';
import '../post/post_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var searchController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {},
      builder: (context, state) {
        // CraftHomeCubit().getMyWorkImages();

        var cubit = CraftHomeCubit.get(context);

        return SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(size.height / 8),
                child: AppBar(
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Center(
                      child: FadeIn(
                        duration: const Duration(milliseconds: 100),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 0.1,
                                blurRadius: 4,
                                offset:
                                    Offset(0, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: searchController,
                            keyboardType: TextInputType.text,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'Please enter key word to search';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if (!RegExp(r'^[ ]*$').hasMatch(value)) {
                                cubit.getSearch(text: value);
                              } else {
                                cubit.clearSearchList();
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: InkWell(
                                onTap: () {
                                  cubit.getSearch(text: searchController.text);
                                },
                                child: Icon(
                                  IconBroken.Filter,
                                  color: mainColor,
                                ),
                              ),
                              //  label: Text('البريد الالكتروني'),
                              prefixIcon: const Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  backgroundColor: mainColor,
                ),
              ),
              body: Column(
                children: [
                  if ((state is CraftClearSearchListState &&
                          cubit.search!.isNotEmpty) ||
                      (cubit.search!.isNotEmpty &&
                          state is NewsSearchLoadingStates))
                    Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: mainColor,
                        ),
                      ),
                    ),
                  if (state is CraftSearchSuccessStates &&
                      state is! CraftClearSearchListState)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: cubit.search!.length,
                                separatorBuilder: (context, index) =>
                                    MyDivider(),
                                itemBuilder: (context, index) {
                                  return buildPost(
                                    context: context,
                                    model: cubit.search![index],
                                    cubit: cubit,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (cubit.search!.isEmpty &&
                      state is! NewsSearchLoadingStates)
                    Expanded(
                      child: Center(
                        child: FadeIn(
                          duration: const Duration(milliseconds: 100),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'لا توجد نتائج بحث حتى الآن',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(fontSize: 17, height: 1),
                              ),
                              Text(
                                'أدخل كلمة مفتاحية لبدأ البحث',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(fontSize: 14, height: 1.3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (state is NewsSearchLoadingStates && cubit.search!.isEmpty)
                    Expanded(
                      child: Center(
                        child: FadeIn(
                          duration: const Duration(milliseconds: 100),
                          child: Text(
                            'لم يتم العثور على نتائج',
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(fontSize: 17, height: 1),
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

  Widget buildPost({
    required BuildContext context,
    required PostModel model,
    required CraftHomeCubit cubit,
  }) {
    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        cubit.getComments(postId: model.postId);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => PostScreen(model: model)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          // name and photo of user
          Row(
            children: [
              InkWell(
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  cubit.getOtherWorkImages(id: model.uId).then((value) {
                    if (model.uId == cubit.UserModel!.uId) {
                      cubit.changeBottomNv(3);
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => OtherUserProfile(
                              userModel: cubit.specialUser![model.uId]!)));
                    }
                  });
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: mainColor,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: CachedNetworkImage(
                      height: double.infinity,
                      width: double.infinity,
                      imageUrl: model.image!,
                      placeholder: (context, url) => CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Colors.grey[300],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  cubit.getOtherWorkImages(id: model.uId).then((value) {
                    if (model.uId == cubit.UserModel!.uId) {
                      cubit.changeBottomNv(3);
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => OtherUserProfile(
                              userModel: cubit.specialUser![model.uId]!)));
                    }
                  });
                },
                child: Text(
                  model.name!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),

          const SizedBox(
            height: 10,
          ),

          // post text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Text(
              model.text!,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
          ),

          // post details
          Card(
            elevation: 5,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shadowColor: Colors.grey[100],
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.only(
                          right: 20.0, top: 20, bottom: 20, left: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Text(
                              model.jobName!,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on_sharp),
                              const SizedBox(width: 8),
                              Text(
                                model.location!,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.attach_money_sharp),
                              const SizedBox(width: 8),
                              Text(
                                model.salary!,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (cubit.isCrafter)
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {
                        cubit.savePost(postId: model.postId);
                      },
                      icon: cubit.mySavedPostsId!
                              .any((element) => element == model.postId)
                          ? Icon(
                              Icons.bookmark_sharp,
                              color: mainColor,
                            )
                          : const Icon(Icons.bookmark_outline_sharp),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
