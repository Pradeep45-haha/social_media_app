part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String toUid;
  final String fromUid;
  final String message;
  SendMessageEvent({
    required this.fromUid,
    required this.message,
    required this.toUid,
  });
}

class DeleteSentMessageEvent extends ChatEvent {
  final String toUid;
  final String fromUid;
  final String message;
  DeleteSentMessageEvent({
    required this.fromUid,
    required this.message,
    required this.toUid,
  });
}

class GetChatUserListEvent extends ChatEvent {}

class FetchMessageEvent extends ChatEvent {
  final String receiverUserId;
  FetchMessageEvent({required this.receiverUserId});
}


class FetchMessageSuccessEvent extends ChatEvent{}
class FetchMessageFailureEvent extends ChatEvent{}


class SearchUserEvent extends ChatEvent {
  final String searchTag;
  SearchUserEvent({required this.searchTag});
}
