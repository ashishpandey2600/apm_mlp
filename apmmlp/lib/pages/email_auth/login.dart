import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../ChatFunctionality/model/usermodel.dart';
import '../Dashboard/Screens/PDF/homepage.dart';
import '../Dashboard/dashboardScreen.dart';
import '../phone_auth/sign_in_with_phone.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool showSpinner = false;
  void login() async {
    String email = emailController.text.trim();
    String password = passController.text.trim();

    if (email == "" || password == "") {
      log("Please enter the credentials");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please enter the credentials"),
        backgroundColor: Colors.green,
      ));
    } else {
      try {
        setState(() {
          showSpinner = true;
        });
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {

          String uid = userCredential.user!.uid;
          DocumentSnapshot userData = await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get();
        UserModel  userModel =
              UserModel.fromMap(userData.data() as Map<String, dynamic>);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:  Text("Successfully logged-In"),
            backgroundColor: Colors.green,
          ));
          log("User Logged in");
          setState(() {
            showSpinner = false;
          });
          Navigator.popUntil(
              context,
              (route) => route
                  .isFirst); //closes all pages before current page which is going to be the first
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                  builder: (context) => DashboardScreen(
                      pageIndex:
                          0,
                          userModel: userModel,firebaseUser: userCredential.user!,
                          ))); //becomes the first page after login and replace the login page
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          showSpinner = false;
        });
        if (e.code.toString() == "user-not-found") {
          log("User not found!!");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("invalid-email"),
            backgroundColor: Colors.red,
          ));
        } else if (e.code.toString() == "invalid-email") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("invalid-email"),
            backgroundColor: Colors.red,
          ));
        }
        log(e.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: ListView(
            children: [
              const SizedBox(
                height: 100,
              ),
              const Center(
                child: Text(
                  "A . P . M",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 60,
                      fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Email",
                ),
                controller: emailController,
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(hintText: "Password"),
                controller: passController,
                obscureText: true,
              ),
              const SizedBox(
                height: 50,
              ),
              CupertinoButton(
                child: Text(
                  "Login",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                onPressed: () {
                  login();
                },
                color: Colors.pink,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Text("Don't have an account? "),
                  CupertinoButton(
                      child: const Text("SignUp",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const SignupPage()));
                      })
                ],
              ),
              CupertinoButton(
                  child: const Text("Login via OTP"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const SigninWithPhone()));
                  })
            ],
          ),
        )),
      ),
    );
  }
}
