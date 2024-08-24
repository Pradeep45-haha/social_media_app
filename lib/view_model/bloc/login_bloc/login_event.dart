part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}
class LoginInitialEvent extends LoginEvent{
  
}

class LoginUsingEmailAndPasswordEvent extends LoginEvent {
  final String email;
  final String password;
  LoginUsingEmailAndPasswordEvent({required this.email, required this.password});
}
