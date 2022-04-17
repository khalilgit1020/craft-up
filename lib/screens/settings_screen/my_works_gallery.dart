import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/widgets/styles/icon_broken.dart';

import '../../bloc/craft_states.dart';
import '../../bloc/home_cubit.dart';
import '../../constants.dart';
import '../../widgets/bottom_sheet_deleteImage.dart';
import '../../widgets/show_taost.dart';



class MyWorksGallery extends StatelessWidget {
  const MyWorksGallery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    final size = MediaQuery.of(context).size;

    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {

        // CraftChangeBottomNavState
        if (state is CraftChangeBottomNavState){
          CraftHomeCubit().getMyWorkImages();
        }

        if (state is CraftUploadWorkImageSuccessState) {
          showToast(
            state: ToastState.SUCCESS,
            msg: 'تم إضافة الصورة بنجاح الى معرض اعمالك',
          );

          CraftHomeCubit.get(context).getMyWorkImages();

        }

        if (state is CraftDeleteWorkImageSuccessState) {
          showToast(
            state: ToastState.SUCCESS,
            msg: 'تم حذف الصورة بنجاح من معرض اعمالك',
          );

          CraftHomeCubit.get(context).getMyWorkImages();

        }

      },
      builder: (context, state) {

        var userModel = CraftHomeCubit.get(context).UserModel!;
        var cubit = CraftHomeCubit.get(context);

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
                      height: size.width / 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'معرض أعمالي',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                   cubit.getWorkImage();
                                },
                                icon:const Icon(Icons.add_a_photo_outlined),
                                color: Colors.white,
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon:const Icon(Icons.arrow_forward_ios),
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),


                    if(state is CraftUploadWorkImageLoadingState)
                      const CircularProgressIndicator.adaptive(),

                    Expanded(
                      child:cubit.myWorkGallery.isNotEmpty ?
                      RefreshIndicator(
                        onRefresh: (){
                          return cubit.getMyWorkImages();
                        },
                        child: GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 2),
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 3 / 3,
                            crossAxisSpacing: 18,
                            mainAxisSpacing: 14,
                          ),
                          itemCount: cubit.myWorkGallery.length,
                          itemBuilder: (context, index) {

                            var url = cubit.myWorkGallery[index]['image'];

                            return InkWell(
                              onLongPress:() {
                                deleteImageModalBottomSheet(context, cubit.myWorkGallery[index]['id']);
                              },
                              onTap:() {
                              },
                              child: Image.network(
                                '$url',
                                fit: BoxFit.fill,
                              ),
                            );
                          },
                        ),
                      ) :
                      Center(
                        child: Text(
                          'لا يوجد لديك صور في معرضك الخاص, أضف بعض الصور...',style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: mainColor
                        ),
                          textAlign: TextAlign.center,
                        ),
                      )
                      ,
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