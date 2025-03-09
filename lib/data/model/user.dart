import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String userId;
  final String name;
  final String email;
  final String bio;
  final DateTime joinDate;

  UserProfile({
    required this.userId,
    required this.name,
    required this.email,
    required this.bio,
    required this.joinDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'bio': bio,
      'joinDate': joinDate,
    };
  }

  static UserProfile fromMap(Map<String, dynamic> map, String uid) {
    return UserProfile(
      userId: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? 'I am using the Task Manager app!',
      joinDate: (map['joinDate'] as Timestamp).toDate(),
    );
  }
}
