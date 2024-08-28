import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/buttons/custom_button.dart';
import 'package:flash_chat/components/inputs/custom_text_field.dart';
import 'package:flash_chat/components/widgets/register_option_widget.dart';
import 'package:flash_chat/model/user_model.dart';
import 'package:flash_chat/presentation/home_view/home_view.dart';
import 'package:flash_chat/presentation/login_view/login_view.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  String? email;
  String? password;
  String? userName;

  final users = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth auth = FirebaseAuth.instance;
  // final User? currentUser = auth.currentUser;

  Future registerEmail() async {
    try {
      final UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      addUser(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
    } catch (e) {
      log('$e');
    }
  }

  Future<DocumentReference<Map<String, dynamic>>> addUser(
      UserCredential userCredential) async {
    final User user = auth.currentUser!;
    final uid = user.uid;
    const menBergenID = 'A1A2A3B4';
    final userModel = UserModel(
      userName: userName!,
      userId: menBergenID,
      email: email,
      password: password,
    );
    final userData = await users
        .doc(menBergenID)
        .set(userModel.toFirebase(),)
        // .add(
        //   userModel.toFirebase(),
        // )
        .then((onValue) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeView(
                  userModel: userModel,
                ),
              ),
            ));
    log('userModel --> ${userModel.userName}');
    return userData;
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
                onChanged: (value) {
                  userName = value;
                  log('email --> $userName');
                },
                hintText: 'Атыныз',
              ),
              SizedBox(
                height: height * 0.009,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  validator: (value) {
                    // add your custom validation here.
                    if (value!.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (value.length < 3) {
                      return 'Must be more than 2 charater';
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: 'Почта',
                    fillColor: Colors.white70,
                  ),
                  onChanged: (value) {
                    email = value;
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.009,
          ),
          CustomTextField(
            onChanged: (value) {
              password = value;
              log('email --> $password');
            },
            hintText: 'Сырдык соз',
            // validator: (value) {
            //   if (value!.isEmpty) {
            //     return 'Пачтаны жаз!';
            //   }
            // },
          ),
          SizedBox(
            height: height * 0.009,
          ),
          CustomTextField(
            onChanged: (value) {
              password = value;
              log('email --> $password');
            },
            hintText: 'Сырдык созду тастыктоо',
          ),
          RegisterOptionWidget(
            text2: 'Катталган болсонуз?',
            text: 'Кириш',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginView()));
            },
          ),
          SizedBox(
            height: height * 0.1,
          ),
          CustomButton(
            data: "Катталуу",
            onPressed: () {
              registerEmail();
            },
          ),
        ],
      ),
    );
  }
}
