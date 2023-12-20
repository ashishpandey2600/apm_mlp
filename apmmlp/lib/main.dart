import 'package:apmmlp/pages/ChatFunctionality/model/FirebaseHelper.dart';
import 'package:apmmlp/pages/ChatFunctionality/model/usermodel.dart';
import 'package:apmmlp/pages/email_auth/login.dart';
import 'package:apmmlp/services/notification_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';
import 'firebase_options.dart';
import 'pages/Dashboard/dashboardScreen.dart';

var uuid = const Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificatrionService.initialise();
//   FirebaseFirestore _firestore = await FirebaseFirestore.instance;
// //Fetching data from snapshot
//   QuerySnapshot snapshot = await _firestore
//       .collection('users')
//       .get(); //Go to users collection in firebase and get all users

//   for (var doc in snapshot.docs) {
//     log(doc.data().toString());
//   }

// //to only get user by id
//   DocumentSnapshot documentSnapshot =
//       await _firestore.collection('users').doc("7yCcUaUj2scc5TyhiWmt").get();
//   log(documentSnapshot.data().toString());

//   //pushing the data to firebase
//   Map<String, dynamic> newUserData = {
//     "name": "mlptechster",
//     "email": "mlptechster@gmail.com"
//   };
//   Map<String, dynamic> newUserData2 = {
//     "name": "mlptechster1",
//     "email": "mlptechster1@gmail.com"
//   };
//   //Allotment of random Id
//   await _firestore.collection("users").add(newUserData);
//   log("New User saved! ");

//   //What if want to give our own Id
//   await _firestore.collection("users").doc("My-Own-Id").set(newUserData2);
//   log("New user created");

// //to update user
//   await _firestore
//       .collection("users")
//       .doc("My-Own-Id")
//       .update({"email": "mlptechster2@gmail.com"});
//   log("User Updated!");

//   // TO delete user
//   await _firestore.collection("users").doc("My-Own-Id").delete();
//   log("User Updated!");
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    UserModel? thisUserModel = await FirebaseHelper.getUserModelById(user.uid);
    if (thisUserModel != null) {
      runApp(MyAppLoggedIn(userModel: thisUserModel, firebaseUser: user));
    } else {
      runApp(const MyApp());
    }
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: LoginPage());
  }
}

class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggedIn(
      {super.key, required this.userModel, required this.firebaseUser});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Use either Theme.AppCompat or Theme.MaterialComponents
          primarySwatch: Colors.pink,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: PaymentPage(topay: "1221"));
    home: DashboardScreen(
      pageIndex: 0,
      userModel: userModel,
      firebaseUser: firebaseUser,
    ));
  
  }
}
