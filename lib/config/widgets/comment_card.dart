import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_mmvm_dp_clone/view_model/bloc/ui_bloc/bloc/ui_bloc.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({super.key});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    UiBloc uiBloc = BlocProvider.of<UiBloc>(context);
    QueryDocumentSnapshot<Map<String, dynamic>> commentSnap =
        uiBloc.mapOfCommentSnap[widget.key]!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () {
        debugPrint("hold comment click");
      },
      onTap: () {
        debugPrint("comment click");
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(commentSnap["profileImageUrl"]),
              radius: 18,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: commentSnap["userName"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const TextSpan(
                          text: "  ",
                        ),
                        TextSpan(
                          text: commentSnap["comment"],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(
                        commentSnap["datePublished"].toDate(),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            Container(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                onPressed: () {
                  debugPrint("comment liked");
                },
                icon: const Icon(Icons.favorite_border_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
