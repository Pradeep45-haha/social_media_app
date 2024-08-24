import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_mmvm_dp_clone/config/colors.dart';
import 'package:instagram_mmvm_dp_clone/view/accounts_page/profile_page.dart';

import '../../../view_model/bloc/ui_bloc/bloc/ui_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          cursorColor: secondaryColor,
          autofocus: true,
          controller: searchController,
          decoration: InputDecoration(
              suffixIconColor: secondaryColor,
              fillColor: secondaryColor,
              hoverColor: secondaryColor,
              focusColor: secondaryColor,
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.search,
                ),
                onPressed: () {},
              ),
              border: InputBorder.none,
              hintText: "Search for user"),
          onChanged: (value) {
            BlocProvider.of<UiBloc>(context).add(
              ShowProfilePageEvent(),
            );
          },
        ),
      ),
      body: BlocBuilder<UiBloc, UiState>(
        builder: (context, state) {
          if (state is ShowingProfilePageState) {
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: searchController.text)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  debugPrint("snapshot has error");
                  return Text(snapshot.error.toString());
                }
                if (!snapshot.hasData) {
                  debugPrint("snapshot do not have data called");
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  debugPrint("snapshot has data called");

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          debugPrint(
                              "username is ${snapshot.data!.docs[index]["username"]}");
                          BlocProvider.of<UiBloc>(context).add(
                            GetOtherUserProfileDetailsEvent(
                              userId: snapshot.data!.docs[index]["uid"],
                            ),
                          );

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return BlocProvider.value(
                                  value: BlocProvider.of<UiBloc>(context),
                                  child: const ProfilePage(),
                                );
                              },
                            ),
                          );
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage(
                              snapshot.data!.docs[index]["photoUrl"],
                            ),
                          ),
                          title: Text(snapshot.data!.docs[index]["username"]),
                        ),
                      );
                    },
                  );
                }
                return const Text("No such user");
              },
            );
          }
          return const PostExplorer();
        },
      ),
    );
  }
}

class PostExplorer extends StatelessWidget {
  const PostExplorer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('posts').get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return StaggeredGridView.countBuilder(
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            crossAxisCount: 3,
            itemBuilder: (context, index) {
              return Image.network(
                snapshot.data!.docs[index]["postUrl"],
                fit: BoxFit.cover,
              );
            },
            itemCount: snapshot.data!.docs.length,
            staggeredTileBuilder: (index) {
              return StaggeredTile.count(
                (index % 7 == 0) ? 2 : 1,
                (index % 7 == 0) ? 2 : 1,
              );
            },
          );
        }
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return const Center(
          child: Text("No post to show here"),
        );
      },
    );
  }
}
