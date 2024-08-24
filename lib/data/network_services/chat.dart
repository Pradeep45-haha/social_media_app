import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:instagram_mmvm_dp_clone/config/data.dart';
import 'package:instagram_mmvm_dp_clone/config/error_const.dart';

import 'package:instagram_mmvm_dp_clone/data/network_services/storage..dart';
import 'package:instagram_mmvm_dp_clone/model/chat.dart';
import 'package:instagram_mmvm_dp_clone/model/user.dart';
import 'package:uuid/uuid.dart';

class ChatMethod {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final StorageMethods _storageMethods = StorageMethods();

  //send message to user
  Future<Data> sendMessage(
      {required String senderUid,
      required String message,
      required String receiverUid}) async {
    try {
      String messageId = const Uuid().v1();
      DateTime timeNow = DateTime.now();
      // debugPrint("sender uid is $senderUid from send message");
      //check if the user had chat with the given receiverUid
      QuerySnapshot<Map<String, dynamic>> usersChatDoc =
          await _firebaseFirestore
              .collection("onetoonechat")
              .where("userIds.$senderUid", isEqualTo: true)
              .where("userIds.$receiverUid", isEqualTo: true)
              .get();
      //if user had chat then get the doc-id and insert message
      if (usersChatDoc.docs.isNotEmpty) {
        // debugPrint("chat doc is not empty from send message");
        String docId = usersChatDoc.docs[0].id;
        await _firebaseFirestore
            .collection("onetoonechat")
            .doc(docId)
            .collection("chatData")
            .add({
          "message": message,
          "dateSend": timeNow,
          "messageId": messageId,
          "senderUid": senderUid,
          "receiverUid": receiverUid,
        });

        _firebaseFirestore.collection("onetoonechat").doc(docId).set({
          "userIds": {
            senderUid: true,
            receiverUid: true,
          },
          "lastMessage": message,
          "dateSend": timeNow,
        });
        return const SuccessData(
            successData: CSuccess(data: {"msg": "Message Sent Successfully"}));
      }
      //if user did not had any chat with given receiver-id then
      //add message in doc with doc id = sender-uid + receiver-uid
      await _firebaseFirestore
          .collection("onetoonechat")
          .doc("$senderUid$receiverUid")
          .collection("chatData")
          .add({
        "message": message,
        "dateSend": timeNow,
        "messageId": messageId,
        "senderUid": senderUid,
        "receiverUid": receiverUid,
      });
      //add latest chat details and the user-ids involved in the chat
      _firebaseFirestore
          .collection("onetoonechat")
          .doc("$senderUid$receiverUid")
          .set({
        "userIds": {
          senderUid: true,
          receiverUid: true,
        },
        "receiverId": receiverUid,
        "senderId": senderUid,
        "lastMessage": message,
        "dateSend": timeNow
      });

      return const SuccessData(
          successData: CSuccess(data: {"msg": "Message Sent Successfully"}));
    } catch (e) {
      return FailureData(
        failureData: CError(
          errorType: ErrorType.genericError,
          errorObj: e,
        ),
      );
    }
  }

  //get list of last messages sent by other users
  Future<Data> fetchMessages() async {
    String currentUserId = _firebaseAuth.currentUser!.uid;
    try {
      //get all the chat users
      QuerySnapshot<Map<String, dynamic>> chatDataSnap =
          await _firebaseFirestore
              .collection("onetoonechat")
              .where("userIds.$currentUserId", isEqualTo: true)
              .get();
      List<Chat> chats = [];
      // debugPrint(
      // "from fetch messages ${chatDataSnap.docs.first.data().toString()}");
      if (chatDataSnap.docs.isNotEmpty) {
        var chatDataDocs = chatDataSnap.docs;
        for (QueryDocumentSnapshot<Map<String, dynamic>> chatData
            in chatDataDocs) {
          chats.add(Chat.fromJson(chatData.data()));
        }
      }
      return SuccessData(
        successData: CSuccess(
          data: chats,
        ),
      );
    } catch (e) {
      return FailureData(
        failureData: CError(
          errorType: ErrorType.genericError,
          errorObj: e,
        ),
      );
    }
  }

