import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../services/connectivity_service.dart';
import 'service_providers.dart';
import 'package:uuid/uuid.dart';

// State class for managing tasks
class TaskState {
  final List<Task> tasks;
  final bool isLoading;
  final String? error;
  final String? successMessage;

  TaskState({
    this.tasks = const [],
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  TaskState copyWith({
    List<Task>? tasks,
    bool? isLoading,
    String? error,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
    );
  }
}

// Main notifier for task operations
class TaskNotifier extends StateNotifier<TaskState> {
  final LocalStorageService _localStorageService;
  final ApiService _apiService;
  final ConnectivityService _connectivityService;

  TaskNotifier(
    this._localStorageService,
    this._apiService,
    this._connectivityService,
  ) : super(TaskState()) {
    _init();
  }

  Future<void> _init() async {
    await loadTasks();
    _listenToConnectivity();
  }

  void _listenToConnectivity() {
    _connectivityService.connectionStatus.listen((isConnected) {
      if (isConnected) {
        _syncTasks();
      }
    });
  }

  // Load all tasks from Hive
  Future<void> loadTasks() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final tasks = _localStorageService.getAllTasks();
      state = state.copyWith(tasks: tasks, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load tasks: $e',
        isLoading: false,
      );
    }
  }

  // Fetch demo tasks from API - clears local storage first
  Future<void> fetchTasksFromApi() async {
    if (!_connectivityService.isConnected) {
      state = state.copyWith(error: 'No internet connection', isLoading: false);
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final apiTasks = await _apiService.fetchTasks();

      // Clear existing tasks first to avoid duplicates
      await _localStorageService.clearAllTasks();

      // Save new tasks from API to local storage
      for (final task in apiTasks) {
        await _localStorageService.addTask(task);
      }

      await loadTasks();
      state = state.copyWith(
        successMessage: 'Fetched ${apiTasks.length} tasks from server',
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch tasks: $e',
        isLoading: false,
      );
    }
  }

  // Add task
  Future<void> addTask(String title, String description) async {
    if (title.trim().isEmpty) {
      state = state.copyWith(error: 'Title cannot be empty');
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final task = Task(
        id: const Uuid().v4(),
        title: title,
        description: description,
        createdAt: DateTime.now(),
        isSynced: false,
      );

      // Save locally first
      await _localStorageService.addTask(task);
      await loadTasks();

      // Try to sync if online
      if (_connectivityService.isConnected) {
        try {
          await _apiService.createTask(task);
          await _localStorageService.markAsSynced(task.id);
          await loadTasks();
        } catch (e) {
          // Task saved locally but not synced
        }
      }

      state = state.copyWith(
        successMessage: 'Task added successfully',
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to add task: $e', isLoading: false);
    }
  }

  // Update task
  Future<void> updateTask(Task task) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final updatedTask = task.copyWith(
        updatedAt: DateTime.now(),
        isSynced: false,
      );

      await _localStorageService.updateTask(updatedTask);
      await loadTasks();

      // Try to sync if online
      if (_connectivityService.isConnected) {
        try {
          await _apiService.updateTask(updatedTask);
          await _localStorageService.markAsSynced(updatedTask.id);
          await loadTasks();
        } catch (e) {
          // Task updated locally but not synced
        }
      }

      state = state.copyWith(
        successMessage: 'Task updated successfully',
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update task: $e',
        isLoading: false,
      );
    }
  }

  // Toggle task completion
  Future<void> toggleTaskCompletion(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await updateTask(updatedTask);
  }

  // Delete task
  Future<void> deleteTask(String id) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      // Delete locally
      await _localStorageService.deleteTask(id);
      await loadTasks();

      // Try to delete from API if online
      if (_connectivityService.isConnected) {
        try {
          await _apiService.deleteTask(id);
        } catch (e) {
          // Task deleted locally but not from server
        }
      }

      state = state.copyWith(
        successMessage: 'Task deleted successfully',
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to delete task: $e',
        isLoading: false,
      );
    }
  }

  // Sync unsynced tasks
  Future<void> _syncTasks() async {
    final unsyncedTasks = _localStorageService.getUnsyncedTasks();

    for (final task in unsyncedTasks) {
      try {
        await _apiService.createTask(task);
        await _localStorageService.markAsSynced(task.id);
      } catch (e) {
        // Continue with next task
      }
    }

    await loadTasks();
  }

  // Clear messages
  void clearMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }
}

// Task Provider
final taskProvider = StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  final localStorage = ref.watch(localStorageServiceProvider);
  final apiService = ref.watch(apiServiceProvider);
  final connectivityService = ref.watch(connectivityServiceProvider);

  return TaskNotifier(localStorage, apiService, connectivityService);
});

// Filtered task providers
final completedTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(taskProvider).tasks;
  return tasks.where((task) => task.isCompleted).toList();
});

final pendingTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(taskProvider).tasks;
  return tasks.where((task) => !task.isCompleted).toList();
});

final unsyncedTasksCountProvider = Provider<int>((ref) {
  final tasks = ref.watch(taskProvider).tasks;
  return tasks.where((task) => !task.isSynced).toList().length;
});
