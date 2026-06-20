import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class VxCustomTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool isPassword;

  const VxCustomTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return VxBox(
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Vx.slate400),
          prefixIcon: Icon(icon, color: Vx.slate400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    )
    .white.rounded.border(color: Vx.slate200).make();
  }
}
