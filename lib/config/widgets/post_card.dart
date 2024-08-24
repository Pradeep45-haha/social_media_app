import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_mmvm_dp_clone/config/colors.dart';
import 'package:instagram_mmvm_dp_clone/view/home_page/comment_page.dart';
import 'package:instagram_mmvm_dp_clone/view_model/bloc/ui_bloc/bloc/ui_bloc.dart';
import 'package:instagram_mmvm_dp_clone/config/widgets/like_animation.dart';
import 'package:instagram_mmvm_dp_clone/config/widgets/post_save_animation.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    required super.key,
  });
  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimation = false;
  late final UiBloc uiBloc;

  @override
  void initState() {
    uiBloc = BlocProvider.of<UiBloc>(context);
    uiBloc.add(GetCommentDataEvent(
        snap: uiBloc.mapOfPostSnap[widget.key]!, key: widget.key!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool getValue() {
      uiBloc.tempAnimate[widget.key!] = false;
      return uiBloc.tempAnimate[widget.key]!;
    }

    var snap = uiBloc.mapOfPostSnap[widget.key]!;
    List<dynamic> noOfLikes =
        snap.data().toString().contains("noOfLikes") ? snap["noOfLikes"] : "";
    uiBloc.isPostLiked[widget.key!] =
        (snap.data()["noOfLikes"] as List<dynamic>)
            .contains(FirebaseAuth.instance.currentUser!.uid);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        color: mobileBackgroundColor,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(
                          // snap["profileImageUrl"],
                          snap.data().toString().contains("profileImageUrl")
                              ? snap["profileImageUrl"]
                              : ""),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 30,
                  ),
                  Text(snap.data().toString().contains("userName")
                      ? snap["userName"]
                      : ""),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  PopupMenuButton(
                    elevation: 4.0,
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          enabled: true,
                          onTap: () {
                            BlocProvider.of<UiBloc>(context).add(
                                DeletePostEvent(
                                    postId: snap
                                            .data()
                                            .toString()
                                            .contains("postId")
                                        ? snap["postId"]
                                        : ""));
                          },
                          child: const Text("Delete"),
                        ),
                        PopupMenuItem(
                          enabled: true,
                          onTap: () {},
                          child: const Text("Cancel"),
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
              ),
              child: Image(
                image: NetworkImage(
                  snap.data().toString().contains("postUrl")
                      ? snap["postUrl"]
                      : "",
                ),
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(
              child: Row(
                children: [
                  BlocBuilder<UiBloc, UiState>(
                    buildWhen: (previous, current) {
                      if (current is AnimateLikeButtonState) {
                        return current.key == widget.key;
                      }
                      return true;
                    },
                    builder: (context, state) {
                      return LikeAnim(
                        key: widget.key,
                        animateLike:
                            uiBloc.tempAnimate.containsKey(widget.key) == true
                                ? uiBloc.tempAnimate[widget.key]!
                                : getValue(),
                        isLiked: uiBloc.isPostLiked[widget.key!]!,
                        onTap: () {
                          BlocProvider.of<UiBloc>(context).add(
                            SaveLikedPostEvent(
                                key: widget.key!, postId: snap["postId"]),
                          );
                          BlocProvider.of<UiBloc>(context).add(
                            PostLikedEvent(
                                uid: FirebaseAuth.instance.currentUser!.uid
                                    .toString(),
                                postId:
                                    snap.data().toString().contains("postId")
                                        ? snap["postId"]
                                        : "",
                                key: widget.key!),
                          );
                        },
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      BlocProvider.of<UiBloc>(context)
                          .add(GetUserProfileEvent());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            BlocProvider.of<UiBloc>(context)
                                .selectedPostForComment = snap;
                            return BlocProvider.value(
                              value: BlocProvider.of<UiBloc>(context),
                              child: const CommentPage(),
                            );
                          },
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.comment_outlined,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  IconButton(
                    onPressed: () {
                      uiBloc.add(
                        SavePostEvent(
                          key: widget.key!,
                          postId: snap["postId"],
                        ),
                      );
                    },
                    icon: PostSaveAnimation(key: widget.key!),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    noOfLikes.isEmpty
                        ? "No Likes"
                        : noOfLikes.length.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                        snap.data().toString().contains("userName")
                            ? snap["userName"].toString()
                            : "",
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        snap.data().toString().contains("description")
                            ? snap["description"].toString()
                            : "",
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      BlocProvider.of<UiBloc>(context)
                          .add(GetUserProfileEvent());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            BlocProvider.of<UiBloc>(context)
                                .selectedPostForComment = snap;
                            return BlocProvider.value(
                              value: BlocProvider.of<UiBloc>(context),
                              child: const CommentPage(),
                            );
                          },
                        ),
                      );
                    },
                    child:
                        BlocBuilder<UiBloc, UiState>(builder: (context, state) {
                      return Text(uiBloc.mapOfCommentCount
                              .containsKey(widget.key)
                          ? (uiBloc.mapOfCommentCount[widget.key]! == 0
                              ? "No comments"
                              : "${uiBloc.mapOfCommentCount[widget.key]!.toString()} comments")
                          : "No comments");
                    }),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
