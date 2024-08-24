import 'package:bloc/bloc.dart';
import 'package:instagram_mmvm_dp_clone/data/network_services/logout.dart';
import 'package:instagram_mmvm_dp_clone/view_model/bloc/login_bloc/login_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LoginBloc loginBloc ;
  LogoutBloc({required this.loginBloc}) : super(LogoutInitial()) {
    on<LogoutEvent>((event, emit) async {
      if (event is UserWantToLogoutEvent) {
        AuthMethodLogout authMethodLogout = AuthMethodLogout();
        bool userLogout = await authMethodLogout.logout();
        if (userLogout) {
          emit(UserLoggedOutState());
          loginBloc.add(LoginInitialEvent());
          return;
        }
        emit(UserLogoutFailedState());
      }
    });
  }
}
