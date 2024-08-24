import 'package:instagram_mmvm_dp_clone/view/mobile_layout/mobile_login_screen.dart';
import 'package:instagram_mmvm_dp_clone/view/mobile_layout/mobile_main_screen.dart';
import 'package:instagram_mmvm_dp_clone/view/mobile_layout/mobile_signup_screen.dart';

final appRoutes = {
  
  '/login': (context) => const MobileLoginScreen(),
  '/signup': (context) => const MobileSignupScreen(),
  '/main': (context) => const MobileMainScreen(),
};
