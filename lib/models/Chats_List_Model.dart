class ChatModel {
  bool? success;
  List<ChatUser> data;

  ChatModel({
    this.success,
    required this.data,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      success: json["success"],
      data: (json["data"] as List?)
              ?.map((e) => ChatUser.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ChatUser {
  String? id;
  String? name;
  String? email;
  String? roleName;
  LastMessage? lastMessage;

  ChatUser({
    this.id,
    this.name,
    this.email,
    this.roleName,
    this.lastMessage,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      roleName: json["role"]?["name"],
      lastMessage: json["lastMessage"] != null
          ? LastMessage.fromJson(json["lastMessage"])
          : null,
    );
  }
}

class LastMessage {
  String? id;
  String? from;
  String? to;
  String? message;
  bool? read;

  LastMessage({
    this.id,
    this.from,
    this.to,
    this.message,
    this.read,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      id: json["_id"],
      from: json["from"],
      to: json["to"],
      message: json["message"],
      read: json["read"],
    );
  }
}
