import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  final String id;
  final String authorId;
  final String content;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final Timestamp timestamp;

  Message({
    required this.id,
    required this.authorId,
    required this.content,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  static Timestamp _timestampFromJson(Timestamp timestamp) => timestamp;

  static Timestamp _timestampToJson(Timestamp timestamp) => timestamp;
}
