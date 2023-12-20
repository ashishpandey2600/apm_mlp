import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../ChatFunctionality/model/usermodel.dart';
import '../../ChatFunctionality/ui/searchpage.dart';
import '../../email_auth/login.dart';


class ProfilePage extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const ProfilePage(
      {super.key, required this.userModel, required this.firebaseUser});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ListView(
        children: [
          CircleAvatar(
            radius: 60,
            child: userModel.profilepic == null ? Icon(Icons.person) : null,
            backgroundImage: NetworkImage(
              userModel.profilepic.toString(),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
              child: Text(
            userModel.fullname.toString(),
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
          )),
          const SizedBox(
            height: 100,
          ),
          CupertinoButton(
              color: Colors.red,
              child: Text("Logout"),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.popUntil(
                    context,
                    (route) => route
                        .isFirst); //closes all pages before current page which is going to be the first
                Navigator.pushReplacement(context,
                    CupertinoPageRoute(builder: (context) => LoginPage()));
              }),
          Padding(
            padding: const EdgeInsets.all(100),
            child: FloatingActionButton(
                backgroundColor: Colors.pink,
                child: Icon(Icons.search),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SearchPage(
                        userModel: userModel, firebaseUser: firebaseUser);
                  }));
                }),
          )
        ],
      ),
    );
  }
}
