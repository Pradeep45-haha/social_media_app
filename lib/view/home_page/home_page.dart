import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_mmvm_dp_clone/view/chat_page/chat_main_page.dart';
import 'package:instagram_mmvm_dp_clone/view_model/bloc/ui_bloc/bloc/ui_bloc.dart';
import '../../config/widgets/post_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<UiBloc>(context).add(GetUserProfileEvent());
    return BlocListener<UiBloc, UiState>(
      listener: (context, state) {
        if (state is PostSavedSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.black,
              duration: Duration(seconds: 1, milliseconds: 250),
              content: Text(
                "Post Saved",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }
        if (state is RemovedSavedPostState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.black,
              duration: Duration(seconds: 1, milliseconds: 250),
              content: Text(
                "Saved Post Removed",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: SizedBox(
            width: 140,
            child: Image.asset(
              "assets/instagram_text.jpg",
              color: Colors.white,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return const ChatMainPage();
                    },
                  ));
                },
                icon: const Icon(
                  Icons.chat_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            )
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("posts").snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              controller: BlocProvider.of<UiBloc>(context).scrollController,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                debugPrint("rendering $index");
                BlocProvider.of<UiBloc>(context).setPostSnap(
                    Key(
                      index.toString(),
                    ),
                    snapshot.data!.docs[index]);
                return PostCard(
                  key: Key(
                    index.toString(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
