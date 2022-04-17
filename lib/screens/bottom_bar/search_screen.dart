import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/craft_states.dart';
import '../../bloc/home_cubit.dart';
import '../../constants.dart';
import '../../widgets/build_post.dart';
import '../../widgets/my_divider.dart';
import '../../widgets/styles/icon_broken.dart';

class SearchsScreen extends StatelessWidget {

  SearchsScreen({Key? key}) : super(key: key);

  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {


    var size = MediaQuery.of(context).size;


    return BlocConsumer<CraftHomeCubit, CraftStates>(
      listener: (context, state) {},
      builder: (context, state) {

       // CraftHomeCubit().getMyWorkImages();

        var cubit = CraftHomeCubit.get(context);

        return
          SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: Column(
                  children: [
                    Container(
                      height: size.height / 8,
                      padding:const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
                      decoration: BoxDecoration(
                        color: mainColor,
                      ),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow:const [
                              BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 0.1,
                                blurRadius: 4,
                                offset: Offset(0, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: searchController,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {

                              cubit.getSearch(text: value);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'خانة البحث فارغة';
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: InkWell(
                                onTap: (){
                                  cubit.getSearch(text: searchController.text);
                                },
                                  child: Icon(IconBroken.Filter,color: mainColor,),
                              ),
                                    //  label: Text('البريد الالكتروني'),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                    ),

                    cubit.search.isEmpty ?
                    const Expanded(
                      child:  Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    )
                        :
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20,),
                              ListView.separated(
                                shrinkWrap: true,
                                physics:const NeverScrollableScrollPhysics(),
                                itemCount: cubit.search.length,
                                separatorBuilder: (context,index)=> MyDivider(),
                                itemBuilder:(context,index){
                                  return BuildPost(
                                    model: cubit.search[index],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
          );
      },
    );
  }
}

