part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

class SentMessageSuccessState extends ChatState {}

class SentMessageFailureState extends ChatState {}

class SentMessageSeen extends ChatState {}

class DeleteSentMessageSuccessState extends ChatState {
  DeleteSentMessageSuccessState();
}

class DeleteSentMessageFailureState extends ChatState {
  DeleteSentMessageFailureState();
}

class ChatUserListEmptyState extends ChatState{}
class GotChatUserListState extends ChatState{}

class GettingChatUserListState extends ChatState{}



class MessageFetchingState extends ChatState{}

class MessageFetchingSuccessfulState extends ChatState{}
class MessageFetchingFailurefulState extends ChatState{}



class GotSearchUserState extends ChatState {
  
  GotSearchUserState();
}


