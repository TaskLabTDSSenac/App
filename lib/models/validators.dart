class Validators {
  static String? email(String? value) =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch((value ?? '').trim())
      ? null
      : 'Informe um e-mail válido.';
  static String? name(String? value) => length(value?.trim(), 1, 150, 'Nome');
  static String? title(String? value) =>
      length(value?.trim(), 3, 150, 'Título');
  static String? password(String? value) => length(value, 8, 128, 'Senha');
  static String? currentPassword(String? value) =>
      length(value, 1, 128, 'Senha atual');
  static String? description(String? value) =>
      length(value, 0, 500, 'Descrição');
  static String? confirmation(String? value, String expected) =>
      value == expected ? null : 'As senhas devem coincidir.';
  static String? length(String? value, int min, int max, String label) {
    final size = (value ?? '').runes.length;
    return size >= min && size <= max
        ? null
        : '$label: informe de $min a $max caracteres.';
  }
}
