class UserProfile {
  final String name;
  final String email;
  final String bio;
  final DateTime joinDate;
  final String userId;

  UserProfile({
    required this.name,
    required this.email,
    required this.bio,
    required this.joinDate,
    required this.userId,
  });

  // Factory to create a UserProfile from a Map (Firestore document)
  factory UserProfile.fromMap(Map<String, dynamic> data, String id) {
    return UserProfile(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      bio: data['bio'] ?? '',
      joinDate: data['joinDate']?.toDate() ?? DateTime.now(),
      userId: id,
    );
  }

  // Convert a UserProfile to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'bio': bio,
      'joinDate': joinDate,
      'userId': userId,
    };
  }
}
