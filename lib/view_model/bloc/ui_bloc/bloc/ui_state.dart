part of 'ui_bloc.dart';

@immutable
abstract class UiState {}

class UiInitial extends UiState {}

class LoadProfilePictureState extends UiState {
  final Uint8List image;
  LoadProfilePictureState({required this.image});
}

class ShowProfilePhotoMenuState extends UiState {}

class GotUserDetailsState extends UiState {}

class BottomNavigationBarChangedState extends UiState {}

class AddPageViewChangedState extends UiState {
  final int num;
  AddPageViewChangedState({required this.num});
}

class PostSelectedState extends UiState {
  final Uint8List? image;
  PostSelectedState({this.image});
}

class NoPostSelectedState extends UiState {}

class PostCancelledState extends UiState {}

class PostPostedSuccessState extends UiState {}

class ShowPopUpMenuState extends UiState {}

class ShowingProfilePageState extends UiState {}

class AnimateLikeButtonState extends UiState {
  final Key key;
  AnimateLikeButtonState({required this.key});
}

class GettingUserProfileState extends UiState {}

class GotUserProfileState extends UiState {}

class GotCommentData extends UiState {}

class PostSavedSuccessState extends UiState {}

class PostSaveFailedState extends UiState {}

class SavedLikedPostSuccessState extends UiState {}

class SaveLikedPostFailureState extends UiState {}

class GotOtherUserProfileDetailsState extends UiState {}

class RemovedUserFromFollowingListState extends UiState {}

class AddedUserToFollowingListState extends UiState {}

class GetListOfFollowingUserState extends UiState {}


class NewUserDataState extends UiState{
  final QuerySnapshot<Map<String, dynamic>> newData;
  NewUserDataState({required this.newData});
}

class RemovedSavedPostState extends UiState{}


class GotOtherUserPostAndFollowerAndFollowingCount extends UiState{
  
}

