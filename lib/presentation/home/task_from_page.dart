import 'package:flutter/material.dart';

import '../../core/theme/theme.dart';
import '../../data/model/task.dart';
import '../../data/service/database_service.dart';


class TaskForm extends StatefulWidget {
  final String uid;
  final Task? task;

  const TaskForm({
    Key? key,
    required this.uid,
    this.task,
  }) : super(key: key);

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _deadline;
  late String _priority;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize with existing task data or defaults
    _title = widget.task?.title ?? '';
    _description = widget.task?.description ?? '';
    _deadline = widget.task?.deadline ?? DateTime.now().add(Duration(days: 1));
    _priority = widget.task?.priority ?? 'medium';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Create Task'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    TextFormField(
                      initialValue: _title,
                      decoration: InputDecoration(
                        labelText: 'Task Title',
                        hintText: 'Enter the task title',
                        prefixIcon: Icon(Icons.title),
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Please enter a title' : null,
                      onChanged: (val) {
                        setState(() => _title = val);
                      },
                    ),
                    SizedBox(height: 16),

                    // Priority
                    DropdownButtonFormField<String>(
                      value: _priority,
                      decoration: InputDecoration(
                        labelText: 'Priority',
                        prefixIcon: Icon(Icons.flag),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'low',
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: AppTheme.priorityLow,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('Low'),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'medium',
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: AppTheme.priorityMedium,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 8),
                                Text('Medium'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'high',
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: AppTheme.priorityHigh,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text('High'),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (val) {
                          setState(() => _priority = val!);
                        },
                      ),
                      SizedBox(height: 16),

                      // Deadline
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Deadline',
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '${_deadline.day}/${_deadline.month}/${_deadline.year}',
                              ),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),

                      // Description
                      TextFormField(
                        initialValue: _description,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Enter task details',
                          alignLabelWithHint: true,
                          prefixIcon: Icon(Icons.description),
                        ),
                        maxLines: 5,
                        validator:
                            (val) =>
                                val!.isEmpty
                                    ? 'Please enter a description'
                                    : null,
                        onChanged: (val) {
                          setState(() => _description = val);
                        },
                      ),
                      SizedBox(height: 32),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () => _submitForm(),
                          child: Text(
                            isEditing ? 'Update Task' : 'Create Task',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != _deadline) {
      setState(() {
        _deadline = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        if (widget.task != null) {
          // Update existing task
          Task updatedTask = Task(
            id: widget.task!.id,
            title: _title,
            description: _description,
            deadline: _deadline,
            isCompleted: widget.task!.isCompleted,
            priority: _priority,
            userId: widget.uid,
          );
          await DatabaseService(uid: widget.uid).updateTask(updatedTask);
        } else {
          // Create new task
          Task newTask = Task(
            id: '', // Will be set by Firestore
            title: _title,
            description: _description,
            deadline: _deadline,
            isCompleted: false,
            priority: _priority,
            userId: widget.uid,
          );
          await DatabaseService(uid: widget.uid).addTask(newTask);
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}
