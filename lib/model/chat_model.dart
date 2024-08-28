class ChatModel {
  final String? messageId;
  final String? userName;
  final String? message;

  ChatModel({
    required this.messageId,
    required this.userName,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messageId': messageId,
      'userName': userName,
      'message': message,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      messageId: map['messageId'] != null ? map['messageId'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
    );
  }
}
