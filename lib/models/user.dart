class User {
  final int id;
  final String name;
  final String email;
  const User({required this.id, required this.name, required this.email});
  factory User.fromJson(dynamic json) {
    if (json is! Map ||
        json['id'] is! int ||
        json['id'] <= 0 ||
        json['name'] is! String ||
        json['email'] is! String) {
      throw const FormatException('Resposta de usuário inválida.');
    }
    return User(id: json['id'], name: json['name'], email: json['email']);
  }
}
