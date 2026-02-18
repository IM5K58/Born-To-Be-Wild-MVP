class Mission {
  final String id;
  final String challengeId;
  final String date; // yyyy-MM-dd
  final String dayIndex;
  final String codeword;
  final String gesture;
  final String overlayText;

  Mission({
    required this.id,
    required this.challengeId,
    required this.date,
    required this.dayIndex,
    required this.codeword,
    required this.gesture,
    required this.overlayText,
  });

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id'],
      challengeId: json['challenge_id'],
      date: json['date'],
      dayIndex: json['day_index'].toString(), // Be resilient to number/string
      codeword: json['codeword'],
      gesture: json['gesture'],
      overlayText: json['overlay_text'],
    );
  }
}
