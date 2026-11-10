import '../models/task.dart';
import 'api_client.dart';

class TaskService {
  final ApiClient api;
  TaskService(this.api);
  Future<List<Task>> list() async {
    final data = await api.request('GET', '/tasks');
    if (data is! List) {
      throw const FormatException('Lista de tarefas inválida.');
    }
    return data.map(Task.fromJson).toList();
  }

  Future<Task> get(int id) async =>
      Task.fromJson(await api.request('GET', '/tasks/$id'));
  Future<Task> save({
    int? id,
    required String title,
    required String description,
  }) async => Task.fromJson(
    await api.request(
      id == null ? 'POST' : 'PUT',
      id == null ? '/tasks' : '/tasks/$id',
      data: {
        'title': title,
        'description': description.isEmpty ? null : description,
      },
    ),
  );
  Future<Task> complete(int id) async =>
      Task.fromJson(await api.request('PATCH', '/tasks/$id/complete'));
  Future<void> delete(int id) async {
    await api.request('DELETE', '/tasks/$id');
  }
}
