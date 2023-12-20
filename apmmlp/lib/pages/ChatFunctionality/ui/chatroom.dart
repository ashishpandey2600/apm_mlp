import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../model/chatroomModel.dart';
import '../model/messageModel.dart';
import '../model/usermodel.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;

  final UserModel userModel;
  final User firebaseUser;

  const ChatRoomPage(
      {super.key,
      required this.targetUser,
      required this.chatroom,
      required this.userModel,
      required this.firebaseUser});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();

    if (msg != "") {
      // Send Message
      MessageModel newMessage = MessageModel(
        messageid: uuid.v1(),
        sender: widget.userModel.uid,
        createdOn: DateTime.now(),
        text: msg,
        seen: false,
      );

      // FirebaseFirestore.instance
      //     .collection("chatroom")
      //     .doc(widget.chatroom.chatroomid)
      //     .collection("message")
      // .doc(newMessage.messageid)
      // .set(newMessage.toMap());

      // widget.chatroom.lastMessage = msg;

      FirebaseFirestore.instance
          .collection("chatroom")
          .doc(widget.chatroom.chatroomid)
          .collection("message")
          .doc(newMessage.messageid)
          .set(newMessage.toMap());

      widget.chatroom.lastmessage = msg;
      FirebaseFirestore.instance
          .collection("chatroom")
          .doc(widget.chatroom.chatroomid)
          .set(widget.chatroom.toMap());

      //uploading the date

      log("Message sent!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage:
                  NetworkImage(widget.targetUser.profilepic.toString()),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(widget.targetUser.fullname.toString()),
          ],
        ),
      ),
      body: SafeArea(
          child: Column(children: [
        //This is where the chats will go

        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chatroom")
                  .doc(widget.chatroom.chatroomid)
                  .collection("message")
                  .orderBy("createdOn", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot datasnapshot = snapshot.data as QuerySnapshot;
                    log(datasnapshot.toString());
                    return ListView.builder(
                        reverse: true,
                        itemCount: datasnapshot.docs.length,
                        itemBuilder: (context, index) {
                          MessageModel currentMessage = MessageModel.fromMap(
                              datasnapshot.docs[index].data()
                                  as Map<String, dynamic>);
                          return Row(
                            mainAxisAlignment:
                                (currentMessage.sender == widget.userModel.uid)
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                            crossAxisAlignment:
                                (currentMessage.sender == widget.userModel.uid)
                                    ? CrossAxisAlignment.start
                                    : CrossAxisAlignment.end,
                            children: [
                              Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: (currentMessage.sender ==
                                            widget.userModel.uid)
                                        ? Colors.pink
                                        : Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                  ),
                                  child: Text(
                                    currentMessage.text.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  )),
                            ],
                          );
                        });
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                          "An error occured! Please check your internet connection"),
                    );
                  } else {
                    return const Center(
                      child: Text("Say hii to your new friend"),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(children: [
              Flexible(
                child: TextField(
                  controller: messageController,
                  maxLines: null,
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: "  Enter message"),
                ),
              ),
              IconButton(
                  onPressed: () {
                    sendMessage();
                  },
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).colorScheme.secondary,
                  )),
            ]),
          ),
        ),
      const  SizedBox(
          height: 10,
        )
      ])),
    );
  }
}
