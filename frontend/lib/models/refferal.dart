class Referral {
  final String username;
  final int claimedTokens;

  Referral({
    required this.username,
    required this.claimedTokens,
  });

  factory Referral.fromJson(Map<String, dynamic> json) {
    return Referral(
      username: json['referral_username'] as String,
      claimedTokens: json['claimed_tokens'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'referral_username': username,
      'claimed_tokens': claimedTokens,
    };
  }
}