  //get messages in realtime i.e. current conversation messages
  Stream<Data> fetchMessagesRealtime({required String receiverUserId}) async* {
    //current user-id
    String currentUserId = _firebaseAuth.currentUser!.uid;
    // debugPrint(
    // "current user id: $currentUserId\n receiver user id: $receiverUserId\n");

    //get doc where usersIds contain both currentUser-id and receiverUser-id
    QuerySnapshot<Map<String, dynamic>> currentChatDoc =
        await _firebaseFirestore
            .collection("onetoonechat")
            .where("userIds.$currentUserId", isEqualTo: true)
            .where("userIds.$receiverUserId", isEqualTo: true)
            .get();

    // debugPrint(
    // "fetch message realtime 1: ${(currentChatDoc.docs.length.toString())}");

    //check if there is any such doc
    if (currentChatDoc.docs.isNotEmpty) {
      // debugPrint("fetch message realtime 2:");
      String currentChatDocId = currentChatDoc.docs.first.id;

      //if such doc exists then get messages using doc-id
      yield* _firebaseFirestore
          .collection("onetoonechat")
          .doc(currentChatDocId)
          .collection("chatData")
          .orderBy("dateSend", descending: false)
          .snapshots()
          .map((event) {
        List<Message> messages = [];

        if (event.docs.isNotEmpty) {
          // debugPrint("chat doc is not empty");
          List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = event.docs;
          for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docs) {
            messages.add(Message.fromMap(doc.data()));
          }
          // debugPrint(
          // "from fetchmessagerealtime messages: ${messages.toString()}");
        }
        return SuccessData(
          successData: CSuccess(data: messages),
        );
      }).handleError(
        (error) => FailureData(
          failureData:
              CError(errorType: ErrorType.genericError, errorObj: error),
        ),
      );
    } else {
      // debugPrint("fetch message realtime 3:");
      //if no such doc exists then create a new doc with id = currentUser-id + receiverUser-id
      yield* _firebaseFirestore
          .collection("onetoonechat")
          .doc("$currentUserId$receiverUserId")
          .collection("chatData")
          .orderBy("dateSend", descending: false)
          .snapshots()
          .map((event) {
        List<Message> messages = [];
        if (event.docs.isNotEmpty) {
          List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = event.docs;
          for (QueryDocumentSnapshot<Map<String, dynamic>> doc in docs) {
            messages.add(Message.fromMap(doc.data()));
          }
        }
        // // debugPrint("message list: ${messages.toString()}");
        return SuccessData(
          successData: CSuccess(data: messages),
        );
      }).handleError(
        (error) => FailureData(
          failureData:
              CError(errorType: ErrorType.genericError, errorObj: error),
        ),
      );
    }
  }

// list of users-details current user had chat
  Future<Data> getListOfChatUserDetails() async {
    try {
      String currentUserId = _firebaseAuth.currentUser!.uid;
      //get all the chat users
      QuerySnapshot<Map<String, dynamic>> chatDataSnap =
          await _firebaseFirestore
              .collection("onetoonechat")
              .where("userIds.$currentUserId", isEqualTo: true)
              .get();
      // debugPrint(
      // "from getlistofchatUserDetails: ${chatDataSnap.docs.length.toString()}");

      List<Chat> chats = [];
      if (chatDataSnap.docs.isNotEmpty) {
        var chatDataDocs = chatDataSnap.docs;
        for (QueryDocumentSnapshot<Map<String, dynamic>> chatData
            in chatDataDocs) {
          // debugPrint(chatData.data().toString());
          chats.add(Chat.fromJson(chatData.data()));
        }
      }
      // debugPrint(chats.length.toString());

      List<String> otherUserIds = [];
      for (Chat chat in chats) {
        //check if id at 0th index == currentUser-id then get the user details of id at 1th index
        otherUserIds.add(chat.userIds[0] == currentUserId
            ? chat.userIds[1]
            : chat.userIds[0]);
      }
      // debugPrint("otherUserIds ${otherUserIds.toString()}");
      List<AppUser> otherUsersDetails = [];
      for (String otherUserId in otherUserIds) {
        //get details of user using there uid

        Data data = await _storageMethods.getOtherUserProfileDetails(
            userId: otherUserId);
        if (data is SuccessData) {
          otherUsersDetails.add(data.successData!.data as AppUser);
        }
      }

      return SuccessData(successData: CSuccess(data: otherUsersDetails));
    } catch (e) {
      // debugPrint(e.toString());
      return FailureData(
        failureData: CError(
          errorType: ErrorType.genericError,
          errorObj: e,
        ),
      );
    }
  }

  Future<Data> searchForChatUser({required String searchTag}) async {
    try {
      debugPrint("searchtag is $searchTag");
      QuerySnapshot<Map<String, dynamic>> searchUserDoc =
          await _firebaseFirestore
              .collection("users")
              .where("username", isGreaterThanOrEqualTo: searchTag)
              .get();
debugPrint("form chat service searchForChatUser method");
debugPrint(searchUserDoc.docs.length.toString());
      return SuccessData(
        successData: CSuccess(data: searchUserDoc.docs.map((e) {
          // debugPrint(e.toString());

          return AppUser.fromSnap(e);
        },).toList()),
      );
    } catch (e) {
      return FailureData(
        failureData: CError(
          errorType: ErrorType.genericError,
          errorObj: e,
        ),
      );
    }
  }
}
