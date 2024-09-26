import 'package:flutter/material.dart';
import 'package:petfight/models/claimed.dart';
import 'package:petfight/models/invite_link.dart';
import 'package:petfight/models/refferal.dart';
import 'package:petfight/models/task.dart';

class User with ChangeNotifier {
  String jwtToken;
  int telegramId;
  int balance;
  List<Referral> referrals;
  List<Task> tasks;
  late InviteLink inviteLink;
  Claimed claimed;

  User({
    required this.jwtToken,
    required this.telegramId,
    required this.balance,
    required this.referrals,
    required this.tasks,
    required this.claimed,
  }) : inviteLink = InviteLink(telegramId: telegramId);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      jwtToken: json['token'] as String,
      telegramId: json['user']['telegram_id'] as int,
      balance: json['user']['balance'] as int,
      referrals: (json['user']['referrals'] as List<dynamic>)
          .map((referralJson) => Referral.fromJson(referralJson as Map<String, dynamic>))
          .toList(),
      tasks: (json['user']['tasks'] as List<dynamic>)
          .map((taskJson) => Task.fromJson(taskJson as Map<String, dynamic>))
          .toList(),
      claimed: Claimed(
        timestamp: json['user']['last_claim_timestamp'],
      ),
    );
  }

  void updateBalance({required int coins}) {
    balance += coins;
    notifyListeners();
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = jwtToken;
    data['user'] = {
      'telegram_id': telegramId,
      'balance': balance,
      'referrals': referrals.map((referral) => referral.toJson()).toList(),
      'tasks': tasks.map((task) => task.toJson()).toList(),
      'last_claim_timestamp': claimed.timestampAsInt,
    };
    return data;
  }
}



