
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/craft_states.dart';
import '../../bloc/home_cubit.dart';
import '../../constants.dart';
import '../../widgets/show_taost.dart';

class WriteSuggetion extends StatelessWidget {
   WriteSuggetion({Key? key}) : super(key: key);


  var suggestionController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return BlocConsumer<CraftHomeCubit,CraftStates>(
      listener:(context, state){

        if (state is CraftWriteSuggestionSuccessState ) {

          showToast(
            state: ToastState.SUCCESS,
            msg: 'تم تسجيل إرسال اقتراحك بنجاح',
          );
        }


      }  ,
      builder:(context, state){


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
                          'سجل اقتراحك',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child:
                    Container(
                      width: size.width / 1.05,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 0.1,
                            blurRadius: 4,
                            offset: Offset(
                                0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextFormField(
                        maxLines: null,
                        minLines: 12,
                        controller: suggestionController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'تأكد من إدخال اقتراح جيد';
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: 'أدخل محتوى الاقتراح',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 15,
                  ),
                  MaterialButton(
                    minWidth: size.width /1.4,
                    height: 55,
                    color: mainColor,
                    onPressed:(){
                      var date = DateTime.now();
                      cubit.writeSuggestion(
                        date: date.toString(),
                        content: suggestionController.text,
                        uId: cubit.UserModel!.uId,
                      );
                    },
                    child:const Text('إرسال',style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                ],
              ),

            ),
          ),
        );


      } ,
    );
  }
}


