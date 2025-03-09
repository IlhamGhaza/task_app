import 'package:flutter/material.dart';

import '../../core/theme/theme.dart';
import '../../data/model/task.dart';
import '../../data/service/database_service.dart';
import 'task_from_page.dart';


class TaskDetails extends StatelessWidget {
  final Task task;
  final String uid;

  const TaskDetails({Key? key, required this.task, required this.uid})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOverdue =
        !task.isCompleted && task.deadline.isBefore(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskForm(uid: uid, task: task),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmation(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Priority Badge
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.getPriorityColor(
                    task.priority,
                  ).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  task.priority.toUpperCase(),
                  style: TextStyle(
                    color: AppTheme.getPriorityColor(task.priority),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Title
            Text(task.title, style: theme.textTheme.titleLarge),
            SizedBox(height: 8),

            // Deadline
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color:
                      isOverdue ? theme.colorScheme.error : theme.primaryColor,
                ),
                SizedBox(width: 8),
                Text(
                  'Due: ${task.deadline.day}/${task.deadline.month}/${task.deadline.year}',
                  style: TextStyle(
                    color: isOverdue ? theme.colorScheme.error : null,
                    fontWeight: isOverdue ? FontWeight.bold : null,
                  ),
                ),
                if (isOverdue) ...[
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'OVERDUE',
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 24),

            // Status
            Row(
              children: [
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
                    Navigator.pop(context);
                  },
                ),
                Text(
                  task.isCompleted ? 'Completed' : 'Mark as Complete',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 16),

            // Description Header
            Text('Description', style: theme.textTheme.titleMedium),
            SizedBox(height: 8),

            // Description
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(task.description, style: theme.textTheme.bodyLarge),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Delete Task',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            content: Text('Are you sure you want to delete this task?'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'Delete',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                onPressed: () async {
                  await DatabaseService(uid: uid).deleteTask(task.id);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  }
}
