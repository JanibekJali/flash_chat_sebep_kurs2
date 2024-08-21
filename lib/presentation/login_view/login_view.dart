import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/buttons/custom_button.dart';
import 'package:flash_chat/components/inputs/custom_text_field.dart';
import 'package:flash_chat/components/widgets/register_option_widget.dart';
import 'package:flash_chat/presentation/register_view/register_view.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);
  String? email;
  String? password;
  Future loginUser() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              CustomTextField(
                onChanged: (value) {},
                hintText: 'Пачта',
              ),
            ],
          ),
          SizedBox(
            height: height * 0.009,
          ),
          CustomTextField(
            onChanged: (value) {},
            hintText: 'Сырдык соз',
          ),
          RegisterOptionWidget(
            text2: 'Каттала элек болсонуз?',
            text: 'Катталуу',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterView()));
            },
          ),
          SizedBox(
            height: height * 0.1,
          ),
          CustomButton(data: "Кириш", onPressed: () {}),
        ],
      ),
    );
  }
}
