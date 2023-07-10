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
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}
