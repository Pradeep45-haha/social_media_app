import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_mmvm_dp_clone/config/colors.dart';
import 'package:instagram_mmvm_dp_clone/view_model/bloc/ui_bloc/bloc/ui_bloc.dart';

import '../../config/widgets/comment_card.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UiBloc uiBloc = BlocProvider.of<UiBloc>(context);
    String userImage = "";
    String userName = "";
    bool isImageNetwork = false;

    return BlocBuilder<UiBloc, UiState>(
      builder: (context, state) {
        if (state is GettingUserProfileState) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (uiBloc.currentUserDetails == null) {
          userImage = "assets/default_profile_pic.jpg";
        } else {
          userImage = uiBloc.currentUserDetails!.photoUrl;
          isImageNetwork = true;
        }

        userName = uiBloc.currentUserDetails!.userName;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            title: const Text("Comments"),
            centerTitle: false,
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .doc(uiBloc.selectedPostForComment!['postId'])
                .collection('comments')
                .orderBy("datePublished", descending: true)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: ((context, index) {
                  uiBloc.mapOfCommentSnap[Key(index.toString())] =
                      snapshot.data!.docs[index];
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: CommentCard(
                      key: Key(
                        index.toString(),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              height: kToolbarHeight,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: isImageNetwork == true
                        ? NetworkImage(userImage)
                        : AssetImage(userImage) as ImageProvider,
                    radius: 18,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 8.0,
                      ),
                      child: TextField(
                        controller: commentController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Comment as $userName",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      child: TextButton(
                        onPressed: () {
                          BlocProvider.of<UiBloc>(context).add(
                            PostCommentEvent(
                              comment: commentController.text,
                              postId: uiBloc.selectedPostForComment!["postId"],
                              profileImageUrl: uiBloc.currentUserDetails!.photoUrl,
                              uid: uiBloc.selectedPostForComment!["uid"],
                              userName: uiBloc.currentUserDetails!.userName
                            ),
                          );
                          Navigator.of(context).pop();
                          commentController.clear();
                        },
                        child: const Text(
                          "Post",
                          style: TextStyle(color: blueColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
