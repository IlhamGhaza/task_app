import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/core/widget/shimmer_loading.dart';

import '../../core/theme/theme.dart';
import '../../core/widget/loading.dart';
import '../../data/auth_local_datasource.dart';
import '../../data/model/task.dart';
import '../../data/service/auth_service.dart';
import '../../data/service/database_service.dart';
import '../account/setting_page.dart';
import '../auth/wrapper.dart';
import 'task_detail_page.dart';
import 'task_from_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  String? _uid;
  final _authLocalDatasource = AuthLocalDatasource();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final token = await _authLocalDatasource.getToken();
    //print('Loaded token: $token'); // Debug log
    setState(() {
      _uid = token;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _uid == null) {
      return Loading();
    }

    Provider.of<AuthService>(context);
    Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Task Manager'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              setState(() => _isLoading = true);
              await _authLocalDatasource.deleteToken();
              // await authService.signOut();
              setState(() => _isLoading = false);
              //push to login page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Wrapper()),
              );
            },
          ),
        ],
      ),
      body: _buildBody(_uid!),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.task_alt), label: 'Tasks'),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Completed',
          ),
          //setting page
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton:
          _selectedIndex < 2
              ? FloatingActionButton(
                onPressed: () {
                  _navigateToTaskForm(context, _uid!);
                },
                tooltip: 'Add Task',
                child: Icon(Icons.add),
              )
              : null,
    );
  }

  Widget _buildBody(String uid) {
    switch (_selectedIndex) {
      case 0:
        return _buildTaskList(uid, false);
      case 1:
        return _buildTaskList(uid, true);
      case 2:
        return SettingPage();
      case 3:
        // return AccountPage();
        return Center(child: Text('Account page'));
      default:
        return _buildTaskList(uid, false);
    }
  }

  Widget _buildTaskList(String uid, bool showCompleted) {
    return StreamBuilder<List<Task>>(
      stream: DatabaseService(uid: uid).tasks,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ShimmerLoading(child: Container());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState(showCompleted);
        } else {
          final tasks =
              snapshot.data!
                  .where((task) => task.isCompleted == showCompleted)
                  .toList();

          tasks.sort((a, b) => a.deadline.compareTo(b.deadline));

          if (tasks.isEmpty) {
            return _buildEmptyState(showCompleted);
          }

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              Task task = tasks[index];
              return _buildTaskCard(context, task, uid);
            },
          );
        }
      },
    );
  }

  Widget _buildEmptyState(bool showCompleted) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            showCompleted ? Icons.check_circle_outline : Icons.task_alt,
            size: 64,
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            showCompleted
                ? 'No completed tasks yet'
                : 'No pending tasks. Add one now!',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task, String uid) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final isOverdue = !task.isCompleted && task.deadline.isBefore(now);

    return Card(
      child: InkWell(
        onTap: () {
          _navigateToTaskDetails(context, task, uid);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: theme.textTheme.titleMedium!.copyWith(
                        decoration:
                            task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.getPriorityColor(
                        task.priority,
                      ).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.priority.toUpperCase(),
                      style: TextStyle(
                        color: AppTheme.getPriorityColor(task.priority),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                task.description,
                style: theme.textTheme.bodyMedium!.copyWith(
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color:
                            isOverdue
                                ? theme.colorScheme.error
                                : theme.colorScheme.secondary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${task.deadline.day}/${task.deadline.month}/${task.deadline.year}',
                        style: TextStyle(
                          color: isOverdue ? theme.colorScheme.error : null,
                          fontWeight: isOverdue ? FontWeight.bold : null,
                        ),
                      ),
                      if (isOverdue) ...[
                        SizedBox(width: 4),
                        Text(
                          'Overdue',
                          style: TextStyle(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                  Checkbox(
                    value: task.isCompleted,
                    activeColor: theme.primaryColor,
                    onChanged: (val) async {
                      Task updatedTask = Task(
                        id: task.id,
                        title: task.title,
                        description: task.description,
                        deadline: task.deadline,
                        isCompleted: val!,
                        priority: task.priority,
                        userId: uid,
                      );
                      await DatabaseService(uid: uid).updateTask(updatedTask);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToTaskDetails(BuildContext context, Task task, String uid) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetails(task: task, uid: uid),
      ),
    );
  }

  void _navigateToTaskForm(BuildContext context, String uid) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskForm(uid: uid)),
    );
  }
}
