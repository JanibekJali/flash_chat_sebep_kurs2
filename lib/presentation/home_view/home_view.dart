// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flash_chat/model/chat_model.dart';
// import 'package:flash_chat/model/user_model.dart';
// import 'package:flutter/material.dart';

// class HomeView extends StatefulWidget {
//   final UserModel userModel;
//   const HomeView({
//     Key? key,
//     required this.userModel,
//   }) : super(key: key);

//   @override
//   _HomeViewState createState() => _HomeViewState();
// }

// class _HomeViewState extends State<HomeView> {
//   @override
//   void initState() {
//     getMessage(widget.userModel.userId!);

//     super.initState();
//   }

//   String? textSms;
//   final message = FirebaseFirestore.instance.collection('message');
//   final uid = FirebaseAuth.instance.currentUser!.uid;

//   Future<DocumentReference<Map<String, dynamic>>> addMessage() async {
//     final chatModel = ChatModel(
//       userName: widget.userModel.userName,
//       message: textSms,
//       messageId: widget.userModel.userId,
//     );

//     final chatData = await message.add(
//       chatModel.toMap(),
//     );
//     // .doc(uid).
//     // set(
//     //       chatModel.toMap(),
//     //     );
//     setState(() {});

//     return chatData;
//   }

//   Future<ChatModel> getMessage(String uid) async {
//     try {
//       DocumentSnapshot<Map<String, dynamic>> chatDoc =
//           await message.doc(uid).get();

//       if (chatDoc.exists) {
//         return ChatModel.fromMap(chatDoc.data()!);
//       } else {
//         throw Exception('Chat not found');
//       }
//     } catch (e) {
//       log('Failed to get message data: $e');
//       rethrow;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("User: ${widget.userModel.userName}"),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: 2,
//               itemBuilder: (context, index) {
//                 getMessage(uid);
//                 return Column(
//                   children: [
//                     Text("UserName: ${widget.userModel.userName}  "),
//                     Text("SMS: $textSms "),
//                   ],
//                 );
//               },
//             ),
//           ),
//           TextField(
//             onChanged: (value) {
//               textSms = value;
//               log('User Input --> $textSms');
//             },
//             decoration: InputDecoration(
//               suffixIcon: IconButton(
//                 onPressed: () {
//                   addMessage();
//                 },
//                 icon: Icon(
//                   Icons.send,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/model/chat_model.dart';
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
  String? textSms;
  final message = FirebaseFirestore.instance.collection('message');
  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future<DocumentReference<Map<String, dynamic>>> addMessage() async {
    final chatModel = ChatModel(
      userName: widget.userModel.userName,
      message: textSms,
      messageId: widget.userModel.userId,
    );

    final chatData = await message.add(
      chatModel.toMap(),
    );

    setState(() {});

    return chatData;
  }

  Stream<List<ChatModel>> getChatStream() {
    return message.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ChatModel.fromMap(doc.data());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User: ${widget.userModel.userName}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatModel>>(
              stream: getChatStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No messages yet'));
                }

                final chatList = snapshot.data!;

                return ListView.builder(
                  itemCount: chatList.length,
                  itemBuilder: (context, index) {
                    final chat = chatList[index];
                    return ListTile(
                      title: Text(chat.userName ?? ''),
                      subtitle: Text(chat.message ?? ''),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      textSms = value;
                      log('User Input --> $textSms');
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
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
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.mic,
                    size: 35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
