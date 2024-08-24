import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_mmvm_dp_clone/config/colors.dart';
import 'package:instagram_mmvm_dp_clone/config/const.dart';
import 'package:instagram_mmvm_dp_clone/config/routes.dart';
import 'package:instagram_mmvm_dp_clone/view/mobile_layout/mobile_login_screen.dart';
import 'package:instagram_mmvm_dp_clone/view/mobile_layout/mobile_main_screen.dart';
import 'package:instagram_mmvm_dp_clone/view_model/bloc/chat_bloc/chat_bloc.dart';
import 'package:instagram_mmvm_dp_clone/view_model/bloc/logout_bloc/logout_bloc.dart';
import 'package:instagram_mmvm_dp_clone/view_model/bloc/login_bloc/login_bloc.dart';
import 'package:instagram_mmvm_dp_clone/view_model/bloc/ui_bloc/bloc/ui_bloc.dart';
import 'view_model/bloc/signup_bloc/bloc/signup_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(options: firebaseOptions);
  } else {
    await Firebase.initializeApp();
  }
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<SignupBloc>(
        create: (context) => SignupBloc(),
      ),
      BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(),
      ),
      BlocProvider<UiBloc>(
        create: (context) => UiBloc(),
      ),
      BlocProvider<LogoutBloc>(
        create: (context) => LogoutBloc(
          loginBloc: BlocProvider.of<LoginBloc>(context),
        ),
      ),
      BlocProvider<ChatBloc>(
        create: (context) => ChatBloc(
          uiBloc: BlocProvider.of<UiBloc>(context),
        ),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: appRoutes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      title: "Instagram Clone",
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          debugPrint("main page stream builder");
          if (FirebaseAuth.instance.currentUser != null) {
            debugPrint("returned mobile main screen");
            return const MobileMainScreen();
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return const MobileMainScreen();
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text(
                    snapshot.error.toString(),
                  ),
                ),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
          return const MobileLoginScreen();
        },
      ),
    );
  }
}
