import 'package:ycss/models/team_time_info.dart';

class TeamTimeInfoSubmission extends TeamTimeInfo {
  int? receivingPoints;
  int? previousScore;
  TeamTimeInfoSubmission({
    required super.docID,
    required super.teamName,
    required super.time,
    required super.timeInMillis,
    required this.receivingPoints,
    this.previousScore,
  });
}
