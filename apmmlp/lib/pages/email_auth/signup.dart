
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../ChatFunctionality/model/usermodel.dart';
import 'completeprofilepage.dart';


class SignupPage extends StatefulWidget {
  final UserModel? userModel;
  final User? firebaseUser;

  const SignupPage({super.key, this.userModel, this.firebaseUser});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController cnfpassController = TextEditingController();
  TextEditingController databasenameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  File? profilepic;
  bool indicator = false;

  // void saveUser() async {
  //   String name = nameController.text.trim();
  //   String password = passController.text.trim();
  //   String email = emailController.text.trim();
  //   String age = ageController.text.trim();
  //   Var1.databaseName = databasenameController.text.trim();

  //   nameController.clear();
  //   emailController.clear();
  //   ageController.clear();
  //   databasenameController.clear();
  //   if (name != "" && email != "" && age != "" && profilepic != null) {
  //     UploadTask uploadTask = FirebaseStorage.instance
  //         .ref()
  //         .child("profilePictures")
  //         .child(Uuid().v1())
  //         .putFile(profilepic!);

  //     StreamSubscription taskSubscription =
  //         uploadTask.snapshotEvents.listen((snapshot) {
  //       double percentage =
  //           snapshot.bytesTransferred / snapshot.totalBytes * 100;
  //       log(percentage.toString());
  //     });

  //     TaskSnapshot taskSnapshot = await uploadTask;
  //     String downloadUrl = await taskSnapshot.ref.getDownloadURL();

  //     taskSubscription.cancel();
  //     Var1.duuid = Uuid().v1();

  //     Map<String, dynamic> userData = {
  //       "email": email,
  //       "name": name,
  //       "age": age,
  //       "profilepic": downloadUrl,
  //       "Password": password,
  //       "authuid": Var1.authuid
  //       // "samplearray": ["123456", Var1.link]
  //     };
  //     await FirebaseFirestore.instance.collection("users").add(userData);

  //     log("User Created!!");
  //   } else {
  //     log("Please fill all the fields!");
  //   }
  //   setState(() {
  //     profilepic = null;
  //   });
  // }

  void createAccount() async {
    String email = emailController.text.trim();
    String password = passController.text.trim();
    String cnfpassword = cnfpassController.text.trim();

    if (email == "" || password == "" || cnfpassword == "") {
      log("Please fill all details!");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please fill all details"),
        backgroundColor: Colors.green,
      ));
    } else if (password != cnfpassword) {
      log("Password do not match!");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Password do not match!"),
        backgroundColor: Colors.red,
      ));
    } else {
      try {
        setState(() {
          indicator = true;
        });
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
      

        // saveUser();
        if (userCredential.user != null) {
          String uid = userCredential.user!.uid;
          UserModel newUser =
              UserModel(uid: uid, email: email, fullname: "", profilepic: "");
        
          await FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .set(newUser.toMap())
              .then((value) {
            setState(() {
              indicator = false;
            });
            log(userCredential.toString());
            log("User Created");
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("New User Created"),
              backgroundColor: Colors.green,
            ));
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return  CompleteProfile(userModel:newUser,firebaseUser: userCredential.user!,);
            }));
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          indicator = false;
        });
        if (e.code.toString() == "weak-password") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("weak-password"),
            backgroundColor: Colors.red,
          ));
        }else  if (e.code.toString() == "The email address is already in use by another account.") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("The email address is already in use by another account."),
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
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text("SignUp"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: indicator,
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              // CupertinoButton(
              //   onPressed: () async {
              //     XFile? selectedImage =
              //         await ImagePicker().pickImage(source: ImageSource.camera);
              //     if (selectedImage != null) {
              //       File covertedFile = File(selectedImage.path);
              //       setState(() {
              //         profilepic = covertedFile;
              //       });
              //       log("Image Selected!");
              //     }

              //     if (selectedImage != null) {
              //       log("Image selected");
              //     } else {
              //       log("No image Selected!");
              //     }
              //   },
              //   child: Padding(
              //     padding: EdgeInsets.zero,
              //     child: CircleAvatar(
              //       radius: 40,
              //       backgroundImage:
              //           (profilepic != null) ? FileImage(profilepic!) : null,
              //       backgroundColor: Colors.grey,
              //     ),
              //   ),
              // ),
              // TextField(
              //   controller: nameController,
              //   decoration: InputDecoration(hintText: "Name"),
              // ),
              const SizedBox(
                height: 150,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(hintText: "Email"),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // TextField(
              //   controller: ageController,
              //   decoration: InputDecoration(hintText: "Age"),
              // ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(hintText: "Password"),
                controller: passController,
                obscureText: true,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(hintText: "Confirm Password"),
                controller: cnfpassController,
                obscureText: true,
                validator: (value) {
                  if (passController.text.trim() != value.toString().trim()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Password Does not match!!")));
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CupertinoButton(
                child: Text(
                  "SignUp",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  createAccount();
                },
                color: Colors.pink,
              ),
              Row(children: [
                const Text("        Already have account?"),
                CupertinoButton(
                    child: const Text(
                      "LogIn",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ])
            ],
          ),
        )),
      ),
    );
  }
}
