import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String title;
  String description;
  DateTime deadline;
  bool isCompleted;
  String priority;
  String userId;

  Task({
    this.id = '',
    required this.title,
    required this.description,
    required this.deadline,
    this.isCompleted = false,
    required this.priority,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'deadline': deadline,
      'isCompleted': isCompleted,
      'priority': priority,
      'userId': userId,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      deadline: (map['deadline'] as Timestamp).toDate(),
      isCompleted: map['isCompleted'] ?? false,
      priority: map['priority'] ?? 'medium',
      userId: map['userId'] ?? '',
    );
  }
}
