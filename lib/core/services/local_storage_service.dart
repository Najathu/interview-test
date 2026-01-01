import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';

class LocalStorageService {
  static const String _taskBoxName = 'tasks';
  late Box<Task> _taskBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    _taskBox = await Hive.openBox<Task>(_taskBoxName);
  }

  // Create
  Future<void> addTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  // Read
  List<Task> getAllTasks() {
    return _taskBox.values.toList();
  }

  Task? getTask(String id) {
    return _taskBox.get(id);
  }

  // Update
  Future<void> updateTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  // Delete
  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
  }

  // Get unsynced tasks
  List<Task> getUnsyncedTasks() {
    return _taskBox.values.where((task) => !task.isSynced).toList();
  }

  // Mark task as synced
  Future<void> markAsSynced(String id) async {
    final task = _taskBox.get(id);
    if (task != null) {
      await _taskBox.put(id, task.copyWith(isSynced: true));
    }
  }

  // Clear all tasks
  Future<void> clearAllTasks() async {
    await _taskBox.clear();
  }

  // Get box stream for real-time updates
  Stream<BoxEvent> watchTasks() {
    return _taskBox.watch();
  }
}
