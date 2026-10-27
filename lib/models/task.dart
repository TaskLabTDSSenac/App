class Task {
  final int id;
  final String title;
  final String? description;
  final bool completed;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
  });
  factory Task.fromJson(dynamic json) {
    if (json is! Map ||
        json['id'] is! int ||
        json['id'] <= 0 ||
        json['title'] is! String ||
        !json.containsKey('description') ||
        (json['description'] != null && json['description'] is! String) ||
        json['completed'] is! bool ||
        json['created_at'] is! String ||
        json['updated_at'] is! String) {
      throw const FormatException('Resposta de tarefa inválida.');
    }
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
