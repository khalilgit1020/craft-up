import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/craft_states.dart';

import '../models/craft_user_model.dart';

class CraftRegisterCubit extends Cubit<CraftStates> {
  CraftRegisterCubit() : super(CraftInitialState());

  static CraftRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
    required String craftType,
    required bool userType,
  }) {
    emit(CraftRegisterLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      createUser(
        name: name,
        email: email,
        phone: phone,
        address: address,
        uId: value.user!.uid,
        craftType: craftType,
        userType: userType,
      );

      print(value.user!.email);
      print(value.user!.uid);

      emit(CraftRegisterSuccessState(value.user!.uid));

    }).catchError((error) {
      emit(CraftRegisterErrorState(error.toString()));
    });
  }

  void createUser({
    required String name,
    required String email,
    required String phone,
    required String uId,
    required String address,
    required String craftType,
    required bool userType,
  }) async{
    CraftUserModel model = CraftUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      address: address,
      image: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fd/000080_Navy_Blue_Square.svg/2048px-000080_Navy_Blue_Square.svg.png',
      craftType: craftType,
      userType: userType,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
    //  emit(CraftCreateUserSuccessState());
    }).catchError((error) {
      emit(CraftCreateUserErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ShopRegisterChangePasswordVisibilityState());
  }

  bool isCrafter = true;

  makeIsCrafterTrue() {
    isCrafter = true;
    emit(ConvertUserTypeSuccessState());
  }

  makeIsCrafterFalse() {
    isCrafter = false;
    emit(ConvertUserTypeSuccessState());
  }
}
