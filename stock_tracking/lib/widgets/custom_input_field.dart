// import 'package:flutter/material.dart';

// class CustomInputField extends StatelessWidget {
//   final TextEditingController controller;
//   final String labelText;
//   final bool obscureText;

//   const CustomInputField({
//     super.key,
//     required this.controller,
//     required this.labelText,
//     this.obscureText = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         labelText: labelText,
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final Widget? suffixIcon;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
