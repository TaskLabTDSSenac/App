import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;
  final bool newPassword;
  const PasswordField({
    super.key,
    required this.controller,
    required this.label,
    required this.validator,
    this.newPassword = false,
  });
  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscure = true;
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: widget.controller,
    obscureText: obscure,
    enableSuggestions: false,
    autocorrect: false,
    validator: widget.validator,
    autofillHints: [
      widget.newPassword ? AutofillHints.newPassword : AutofillHints.password,
    ],
    decoration: InputDecoration(
      labelText: widget.label,
      suffixIcon: IconButton(
        tooltip: obscure
            ? 'Mostrar ${widget.label.toLowerCase()}'
            : 'Ocultar ${widget.label.toLowerCase()}',
        onPressed: () => setState(() => obscure = !obscure),
        icon: Icon(
          obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
      ),
    ),
  );
}
