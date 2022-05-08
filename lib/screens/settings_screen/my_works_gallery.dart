import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:graduation/screens/settings_screen/image_zoom_screen.dart';
import 'package:graduation/widgets/styles/icon_broken.dart';

import '../../bloc/craft_states.dart';
import '../../bloc/home_cubit.dart';
import '../../constants.dart';
import '../../widgets/bottom_sheet_deleteImage.dart';

class MyWorksGallery extends StatelessWidget {
  const MyWorksGallery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {
        // CraftChangeBottomNavState

        if (state is CraftUploadWorkImageSuccessState) {
          EasyLoading.showToast('تم إضافة الصورة', toastPosition: EasyLoadingToastPosition.bottom, duration: const Duration(milliseconds: 1500));
        }

        if (state is CraftDeleteWorkImageSuccessState) {
          EasyLoading.showToast('تم حذف الصورة', toastPosition: EasyLoadingToastPosition.bottom, duration: const Duration(milliseconds: 1500));
        }
      },
      builder: (context, state) {
        var cubit = CraftHomeCubit.get(context);

        return SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(size.height / 8),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  flexibleSpace: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: const Text(
                              'معرض الأعمال',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              cubit.getWorkImage();
                            },
                            icon: const Icon(
                              Icons.add_a_photo_outlined,
                              color: Colors.white,
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
                  backgroundColor: mainColor,
                ),
              ),
              body: Column(
                children: [
                  const SizedBox(
                    height: 4,
                  ),
                  if (state is CraftUploadWorkImageLoadingState)
                    const LinearProgressIndicator(),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
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
                              onLongPress: () {
                                deleteImageModalBottomSheet(context,
                                    cubit.myWorkGallery[index]['id']);
                              },
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (_) => ImageZoomScreen(
                                              tag: index.toString(),
                                              url: url!,
                                            )));
                              },
                              child: Hero(
                                tag: index.toString(),
                                child: CachedNetworkImage(
                                  imageUrl: url!,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[300],
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.cover,
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
                                  color: mainColor),
                              textAlign: TextAlign.center,
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
}
