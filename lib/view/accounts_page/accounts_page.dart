import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_mmvm_dp_clone/view_model/bloc/logout_bloc/logout_bloc.dart';
import 'package:instagram_mmvm_dp_clone/view_model/bloc/ui_bloc/bloc/ui_bloc.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    LogoutBloc logoutBloc = BlocProvider.of<LogoutBloc>(context);
    UiBloc uiBloc = BlocProvider.of<UiBloc>(context);
    uiBloc.add(GetUserProfileEvent());
    return BlocListener<LogoutBloc, LogoutState>(
      listener: (context, state) {
        if (state is UserLoggedOutState) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/login', (route) => false);
        }
        if (state is UserLogoutFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Logout Failed", textAlign: TextAlign.center),
            ),
          );
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: UserDetails(),
            ),
            Center(
              child: TextButton(
                  onPressed: () {
                    logoutBloc.add(
                      UserWantToLogoutEvent(),
                    );
                  },
                  child: const Text("Logout")),
            ),
          ],
        ),
      ),
    );
  }
}

class UserDetails extends StatelessWidget {
  const UserDetails({super.key});

  @override
  Widget build(BuildContext context) {
    UiBloc uiBloc = BlocProvider.of<UiBloc>(context);
    return BlocBuilder<UiBloc, UiState>(
      builder: (context, state) {
        if (state is GotUserDetailsState) {
          return Container(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0,bottom: 12.0,right: 12.0),
                      child: CircleAvatar(
                        maxRadius: 36,
                        backgroundImage: NetworkImage(
                          uiBloc.currentUserDetails!.photoUrl,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                      ),
                      child: Text(
                        uiBloc.currentUserDetails!.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        uiBloc.currentUserDetails!.bio,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Flex(
                  
                    mainAxisSize: MainAxisSize.max,
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${(uiBloc.currentUserPostCount.toString())} posts",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${0.toString()} followers",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${uiBloc.currentUserFollowingCount.toString()} following",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
