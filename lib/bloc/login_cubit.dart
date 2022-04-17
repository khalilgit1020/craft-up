import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/craft_states.dart';
//import '../constatnts.dart';

class CraftLoginCubit extends Cubit<CraftStates> {
  CraftLoginCubit() : super(CraftInitialState());

  static CraftLoginCubit get(context) => BlocProvider.of(context);

  void userLogin({
    required String? email,
    required String? password,
  }) {
    emit(CraftLoginLoadingState());

    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    ).then((value) {

      print(value.user!.email);
      print(value.user!.uid);
      emit(CraftLoginSuccessState(value.user!.uid));
    }).catchError((error){
      emit(CraftLoginErrorState(error.toString()));
    });
  }

  IconData suffixIcon = Icons.visibility_outlined;
  bool isPasswordShown = true;

  void changePasswordVisibility() {
    isPasswordShown = !isPasswordShown;

    suffixIcon = isPasswordShown
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(CraftChangePasswordVisibilityState());
  }
}
