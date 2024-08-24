import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_mmvm_dp_clone/config/data.dart';
import 'package:instagram_mmvm_dp_clone/data/network_services/storage..dart';
import 'package:instagram_mmvm_dp_clone/model/user.dart';
// ignore: unnecessary_import, depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'ui_event.dart';
part 'ui_state.dart';

class UiBloc extends Bloc<UiEvent, UiState> {
  //service initialization
  final StorageMethods _storageMethods = StorageMethods();

  //for ui
  int selectedPage = 0;
  int selectedViewPage = 0;
  late PageController selectedViewPageController;
  late PageController pageController;
  bool showPopMenu = false;

  //for like animation
  Map<Key, bool> tempAnimate = {};

  //each post state
  Map<Key, bool> isPostSaved = {};
  Map<Key, bool> isPostLiked = {};

  //for current user profile image when signing up
  Uint8List? profileImage;

  //comment count according to post widget
  Map<Key, int> mapOfCommentCount = {};

  //post data according to widget key
  Map<Key, QueryDocumentSnapshot<Map<String, dynamic>>> mapOfPostSnap = {};

  //comments on post
  QueryDocumentSnapshot<Map<String, dynamic>>? selectedPostForComment;

  //map of other user id and isCurrentUserFollowingThisUser
  Map<String, bool> isCurrentUserFollowingThisUser = {};

  //other than current user data for profile viewing
  AppUser? othersUserDetails;
  int? otherUserFollowingCount;
  int? otherUserPostCount;
  int? otherUserFollowerCount;

  //current user profile details
  AppUser? currentUserDetails;
  int? currentUserPostCount;
  int? currentUserFollowingCount;
  int? currentUserFollowerCount;

  //list of user the current user is following for chat
  List<dynamic> listOfUsersToChat = [];

  //for comment details
  Map<Key, QueryDocumentSnapshot<Map<String, dynamic>>> mapOfCommentSnap = {};

 

  //scroll position of posts list
  double scrollPosition = 0.0;
  ScrollController scrollController = ScrollController();

  void setPostSnap(key, value) {
    mapOfPostSnap[key] = value;
  }

