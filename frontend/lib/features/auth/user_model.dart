class User {
  final String id;
  final String? nickname;
  final String? provider;

  User({required this.id, this.nickname, this.provider});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      nickname: json['nickname'] as String?,
      provider: json['provider'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'provider': provider,
    };
  }
}
