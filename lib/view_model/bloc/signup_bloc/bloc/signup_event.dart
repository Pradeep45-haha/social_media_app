part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent {}

class SignupUsingEmailAndPasswordEvent extends SignupEvent {
  final String email;
  final String password;
  final String username;
  final String bio;
  final Uint8List? image;
  SignupUsingEmailAndPasswordEvent({required this.image, 
    
    required this.username,
    required this.bio, 
    required this.email,
    required this.password,
  });
}
