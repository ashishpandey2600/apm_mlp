import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../ChatFunctionality/model/usermodel.dart';
import 'PDF/model/uploadPdfModel.dart';


class UploadPage extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  const UploadPage(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 80,
        ),
        const Text(
          "Pending APM prints",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("pdfs")
                  .where("userid", isEqualTo: userModel.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data != null) {
                    QuerySnapshot datasnapshot = snapshot.data as QuerySnapshot;
                    return ListView.builder(
                      itemCount: datasnapshot.docs.length,
                      itemBuilder: (context, index) {
                        UploadPdfModel userMap = UploadPdfModel.fromMap(
                            datasnapshot.docs[index].data()
                                as Map<String, dynamic>);
                        log("message");
                        log(datasnapshot.docs[index].data().toString());
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            color: Color.fromARGB(255, 241, 205, 217),
                            shadowColor: Colors.yellow,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    "ToPrintKey ${userMap.docid.toString()}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Text("userid ${userMap.pdfid.toString()}"),
                                  Text("pdfid ${userMap.pagecount.toString()}"),
                                  Text(
                                      "Cost:  ${userMap.price.toString()} ₹  "),
                                  Text(
                                      "transaction ID ${userMap.transactionid.toString()}"),
                                  Text("opacity ${userMap.opacity.toString()}"),
                                  Text(
                                      "uploadedon ${userMap.uploadedon.toString()}"),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    log(snapshot.error.toString());
                    return Center(
                      child: Text(
                          "An error occured! Please check your internet connection"),
                    );
                  } else {
                    return Text("No data to print");
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ],
    );
  }
}
