import 'package:json_annotation/json_annotation.dart';

import '../../../shared/data/models/user.dart';
import 'message.dart';

part 'conversation.g.dart';

@JsonSerializable()
class Conversation {
  final String? id;
  @JsonKey(fromJson: _messageFromJson, toJson: _messageToJson)
  final List<Message> messages;
  final List<String> participantIds;
  User? otherUser;

  Conversation(
      {this.id,
      required this.messages,
      required this.participantIds,
      this.otherUser});

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationToJson(this);

  static List<Message> _messageFromJson(List<dynamic> json) {
    return json
        .map((e) => Message.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static List<Map<String, dynamic>> _messageToJson(List<Message> list) {
    return list.map((e) => e.toJson()).toList();
  }

  Conversation copyWith({User? otherUser}) {
    return Conversation(
      id: id,
      messages: messages,
      participantIds: participantIds,
      otherUser: otherUser ?? this.otherUser,
    );
  }
}
