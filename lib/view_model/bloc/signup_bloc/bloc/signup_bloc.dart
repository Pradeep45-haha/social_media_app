import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:instagram_mmvm_dp_clone/config/data.dart';
import 'package:instagram_mmvm_dp_clone/config/error_const.dart';
import 'package:instagram_mmvm_dp_clone/data/network_services/signup.dart';


part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    on<SignupEvent>(
      (event, emit) async {
        if (event is SignupUsingEmailAndPasswordEvent) {
          emit.call(SignupLoadingState());
          AuthMethodsSignup signupMethod = AuthMethodsSignup();
          Data data = await signupMethod.signupUser(
              email: event.email,
              file: event.image,
              password: event.password,
              username: event.username,
              bio: event.bio);
          if (data is SuccessData) {
            emit.call(SignUpSuccessState());
            return;
          }
          if (data is FailureData) {
            CError faliureData = data.failureData!;
            if (faliureData.errorType == ErrorType.authError) {
              emit.call(SignUpFailedState());
              return;
            }

            if (faliureData.errorType == ErrorType.emptyCredentialsError) {
              emit.call(EmptySignupFieldsState());
              return;
            }
            if (faliureData.errorType == ErrorType.genericError) {
              emit.call(SignUpFailedUnexpState());
              return;
            }
            return;
          }
        }
      },
    );
  }
}
