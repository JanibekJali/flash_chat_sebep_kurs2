import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/model/user_model.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  final UserModel userModel;
  const HomeView({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late String textSms;
  final message = FirebaseFirestore.instance.collection('message');
  Future<DocumentReference<Map<String, dynamic>>> addMessage() async {
    final messageData = await message.add({
      'sms': textSms,
    });
    log('message added -> $textSms');
    return messageData;
  }

  // Future<DocumentReference<Map<String, dynamic>>> getMessage() async {

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User: ${widget.userModel.userName}"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: message.doc('tqAF2kgOTpPfookLgatq').get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              children: [
                Text("SMS: ${data['sms']}"),
                TextField(
                  onChanged: (value) {
                    textSms = value;
                    log('User Input --> $textSms');
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        addMessage();
                      },
                      icon: Icon(
                        Icons.send,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return Text("loading");
        },
      ),
    );
  }
}
