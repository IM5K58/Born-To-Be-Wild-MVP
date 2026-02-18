class Challenge {
  final String id;
  final String userId;
  final String templateId;
  final String status;
  final String? startAt;
  final String? endAt;
  final String? failureRule;
  final String? donateTarget;
  final Deposit? deposit;

  Challenge({
    required this.id,
    required this.userId,
    required this.templateId,
    required this.status,
    this.startAt,
    this.endAt,
    this.failureRule,
    this.donateTarget,
    this.deposit,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'],
      userId: json['user_id'],
      templateId: json['template_id'],
      status: json['status'],
      startAt: json['start_at'],
      endAt: json['end_at'],
      failureRule: json['failure_rule'],
      donateTarget: json['donate_target'],
      deposit: json['deposit'] != null ? Deposit.fromJson(json['deposit']) : null,
    );
  }
}

class Deposit {
  final String id;
  final String amount; // API returns "10000.00" as String
  final String status;

  Deposit({required this.id, required this.amount, required this.status});

  factory Deposit.fromJson(Map<String, dynamic> json) {
    return Deposit(
      id: json['id'],
      amount: json['amount'].toString(), // safely convert num or String
      status: json['status'],
    );
  }
}
