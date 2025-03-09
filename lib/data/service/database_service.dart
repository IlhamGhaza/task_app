import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/task.dart';
import '../model/user.dart';

class DatabaseService {
  final String uid;
  final CollectionReference tasksCollection = FirebaseFirestore.instance.collection('tasks');
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  DatabaseService({required this.uid});

  // Create a new user profile in Firestore
  Future<void> createUserProfile({required String name, required String email}) async {
    return await usersCollection.doc(uid).set({
      'name': name,
      'email': email,
      'bio': 'I am using the Task Manager app!',
      'joinDate': DateTime.now(),
      'userId': uid,
    });
  }

  // Get user profile stream
  Stream<UserProfile> get userProfile {
    return usersCollection.doc(uid).snapshots().map((doc) {
      return UserProfile.fromMap(doc.data() as Map<String, dynamic>, uid);
    });
  }

  // Update user profile
  Future<void> updateUserProfile(UserProfile profile) async {
    return await usersCollection.doc(uid).update(profile.toMap());
  }

  // Get tasks stream
  Stream<List<Task>> get tasks {
    return tasksCollection
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map(_taskListFromSnapshot);
  }

  // Get task statistics
  Stream<Map<String, dynamic>> get taskStats {
    return tasksCollection
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      int total = snapshot.docs.length;
      int completed = snapshot.docs
          .where((doc) => (doc.data() as Map<String, dynamic>)['isCompleted'] == true)
          .length;
      
      return {
        'total': total,
        'completed': completed,
        'pending': total - completed,
      };
    });
  }

  // Task list from snapshot
  List<Task> _taskListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Task.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  // Add a task
  Future<DocumentReference<Object?>> addTask(Task task) async {
    return await tasksCollection.add(task.toMap());
  }

  // Update a task
  Future<void> updateTask(Task task) async {
    return await tasksCollection.doc(task.id).update(task.toMap());
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    return await tasksCollection.doc(taskId).delete();
  }
}
