import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_mmvm_dp_clone/view/chat_page/message_page.dart';
import 'package:instagram_mmvm_dp_clone/view_model/bloc/chat_bloc/chat_bloc.dart';
import 'package:instagram_mmvm_dp_clone/view_model/bloc/ui_bloc/bloc/ui_bloc.dart';

class ChatMainPage extends StatefulWidget {
  const ChatMainPage({super.key});

  @override
  State<ChatMainPage> createState() => _ChatMainPageState();
}

class _ChatMainPageState extends State<ChatMainPage> {
  late final ChatBloc chatBloc;
  late final UiBloc uiBloc;

  @override
  void initState() {
    super.initState();
    //chatbloc initialization
    chatBloc = BlocProvider.of<ChatBloc>(context);
    uiBloc = BlocProvider.of<UiBloc>(context);
    //get current user chat details
    chatBloc.add(GetChatUserListEvent());
    //get current user profile details
    uiBloc.add(GetUserProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is GettingChatUserListState || state is ChatInitial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is ChatUserListEmptyState) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: Text(uiBloc.currentUserDetails!.userName),
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .80,
                      child: TextField(
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            chatBloc.add(
                              SearchUserEvent(searchTag: value),
                            );
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: "Search user to chat",
                          border: UnderlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    )
                  ],
                ),
                const Expanded(
                  child: Center(
                    child: Text("No User to start conversation"),
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(uiBloc.currentUserDetails!.userName),
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .80,
                      child: TextField(
                        onChanged: (value) {
                          chatBloc.add(SearchUserEvent(searchTag: value));
                        },
                        decoration: const InputDecoration(
                          hintText: "Search user to chat",
                          border: UnderlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          "Messages",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height - 140,
                        child: ListView.builder(
                          itemCount: chatBloc.listOfChatUser.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                chatBloc.mapOfChatUser[Key(index.toString())] =
                                    chatBloc.listOfChatUser[index];
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return MessagePage(
                                      key: Key(index.toString()),
                                    );
                                  },
                                ));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: ChatTile(index: index),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ChatTile extends StatelessWidget {
  final int index;
  const ChatTile({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    ChatBloc chatBloc = BlocProvider.of<ChatBloc>(context);

    return SizedBox(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage:
                NetworkImage(chatBloc.listOfChatUser[index].photoUrl),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  chatBloc.listOfChatUser[index].userName,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 1,
                ),
                Text(
                  chatBloc.mapOfLastChat[chatBloc.listOfChatUser[index].uid]!
                      .lastMessage!,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                  ),
                  textAlign: TextAlign.left,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
