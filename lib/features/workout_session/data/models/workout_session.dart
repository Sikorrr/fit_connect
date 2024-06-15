import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../shared/data/models/user.dart';
import '../../../shared/domain/entities/fitness_interest.dart';

part 'workout_session.g.dart';

@JsonSerializable()
class WorkoutSession {
  final String? id;
  final FitnessInterest activity;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final Timestamp date;
  final List<String> participantIds;
  final String? place;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final User? otherUser;
  bool isCompleted;

  WorkoutSession({
    this.id,
    required this.activity,
    required this.date,
    required this.participantIds,
    this.otherUser,
    this.place,
    this.isCompleted = false,
  });

  @override
  String toString() {
    return 'WorkoutSession{id: $id, activity: $activity, date: $date, participantIds: $participantIds, place: $place, otherUser: $otherUser, isCompleted: $isCompleted}';
  }

  factory WorkoutSession.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSessionFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutSessionToJson(this);

  static Timestamp _timestampFromJson(Timestamp timestamp) => timestamp;

  static Timestamp _timestampToJson(Timestamp timestamp) => timestamp;

  WorkoutSession copyWith({
    String? id,
    User? otherUser,
    bool? isCompleted,
  }) {
    return WorkoutSession(
      id: id ?? this.id,
      activity: activity,
      date: date,
      place: place,
      participantIds: participantIds,
      otherUser: otherUser ?? this.otherUser,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
