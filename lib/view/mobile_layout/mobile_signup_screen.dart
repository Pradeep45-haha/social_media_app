import 'package:flutter/material.dart';
import 'package:instagram_mmvm_dp_clone/config/colors.dart';
import 'package:instagram_mmvm_dp_clone/view/mobile_layout/mobile_login_screen.dart';
import 'package:instagram_mmvm_dp_clone/view_model/bloc/signup_bloc/bloc/signup_bloc.dart';
import 'package:instagram_mmvm_dp_clone/view_model/bloc/ui_bloc/bloc/ui_bloc.dart';
import 'package:instagram_mmvm_dp_clone/config/widgets/text_feild_input.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view_model/bloc/login_bloc/login_bloc.dart';
import 'mobile_main_screen.dart';

class MobileSignupScreen extends StatefulWidget {
  const MobileSignupScreen({super.key});

  @override
  State<MobileSignupScreen> createState() => _MobileSignupScreenState();
}

class _MobileSignupScreenState extends State<MobileSignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  GlobalKey formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    bioController.dispose();
    userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UiBloc uiBloc = BlocProvider.of<UiBloc>(context);
    // if (uiBloc.profileImage == null) {
    //   if (uiBloc.isClosed) {
    //     debugPrint("ui bloc is closed");
    //   }
    //   debugPrint("profile image of uiBloc is null");
    // }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height < 900? 900:MediaQuery.of(context).size.height,
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
                Stack(
                  children: [
                    BlocBuilder<UiBloc, UiState>(
                      builder: (context, state) {
                        if (state is LoadProfilePictureState) {
                          if (state.image.isEmpty) {
                            debugPrint("Profile image is null");
                            return const CircleAvatar(
                              maxRadius: 64,
                              backgroundImage:
                                  AssetImage("assets/default_profile_pic.jpg"),
                            );
                          }
                          return CircleAvatar(
                            maxRadius: 64,
                            backgroundImage: MemoryImage(state.image),
                          );
                        }
                        return const CircleAvatar(
                          maxRadius: 64,
                          backgroundImage:
                              AssetImage("assets/default_profile_pic.jpg"),
                        );
                      },
                    ),
                    Positioned(
                      left: 80,
                      top: 90,
                      child: IconButton(
                        onPressed: () {
                          debugPrint("ui bloc called");
                          uiBloc.add(
                            ShowProfilePhotoMenuEvent(),
                          );
                          debugPrint("ui bloc call end");
                        },
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 64,
                ),
                Form(
                  key: formKey,child: Column(children: [
                TextFieldInput(
                    validator: (data) {
                      if (data!.length < 2) {
                        return "Username must be 3 chars long ";
                      }
                      return null;
                    },
                    textEditingController: userNameController,
                    hintText: "Enter your username",
                    textInputType: TextInputType.text),
                const SizedBox(
                  height: 32,
                ),
                TextFieldInput(
                    validator: (data) {
                      if (data!.isEmpty) {
                        return "Please enter your email";
                      }
                      return null;
                    },
                    textEditingController: emailController,
                    hintText: "Enter your email",
                    textInputType: TextInputType.emailAddress),
                const SizedBox(
                  height: 32,
                ),
                TextFieldInput(
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
                    textInputType: TextInputType.visiblePassword),
                const SizedBox(
                  height: 32,
                ),
                TextFieldInput(
                    validator: (data) {
                      return null;
                    },
                    textEditingController: bioController,
                    hintText: "Enter your bio",
                    textInputType: TextInputType.emailAddress),
                const SizedBox(
                  height: 32,
                ),
                ],)),
                Container(
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
                      if(formData.validate())
                      {
                      context.read<SignupBloc>().add(
                          SignupUsingEmailAndPasswordEvent(
                              email: emailController.text,
                              password: passwordController.text,
                              username: userNameController.text,
                              bio: bioController.text,
                              image: uiBloc.profileImage));
                    }
                    },
                    child: BlocConsumer<SignupBloc, SignupState>(
                      listener: (context, state)
                      {
                        if(state is EmptySignupFieldsState)
                        {
                           ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              "Please provide mandatory fields",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ));
                          return;
                        }
                        if(state is SignUpFailedState)
                        {
                           ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              "Please provide right credentials",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ));
                          return;
                        }
                        if(state is SignUpFailedUnexpState)
                        {
                           ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              "Something went wrong! Please try again",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ));
                          return;
                        }
                      },
                      builder: (context, state) {
                        if (state is SignupLoadingState) {
                          return const Text("Loading...");
                        } else if (state is SignUpSuccessState) {
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return BlocProvider.value(
                                      value: BlocProvider.of<UiBloc>(context),
                                      child: const MobileMainScreen(),
                                    );
                                  },
                                ),
                                (route) => false,
                              );
                            },
                          );
                        }
                        return const Text("SignUp");
                      },
                    ),
                  ),
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
                      child: const Text("Already have an account ?"),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) {
                              return MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(
                                    value: BlocProvider.of<UiBloc>(context),
                                  ),
                                  BlocProvider.value(
                                    value: BlocProvider.of<SignupBloc>(context),
                                  ),
                                  BlocProvider.value(
                                    value: BlocProvider.of<LoginBloc>(context),
                                  ),
                                ],
                                child: const MobileLoginScreen(),
                              );
                            },
                          ),
                          (route) => false,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: const Text(
                          "   Login",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