  UiBloc() : super(UiInitial()) {
    on<UiEvent>(
      (event, emit) async {
        if (event is GetUserProfileEvent) {
          debugPrint("got user profile event");

          emit(GettingUserProfileState());

          Data data = await _storageMethods.getCurrentUserDetails();
          if (data is SuccessData) {
            currentUserDetails = (data.successData!.data as AppUser);
          }

          Data followingCountData =
              await _storageMethods.getFollowingCountForCurrentUser();
          if (followingCountData is SuccessData) {
            currentUserFollowingCount =
                followingCountData.successData!.data as int;
          }

          Data currentUserPostCountdata =
              await _storageMethods.getPostCountForCurrentUser();
          if (currentUserPostCountdata is SuccessData) {
            currentUserPostCount =
                currentUserPostCountdata.successData!.data as int;
          }
          emit(GotUserDetailsState());
          return;
        }
        if (event is ShowProfilePhotoMenuEvent) {
          debugPrint(" got ShowProfilePhotoMenuEvent");
          await imageSelection(emit);
          return;
        }

        if (event is BottomNavigationBarChangedEvent) {
          selectedPage = event.currentPageIndx;
          pageController = event.pageController;
          pageController.jumpToPage(event.currentPageIndx);
          emit(
            BottomNavigationBarChangedState(),
          );
        }

        if (event is AppPageViewChangedEvent) {
          selectedViewPage = event.currentPageIndx;
          selectedViewPageController = event.pageController;
          selectedViewPageController.jumpToPage(event.currentPageIndx);
          emit(AddPageViewChangedState(num: selectedViewPage));
          if (event.currentPageIndx == 0) {
            Uint8List? image =
                await pickImage(ImageSource.gallery) as Uint8List?;
            if (image == null) {
              emit(NoPostSelectedState());
            } else {
              emit(PostSelectedState(image: image));
            }
          }
        }
        if (event is PostPostEvent) {
          Data result = await _storageMethods.addPost(
            event.childName,
            event.image,
            event.description,
            event.isPost,
          );

          if (result is SuccessData) {
            selectedPage = 0;
            emit(PostPostedSuccessState());
            pageController.jumpToPage(0);
            emit(BottomNavigationBarChangedState());
          } else {
            emit(PostCancelledState());
          }
        }
        if (event is PostLikedEvent) {
          tempAnimate[event.key] = !isPostLiked[event.key]!;
          debugPrint("PostLikedEvent from widget key ${event.key}");
          StorageMethods storageMethods = StorageMethods();
          if (isPostLiked[event.key] == false) {
            await storageMethods.addLikeUidToPost(
                event.uid, mapOfPostSnap[event.key]!.get("postId"));
            await storageMethods.saveLikedPost(postId: event.postId);
            isPostLiked[event.key] == true;
          } else {
            await storageMethods.removeLikeUidFromPost(
                event.uid, mapOfPostSnap[event.key]!.get("postId"));
            await storageMethods.removeLikedPost(postId: event.postId);
            isPostLiked[event.key] == false;
          }
          emit(AnimateLikeButtonState(
            key: event.key,
          ));
        }
        if (event is PostCommentEvent) {
          _storageMethods.addCommentToPost(event.postId, event.comment,
              event.uid, event.profileImageUrl, event.userName);
        }
        if (event is DeletePostEvent) {
          _storageMethods.deletePost(event.postId);
        }
        if (event is ShowProfilePageEvent) {
          debugPrint("show profile event triggered");
          emit(ShowingProfilePageState());
        }

        if (event is SavePostEvent) {
          isPostSaved[event.key] = isPostSaved.containsKey(event.key)
              ? !isPostSaved[event.key]!
              : true;
          if (isPostSaved[event.key]!) {
            await _storageMethods.savePost(postId: event.postId);
            emit(PostSavedSuccessState());
          } else {
            await _storageMethods.removeSavedPost(postId: event.postId);
            emit(RemovedSavedPostState());
          }
        }
        if (event is SaveLikedPostEvent) {
          await _storageMethods.saveLikedPost(postId: event.postId);
          emit(SavedLikedPostSuccessState());
        }
        if (event is GetOtherUserProfileDetailsEvent) {
          debugPrint("got GetOtherUserPostAndFollowerAndFollowingCount event");
          Data isCurrentUserFollowingThisUserData = await _storageMethods
              .isCurrentUserFollowingThisUser(userId: event.userId);
          Data postCountData =
              await _storageMethods.getUserPostCount(userId: event.userId);
          Data followingCountData =
              await _storageMethods.getUserFollowingCount(userId: event.userId);
          // Data followerCountData =
          //     await _storageMethods.getUserFollowerCount(userId: event.userId);

          Data otherUserData = await _storageMethods.getOtherUserProfileDetails(
              userId: event.userId);

          if (otherUserData is SuccessData) {
            othersUserDetails = (otherUserData.successData!.data as AppUser);
            if((postCountData is SuccessData))
            {
              debugPrint("1");
            }
             if((followingCountData is SuccessData))
            {
              debugPrint("2");
            }
             if((isCurrentUserFollowingThisUserData is SuccessData))
            {
              debugPrint("3");
            }
            if ((postCountData is SuccessData) &&
                (followingCountData is SuccessData) &&
                (isCurrentUserFollowingThisUserData is SuccessData)) {
              otherUserPostCount = postCountData.successData!.data as int;
              otherUserFollowingCount =
                  followingCountData.successData!.data as int;
              isCurrentUserFollowingThisUser[event.userId] =
                  isCurrentUserFollowingThisUserData.successData!.data as bool;
              debugPrint(
                  "from GetOtherUserProfileDetailsEvent isCurrentUserFollowingThisUser: ${isCurrentUserFollowingThisUser[event.userId]}");
              emit(GotOtherUserProfileDetailsState());
              return;
            } else {
              debugPrint(
                  "from GetOtherUserProfileDetailsEvent somethis is wrong");
              return;
            }
          }
        }
        if (event is AddUserToFollowingListEvent) {
          await _storageMethods.addUserToFollowingList(userId: event.userId);
          Data isCurrentUserFollowingThisUserData = await _storageMethods
              .isCurrentUserFollowingThisUser(userId: event.userId);
          if (isCurrentUserFollowingThisUserData is SuccessData) {
            isCurrentUserFollowingThisUser[event.userId] =
                isCurrentUserFollowingThisUserData.successData!.data as bool;
            debugPrint(
                "from AddUserToFollowingListEvent isCurrentUserFollowingThisUser: ${isCurrentUserFollowingThisUser[event.userId]}");
          }
          emit(AddedUserToFollowingListState());
          emit(GotOtherUserProfileDetailsState());
        }
        if (event is RemoveUserFromFollowingListEvent) {
          if (await _storageMethods.removeUserFromFollowingList(
              userId: event.userId) is SuccessData) {
                 isCurrentUserFollowingThisUser[event.userId] = false;
            emit(RemovedUserFromFollowingListState());
            emit(GotOtherUserProfileDetailsState());
          } else {
            debugPrint(
                "unable to remove user: ${event.userId} from following list ");
          }
        }

        if (event is GetCommentDataEvent) {
          Data commentCountData = await _storageMethods.getCommentCountForPost(
              postId: event.snap["postId"]);
          if (commentCountData is SuccessData) {
            mapOfCommentCount[event.key] =
                commentCountData.successData!.data as int;
            emit(GotCommentData());
          }
        }
        if (event is GetPostIsLikedEvent) {
          // isPostLiked[event.key] = await _storageMethods
          //     .isPostLikedByCurrentUser(postId: event.postId);
          Data isPostLikedData = await _storageMethods.isPostLikedByCurrentUser(
              postId: event.postId);
          if (isPostLikedData is SuccessData) {
            isPostLiked[event.key] = isPostLikedData.successData!.data as bool;
          }
        }
        if (event is GetPostIsSavedEvent) {
          Data isPostSavedData = await _storageMethods.isPostSavedByCurrentUser(
              postId: event.postId);
          if (isPostSavedData is SuccessData) {
            isPostSaved[event.key] = isPostSavedData.successData!.data as bool;
          }
        }
       
      },
    );
  }

  Future<void> imageSelection(Emitter<UiState> emit) async {
    debugPrint("1");
    Uint8List? image = await pickImage(ImageSource.gallery) as Uint8List;
    debugPrint("2");
    profileImage = image;
    debugPrint("3");
    emit.call(LoadProfilePictureState(image: image));
    debugPrint("4");
  }
}

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
}
