import 'package:dio/dio.dart';
import '../models/task_model.dart';

class ApiService {
  final Dio _dio;
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  ApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: _baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: {'Content-Type': 'application/json'},
            ),
          );

  // Fetch all tasks
  Future<List<Task>> fetchTasks() async {
    try {
      final response = await _dio.get('/todos');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.take(20).map((json) {
          return Task(
            id: json['id'].toString(),
            title: json['title'] as String,
            description: 'Task from API',
            isCompleted: json['completed'] as bool,
            createdAt: DateTime.now(),
            isSynced: true,
          );
        }).toList();
      }
      throw Exception('Failed to fetch tasks');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Create task
  Future<Task> createTask(Task task) async {
    try {
      final response = await _dio.post('/todos', data: task.toJson());
      if (response.statusCode == 201) {
        return task.copyWith(isSynced: true);
      }
      throw Exception('Failed to create task');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Update task
  Future<Task> updateTask(Task task) async {
    try {
      final response = await _dio.put('/todos/${task.id}', data: task.toJson());
      if (response.statusCode == 200) {
        return task.copyWith(isSynced: true);
      }
      throw Exception('Failed to update task');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Delete task
  Future<void> deleteTask(String id) async {
    try {
      final response = await _dio.delete('/todos/$id');
      if (response.statusCode != 200) {
        throw Exception('Failed to delete task');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        return 'Server error: ${e.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      default:
        return 'Network error. Please try again.';
    }
  }
}
