import 'package:flutter/material.dart';

class RegisterOptionWidget extends StatelessWidget {
  const RegisterOptionWidget({
    super.key,
    this.onPressed,
    required this.text,
    required this.text2,
  });
  final void Function()? onPressed;
  final String text;
  final String text2;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(text2),
        ElevatedButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
