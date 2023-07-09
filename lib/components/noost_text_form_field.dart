import 'package:flutter/material.dart';

class NoostTextFormField extends StatelessWidget {
  const NoostTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.formKey,
    required this.validator,
    this.maxLines,
  });

  final String hintText;
  final TextEditingController controller;
  final Key formKey;
  final String? Function(String?)? validator;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      key: formKey,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black54),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black54),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black54),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.indigo),
        ),
      ),
    );
  }
}
