import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/bloc/craft_states.dart';
import 'package:bloc/bloc.dart';


class CraftResetPasswordCubit extends Cubit<CraftStates> {

  CraftResetPasswordCubit() : super(CraftInitialState());

  static CraftResetPasswordCubit get(context) => BlocProvider.of(context);

  resetPassword({
    String? email,
}){

    emit(CraftResetPasswordLoadingState());

    FirebaseAuth.instance.sendPasswordResetEmail(email: email!).then((value) {

      emit(CraftResetPasswordSuccessState());

    }).catchError((error){
      emit(CraftResetPasswordErrorState(error.toString()));
    });



  }


}