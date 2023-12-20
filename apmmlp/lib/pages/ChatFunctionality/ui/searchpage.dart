import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../model/chatroomModel.dart';
import '../model/usermodel.dart';
import 'chatroom.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchPage(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textController = TextEditingController();

  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
    ChatRoomModel? chatroom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatroom")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.length > 0) {
      //Fetch the existing one
      log("Chatroom already creatred!");

      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      chatroom = existingChatroom;
    } else {
      //create a new one
      ChatRoomModel newChatroom =
          ChatRoomModel(chatroomid: uuid.v1(), lastmessage: "", participants: {
        widget.userModel.uid.toString(): true,
        targetUser.uid.toString(): true,
      });
      await FirebaseFirestore.instance
          .collection("chatroom")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());
      log("newchatroom created");
      chatroom = newChatroom;
    }
    return chatroom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Page"),
        backgroundColor: Colors.pink,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(19),
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(labelText: "Email Address"),
            ),
            SizedBox(
              height: 20,
            ),
            CupertinoButton(
              onPressed: () {
                setState(() {});
              },
              color: Colors.pink,
              child: const Text("search"),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("email", isEqualTo: textController.text)
                    // .collection("message")
                    // .orderBy("createdon", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    log(snapshot.toString());
                    if (snapshot.hasData) {
                      QuerySnapshot datasnapshot =
                          snapshot.data as QuerySnapshot;
                      log(datasnapshot.docs.toString());
                      if (datasnapshot.docs.isNotEmpty) {
                        Map<String, dynamic> userMap =
                            datasnapshot.docs[0].data() as Map<String, dynamic>;
                        UserModel searchedUser = UserModel.fromMap(userMap);
                        return ListTile(
                          onTap: () async {
                            ChatRoomModel? chatRoomModel =
                                await getChatroomModel(searchedUser);
                            if (chatRoomModel != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatRoomPage(
                                          targetUser: searchedUser,
                                          chatroom: chatRoomModel,
                                          userModel: widget.userModel,
                                          firebaseUser: widget.firebaseUser)));
                            }
                          },
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(searchedUser.profilepic!),
                          ),
                          title: Text(searchedUser.fullname.toString()),
                          subtitle: Text(searchedUser.email.toString()),
                          trailing: Icon(Icons.keyboard_arrow_right),
                        );
                      } else {
                        return Text("No result found!");
                      }
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                            "An error occurd! Please check your internet connection"),
                      );
                    } else {
                      return const Center(
                        child: Text("Say hi tp your new friend"),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            )
          ],
        ),
      )),
    );
  }
}
