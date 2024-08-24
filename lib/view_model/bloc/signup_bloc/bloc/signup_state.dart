part of 'signup_bloc.dart';

@immutable
abstract class SignupState {}

class SignupInitial extends SignupState {}
class SignupLoadingState extends SignupState{}
class SignUpSuccessState extends SignupState{}
class SignUpFailedState extends SignupState{}
class EmptySignupFieldsState extends SignupState {
  EmptySignupFieldsState();
}
class SignUpFailedUnexpState extends SignupState{}

