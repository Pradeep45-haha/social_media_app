part of 'logout_bloc.dart';

@immutable
sealed class LogoutState {}

final class LogoutInitial extends LogoutState {}

class
 UserLoggedOutState extends LogoutState {}

class UserLogoutFailedState extends LogoutState {}