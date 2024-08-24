import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_mmvm_dp_clone/config/data.dart';
import 'package:instagram_mmvm_dp_clone/data/network_services/chat.dart';
import 'package:instagram_mmvm_dp_clone/model/chat.dart';
import 'package:instagram_mmvm_dp_clone/model/user.dart';
import 'package:instagram_mmvm_dp_clone/view_model/bloc/ui_bloc/bloc/ui_bloc.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  //service initialization
  final ChatMethod _chatMethod = ChatMethod();
  //dependency
  final UiBloc uiBloc;

  //for debug purpose
  int fetchMessageEventCount = 0;

  //for one time function
  bool isGetMessageCalled = false;

  Map<String, bool> isFetchRealtimeMessageCalled = {};

  //list of chat user
  List<AppUser> listOfChatUser = [];

  //map of last chat with users
  Map<String, Chat> mapOfLastChat = {};

  //map of chat user according to widget
  Map<Key, AppUser> mapOfChatUser = {};
  Map<String, List<Message>> mapOfAppUserUidAndChat = {};

  //chat user search result
  List<AppUser> chatUsersSearchList = [];

  ChatBloc({required this.uiBloc}) : super(ChatInitial()) {
    on<ChatEvent>((event, emit) async {
      if (event is SearchUserEvent) {
        debugPrint("got SearchUserEvent searchTag: ${event.searchTag}");
        Data searchUserData =
            await _chatMethod.searchForChatUser(searchTag: event.searchTag);

        if (searchUserData is SuccessData) {
          chatUsersSearchList = [
            ...searchUserData.successData!.data as List<AppUser>,
            ...chatUsersSearchList
          ];
          debugPrint("form chat bloc searchUserData for chat");
          debugPrint(chatUsersSearchList.toString());

          emit(GotSearchUserState());
          return;
        }
      }
      if (event is GetChatUserListEvent) {
        emit(GettingChatUserListState());
        // get the chat users details
        Data chatUsersData = await _chatMethod.getListOfChatUserDetails();
        //use listofchatuser for adding chatusers
        if (chatUsersData is SuccessData) {
          List<AppUser> chatUsersDetails =
              chatUsersData.successData!.data as List<AppUser>;
          if (chatUsersDetails.isEmpty) {
            emit(ChatUserListEmptyState());
          }
          listOfChatUser = [...chatUsersDetails];
          debugPrint(listOfChatUser.toString());
          //get the last message
          Data data = await _chatMethod.fetchMessages();
          if (data is SuccessData) {
            SuccessData lastChatData = data;
            List<Chat> lastChats = lastChatData.successData!.data as List<Chat>;
            // debugPrint("lastChatData is success data");
            // debugPrint(lastChats.toString());
            uiBloc.currentUserDetails!.uid;
            for (var lastchat in lastChats) {
              mapOfLastChat[
                  lastchat.userIds[0] == uiBloc.currentUserDetails!.uid
                      ? lastchat.userIds[1]
                      : lastchat.userIds[0]] = lastchat;
            }
          }
          emit(GotChatUserListState());
          debugPrint("emitted GotChatUserListState");
        }
        if (chatUsersData is FailureData) {}
        return;
      }
      if (event is SendMessageEvent) {
        await _chatMethod.sendMessage(
          senderUid: event.fromUid,
          message: event.message,
          receiverUid: event.toUid,
        );
        emit(SentMessageSuccessState());
        return;
      }
      if (event is FetchMessageEvent) {
        if (!isFetchRealtimeMessageCalled.containsKey(event.receiverUserId)) {
          debugPrint("called for ${event.receiverUserId}");
          isFetchRealtimeMessageCalled[event.receiverUserId] = true;
          _chatMethod
              .fetchMessagesRealtime(receiverUserId: event.receiverUserId)
              .listen((messageData) {
            debugPrint("new data arrived");
            if (messageData is SuccessData) {
              List<Message> messages =
                  messageData.successData!.data as List<Message>;
              mapOfAppUserUidAndChat[event.receiverUserId] = messages;
              // debugPrint("message list length: ${messages.length.toString()}");
              add(FetchMessageSuccessEvent());
              return;
            }
            if (messageData is FailureData) {
              add(FetchMessageFailureEvent());
              return;
            }
          });
        }
        return;
      }

      if (event is FetchMessageSuccessEvent) {
        debugPrint("got FetchMessageSuccessEvent");
        emit(MessageFetchingSuccessfulState());
        return;
      }
      if (event is FetchMessageFailureEvent) {
        debugPrint("got FetchMessageFailureEvent");
        emit(MessageFetchingFailurefulState());
        return;
      }
    });
  }
}
