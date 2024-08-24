import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_mmvm_dp_clone/view_model/bloc/ui_bloc/bloc/ui_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UiBloc? uiBloc;
  @override
  void initState() {
    uiBloc = BlocProvider.of<UiBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UiBloc, UiState>(
      builder: (context, state) {
        if (state is GotOtherUserProfileDetailsState) {
          return const Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: UserDetails(),
                ),
              ],
            ),
          );
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class UserDetails extends StatelessWidget {
  const UserDetails({super.key});

  @override
  Widget build(BuildContext context) {
    UiBloc uiBloc = BlocProvider.of<UiBloc>(context);
    return Container(
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 12.0, right: 12.0, bottom: 12.0),
                child: CircleAvatar(
                  maxRadius: 36,
                  backgroundImage:
                      NetworkImage(uiBloc.othersUserDetails!.photoUrl),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: Text(
                  uiBloc.othersUserDetails!.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  uiBloc.othersUserDetails!.bio,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      uiBloc.otherUserFollowingCount == null
                          ? "0 following"
                          : "${uiBloc.otherUserFollowingCount} following",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "0 followers",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      uiBloc.otherUserPostCount == null
                          ? "0 posts"
                          : "${uiBloc.otherUserPostCount} posts",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              TextButton(
                
                onPressed: () {
                  if ((uiBloc.isCurrentUserFollowingThisUser[
                              uiBloc.othersUserDetails!.uid] ==
                          null) ||
                      uiBloc.isCurrentUserFollowingThisUser[
                              uiBloc.othersUserDetails!.uid] ==
                          false) {
                    uiBloc.add(
                      AddUserToFollowingListEvent(
                        userId: uiBloc.othersUserDetails!.uid,
                      ),
                    );
                  } else {
                    uiBloc.add(RemoveUserFromFollowingListEvent(
                        userId: uiBloc.othersUserDetails!.uid));
                  }
                },
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      color: Colors.blue),
                  width: MediaQuery.of(context).size.width * .40,
                  height: 30,
                  child: Center(child: BlocBuilder<UiBloc, UiState>(
                    builder: (context, state) {
                      return Text(
                        uiBloc.isCurrentUserFollowingThisUser[
                                    uiBloc.othersUserDetails!.uid] ==
                                true
                            ? "Unfollow"
                            : "Follow",
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      );
                    },
                  )),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
