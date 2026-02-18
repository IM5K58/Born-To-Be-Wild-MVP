class Attempt {
  final String id;
  final String challengeId;
  final String missionId;
  final String userId;
  final String status;
  final String? judgeReasonCode;
  final String submittedAt;

  Attempt({
    required this.id,
    required this.challengeId,
    required this.missionId,
    required this.userId,
    required this.status,
    this.judgeReasonCode,
    required this.submittedAt,
  });

  factory Attempt.fromJson(Map<String, dynamic> json) {
    return Attempt(
      id: json['id'],
      challengeId: json['challenge_id'],
      missionId: json['mission_id'],
      userId: json['user_id'],
      status: json['status'],
      judgeReasonCode: json['judge_reason_code'],
      submittedAt: json['submitted_at'],
    );
  }
}
