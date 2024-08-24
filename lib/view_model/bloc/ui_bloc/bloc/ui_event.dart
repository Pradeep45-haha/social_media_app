part of 'ui_bloc.dart';

@immutable
abstract class UiEvent {}

class ShowProfilePhotoMenuEvent extends UiEvent {}

class BottomNavigationBarChangedEvent extends UiEvent {
  final int currentPageIndx;
  final PageController pageController;
  BottomNavigationBarChangedEvent(
      {required this.currentPageIndx, required this.pageController});
}

class AppPageViewChangedEvent extends UiEvent {
  final int currentPageIndx;
  final PageController pageController;
  AppPageViewChangedEvent({
    required this.currentPageIndx,
    required this.pageController,
  });
}

class CancelPostEvent extends UiEvent {}

class PostPostEvent extends UiEvent {
  final Uint8List image;
  final String description;

  final bool isPost;

  final String childName;

  PostPostEvent({
    required this.description,
    required this.isPost,
    required this.image,
    required this.childName,
  });
}

class PostLikedEvent extends UiEvent {
  final String uid;
  final String postId;
  final Key key;
  PostLikedEvent({required this.uid, required this.postId, required this.key});
}

class PostCommentEvent extends UiEvent {
  final String postId;
  final String comment;
  final String uid;
  final String profileImageUrl;
  final String userName;

  PostCommentEvent({
    required this.comment,
    required this.postId,
    required this.profileImageUrl,
    required this.uid,
    required this.userName,
  });
}

class ShowPopUpMenuEvent extends UiEvent {}

class DeletePostEvent extends UiEvent {
  final String postId;
  DeletePostEvent({required this.postId});
}

class ShowProfilePageEvent extends UiEvent {
  ShowProfilePageEvent();
}

class GetOtherUserProfileDetailsEvent extends UiEvent {
  final String userId;
  GetOtherUserProfileDetailsEvent({required this.userId});
}

class AnimateLikeButtonEvent extends UiEvent {
  final Key key;
  AnimateLikeButtonEvent({required this.key});
}

class GetUserProfileEvent extends UiEvent {}

class GetCommentDataEvent extends UiEvent {
  final QueryDocumentSnapshot<Map<String, dynamic>> snap;
  final Key key;
  GetCommentDataEvent({required this.snap, required this.key});
}

class SavePostEvent extends UiEvent {
  final Key key;
  final String postId;
  SavePostEvent({required this.postId, required this.key});
}

class SaveLikedPostEvent extends UiEvent {
  final Key key;
  final String postId;
  SaveLikedPostEvent({required this.key, required this.postId});
}

class AddUserToFollowingListEvent extends UiEvent {
  final String userId;
  AddUserToFollowingListEvent({required this.userId});
}

class RemoveUserFromFollowingListEvent extends UiEvent {
  final String userId;
  RemoveUserFromFollowingListEvent({required this.userId});
}

class GetPostIsLikedEvent extends UiEvent {
  final Key key;
  final String postId;
  GetPostIsLikedEvent({required this.key, required this.postId});
}

class GetPostIsSavedEvent extends UiEvent {
  final Key key;
  final String postId;
  GetPostIsSavedEvent({required this.key, required this.postId});
}

class GetOtherUserPostAndFollowerAndFollowingCountEvent extends UiEvent {
  final String userId;
  GetOtherUserPostAndFollowerAndFollowingCountEvent({required this.userId});
}

