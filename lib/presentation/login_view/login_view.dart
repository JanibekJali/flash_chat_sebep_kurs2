import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/buttons/custom_button.dart';
import 'package:flash_chat/components/inputs/custom_text_field.dart';
import 'package:flash_chat/components/widgets/register_option_widget.dart';
import 'package:flash_chat/model/user_model.dart';
import 'package:flash_chat/presentation/home_view/home_view.dart';
import 'package:flash_chat/presentation/register_view/register_view.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);

  String? email;
  String? password;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> loginUser(BuildContext context) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      final userModel = await getUser(userCredential.user!.uid);

      // Navigate to HomeView with userModel after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeView(userModel: userModel),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      } else {
        log('Login failed: ${e.message}');
      }
    }
  }

  Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        return UserModel.fromFirebase(userDoc.data()!);
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      log('Failed to get user data: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(
            onChanged: (value) {
              email = value;
            },
            hintText: 'Пoчта',
          ),
          SizedBox(height: height * 0.009),
          CustomTextField(
            onChanged: (value) {
              password = value;
            },
            hintText: 'Сырдык соз',
          ),
          RegisterOptionWidget(
            text2: 'Каттала элек болсонуз?',
            text: 'Катталуу',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterView()),
              );
            },
          ),
          SizedBox(height: height * 0.1),
          CustomButton(
            data: "Кириш",
            onPressed: () {
              loginUser(context);
            },
          ),
        ],
      ),
    );
  }
}
