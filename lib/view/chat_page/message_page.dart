import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_mmvm_dp_clone/model/chat.dart';
import 'package:instagram_mmvm_dp_clone/model/user.dart';
import 'package:instagram_mmvm_dp_clone/view/chat_page/message_tile.dart';
import 'package:instagram_mmvm_dp_clone/view_model/bloc/chat_bloc/chat_bloc.dart';
import 'package:instagram_mmvm_dp_clone/view_model/bloc/ui_bloc/bloc/ui_bloc.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({required super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  TextEditingController messageController = TextEditingController();
  ScrollController messageScrollController = ScrollController();

  @override
  void initState() {
     WidgetsBinding.instance.addPostFrameCallback((_) {
            Future.delayed(const Duration(milliseconds: 250), () {
            messageScrollController
                .jumpTo(messageScrollController.position.maxScrollExtent);
            debugPrint(
                "messages list max scroll extent: ${messageScrollController.position.maxScrollExtent}");
          });
           });
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    messageScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UiBloc uiBloc = BlocProvider.of<UiBloc>(context);
    ChatBloc chatBloc = BlocProvider.of<ChatBloc>(context);
    AppUser userData = chatBloc.mapOfChatUser[widget.key]!;
    

    chatBloc.add(FetchMessageEvent(receiverUserId: userData.uid));
    List<Message> messages = [];
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is MessageFetchingSuccessfulState) {}
      },
      builder: (context, state) {
        if (state is MessageFetchingSuccessfulState) {
          //  messageScrollController
          //       .jumpTo(messageScrollController.position.maxScrollExtent+300);
                WidgetsBinding.instance.addPostFrameCallback((_) {
            Future.delayed(const Duration(milliseconds: 250), () {
            messageScrollController
                .jumpTo(messageScrollController.position.maxScrollExtent);
            debugPrint(
                "messages list max scroll extent: ${messageScrollController.position.maxScrollExtent}");
          });
           });
        }
        if (chatBloc.mapOfAppUserUidAndChat[userData.uid] != null) {
          messages = chatBloc.mapOfAppUserUidAndChat[userData.uid]!;
        }
        if (state is MessageFetchingState || state is ChatInitial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Scaffold(
            body: SizedBox(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          chatBloc.add(GetChatUserListEvent());
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(userData.photoUrl),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        userData.userName,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 120,
                    child: ListView.builder(
                      controller: messageScrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return MessageTile(
                          message: messages[index].message,
                          formCurrentUser:
                              messages[index].senderUid == userData.uid,
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                            uiBloc.currentUserDetails!.photoUrl,
                          ),
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                        SizedBox(
                          height: 48,
                          width: MediaQuery.of(context).size.width - 120,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Message is empty";
                              }
                              return value;
                            },
                            controller: messageController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Write something..."),
                          ),
                        ),
                        const Expanded(
                            child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                        )),
                        IconButton(
                            onPressed: () {
                              if (messageController.text.isEmpty) {
                                return;
                              }
                              chatBloc.add(
                                SendMessageEvent(
                                  fromUid:
                                      uiBloc.currentUserDetails!.uid,
                                  toUid: userData.uid,
                                  message: messageController.text,
                                ),
                              );
                              messageController.text = "";
                            },
                            icon: const Icon(
                              Icons.send,
                              color: Colors.blue,
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
      },
    );
  }
}
