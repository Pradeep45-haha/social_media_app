import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_mmvm_dp_clone/config/colors.dart';
import 'package:instagram_mmvm_dp_clone/config/test_user.dart';
import 'package:instagram_mmvm_dp_clone/view/mobile_layout/mobile_main_screen.dart';
import 'package:instagram_mmvm_dp_clone/view/mobile_layout/mobile_signup_screen.dart';
import 'package:instagram_mmvm_dp_clone/view_model/bloc/login_bloc/login_bloc.dart';
import 'package:instagram_mmvm_dp_clone/config/widgets/text_feild_input.dart';

import '../../view_model/bloc/ui_bloc/bloc/ui_bloc.dart';

class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({super.key});

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height < 600
                ? 600
                : MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                const Image(
                  image: AssetImage("assets/instagram_text.jpg"),
                  height: 128,
                  fit: BoxFit.fitHeight,
                ),
                const SizedBox(
                  height: 64,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 0.0),
                        child: TextFieldInput(
                          validator: (data) {
                            if (data!.isEmpty) {
                              return "Please enter your email";
                            }
                            return null;
                          },
                          textEditingController: emailController,
                          hintText: "Enter your email",
                          textInputType: TextInputType.emailAddress,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 0.0),
                        child: TextFieldInput(
                          validator: (data) {
                            if (data!.isEmpty) {
                              return "Please enter your password";
                            }
                            if (data.length < 8) {
                              return "Password must be 8 chars long";
                            }
                            return null;
                          },
                          textEditingController: passwordController,
                          hintText: "Enter your password",
                          isPass: true,
                          textInputType: TextInputType.visiblePassword,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 0.0),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: const ShapeDecoration(
                        color: blueColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          dynamic formData = formKey.currentState!;
                          if (formData.validate()) {
                            context.read<LoginBloc>().add(
                                  LoginUsingEmailAndPasswordEvent(
                                      email: emailController.text,
                                      password: passwordController.text),
                                );
                          }
                        },
                        child: BlocConsumer<LoginBloc, LoginState>(
                          listener: (context, state) {
                            if (state is EmptyLoginFieldsState) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                  "Please provide email and password",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ));
                              return;
                            }
                            if (state is LoginFailedState) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                  "Please provide correct credentials",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ));
                              return;
                            }
                            if (state is LoginFailedUnexpState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Something went wrong",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                              return;
                            }
                          },
                          builder: (context, state) {
                            if (state is LoginLoadingState) {
                              return const Text("Loading...");
                            } else if (state is LoginSuccessState) {
                              WidgetsBinding.instance.addPostFrameCallback(
                                (_) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) {
                                        return BlocProvider.value(
                                          value:
                                              BlocProvider.of<UiBloc>(context),
                                          child: const MobileMainScreen(),
                                        );
                                      },
                                    ),
                                    (route) => false,
                                  );
                                },
                              );
                            }

                            return const Text("Login");
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 0.0),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: const ShapeDecoration(
                        color: blueColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          context.read<LoginBloc>().add(
                           LoginUsingEmailAndPasswordEvent(
                              email: TestUser.email,
                              password: TestUser.password));
                        },
                        child: BlocConsumer<LoginBloc, LoginState>(
                          listener: (context, state) {
                            if (state is EmptyLoginFieldsState) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                  "Please provide email and password",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ));
                              return;
                            }
                            if (state is LoginFailedState) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                  "Please provide correct credentials",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ));
                              return;
                            }
                            if (state is LoginFailedUnexpState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Something went wrong",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                              return;
                            }
                          },
                          builder: (context, state) {
                            if (state is LoginLoadingState) {
                              return const Text("Loading...");
                            } else if (state is LoginSuccessState) {
                              WidgetsBinding.instance.addPostFrameCallback(
                                (_) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) {
                                        return BlocProvider.value(
                                          value:
                                              BlocProvider.of<UiBloc>(context),
                                          child: const MobileMainScreen(),
                                        );
                                      },
                                    ),
                                    (route) => false,
                                  );
                                },
                              );
                            }

                            return const Text("As Test User");
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: const Text("Don't have an account ?"),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) {
                              return const MobileSignupScreen();
                            },
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: const Text(
                          "   Sign up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
