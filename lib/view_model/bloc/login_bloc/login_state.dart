part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {}

class LoginFailedState<T> extends LoginState {
  final T faliureData;
  LoginFailedState({required this.faliureData});
}

class EmptyLoginFieldsState extends LoginState {
  EmptyLoginFieldsState();
}

class LoginFailedUnexpState<T> extends LoginState{
   final T faliureData;
  LoginFailedUnexpState({required this.faliureData});
}