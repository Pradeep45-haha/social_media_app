import 'package:bloc/bloc.dart';
import 'package:instagram_mmvm_dp_clone/config/data.dart';
import 'package:instagram_mmvm_dp_clone/config/error_const.dart';
import 'package:instagram_mmvm_dp_clone/data/network_services/login.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      if (event is LoginInitialEvent) {
        emit(LoginInitial());
      }
      if (event is LoginUsingEmailAndPasswordEvent) {
        emit.call(LoginLoadingState());
        AuthMethodsLogin authLogin = AuthMethodsLogin();
        Data data = await authLogin.loginUser(
          email: event.email,
          password: event.password,
        );
        if (data is SuccessData) {
          emit(LoginSuccessState());
          return;
        }
        if (data is FailureData) {
          CError faliureData = data.failureData!;
          if (faliureData.errorType == ErrorType.emptyCredentialsError) {
            emit(EmptyLoginFieldsState());
            return;
          }
          if (faliureData.errorType == ErrorType.authError) {
            emit(LoginFailedState(faliureData: data.failureData));
            return;
          }
          if (faliureData.errorType == ErrorType.genericError) {
            emit(LoginFailedUnexpState(faliureData: data.failureData));
            return;
          }
          return;
        }
      }
    });
  }
}
