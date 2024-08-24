import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final DateTime dateSend;
  final String messageId;
  final String senderUid;
  final String receiverUid;

  Message({
    required this.message,
    required this.dateSend,
    required this.messageId,
    required this.senderUid,
    required this.receiverUid,
  });

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "dateSend": dateSend,
      "messageId": messageId,
      "senderUid": senderUid,
      "receiverUid": receiverUid,
    };
  }

  static Message fromJson(Map<String, dynamic> json) {
    
    return Message(
        message: json["message"] ?? "",
        dateSend: json["dateSend"] ?? "",
        messageId: json["messageId"] ?? "",
        senderUid: json["senderUid"] ?? "",
        receiverUid: json["receiverUid"] ?? "");
  }

  static Message fromMap(Map<String, dynamic> map) {
    return Message(
        message: map["message"] ?? "",
        dateSend: (map["dateSend"] as Timestamp).toDate(),
        messageId: map["messageId"] ?? "",
        senderUid: map["senderUid"] ?? "",
        receiverUid: map["receiverUid"] ?? "");
  }

  @override
  String toString() {
    return "message: $message \n dateSend: $dateSend \n messageId: $messageId \n senderUid: $senderUid \n receiverUid: $receiverUid \n";
  }
}

class Chat {
  String? receiverId;
  String? senderId;
  List<Message> messages = [];
  String? lastMessage;
  List<String> userIds = [];

  Chat(
      {required this.receiverId,
      required this.senderId,
      required this.userIds,
      required this.lastMessage,
      required this.messages});

  set setReceiverId(receiverId) {
    receiverId = receiverId;
  }

  set setSenderId(senderId) {
    senderId = senderId;
  }

  String? get getReceiverId {
    return receiverId;
  }

  String? get getSenderId {
    return senderId;
  }

  set setLastMessage(message) {
    lastMessage = message;
  }

  String? get getLastMessage {
    return lastMessage;
  }

  static toJson(Chat chat) {}

  static fromJson(Map<String, dynamic> chatJson) {
    List<String> userIdsList = (chatJson["userIds"] as Map<String, dynamic>)
        .keys
        .map((e) => e.toString())
        .toList();
    Chat chat = Chat(
        receiverId: chatJson["receiverId"],
        senderId: chatJson["senderId"],
        userIds: userIdsList,
        lastMessage: chatJson["lastMessage"],
        messages: []);
    return chat;
  }

  @override
  String toString() {
    return "receiverId: $receiverId \n senderId: $senderId \n userIds: $userIds \n lastMessage: $lastMessage \n messages: $messages \n";
  }
}
