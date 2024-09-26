import 'package:petfight/constants.dart';

class Task {
  final String key;
  int status;
  final String name;
  final String textButton;
  final String? url;
  final int reward;
  
  Task({
    required this.key,
    required this.status,
    required this.name,
    required this.textButton,
    this.url,
    required this.reward,
  });

  String get rewardAsString {
    return " +$reward";
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    String key =  json['task_name'] as String;
    Map<String, dynamic>? taskInfo = taskList[key];
    if (taskInfo == null) {
      throw Exception('Task info for key $key not found in taskList');
    }

    return Task(
      key: key,
      status: json['task_status'] as int,
      name: taskInfo['name'] as String? ?? 'Unknown Task',
      textButton: taskInfo['text_button'] as String? ?? 'Unknown Button',
      url: taskInfo['url'] as String?,
      reward: taskInfo['reward'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task_name': key,
      'task_status': status,
    };
  }
}