import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:http/http.dart' as http;

import '../../../../main.dart';
import '../../../ChatFunctionality/model/usermodel.dart';
import '../stripepayment.dart';
import 'model/costmodel.dart';
import 'model/uploadPdfModel.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomePage(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController userkeycontroller = TextEditingController();
  String userkey = "0000";
  String pdfurl = "";
  String transactionid = "N/A";
  String responseCode = "N/A";
  String status = "FALIURE";

  CostModel costModel = CostModel();

  bool showspinner = false;
  File? myfile;
  void uploadPdfLink(
      BuildContext context,
      String pdfurl,
      String pdfid,
      String transactionid,
      String pagecount,
      String price,
      String opacity) async {
    UploadPdfModel uploadPdfModel = UploadPdfModel(
      docid: userkey,
      userid: widget.userModel.uid,
      pdfurl: pdfurl,
      pdfid: pdfid,
      transactionid: transactionid,
      pagecount: pagecount,
      price: price,
      opacity: opacity,
      uploadedon: DateTime.now(),
    );

    FirebaseFirestore.instance
        .collection("pdfs")
        .doc(userkey)
        .set(uploadPdfModel.toMap());
    log("Data Uploaded!!");
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "File Uploaded!",
        selectionColor: Colors.white,
      ),
      backgroundColor: Colors.green,
    ));
  }

  Future<String> uploadPdf(String fileName, File file) async {
    setState(() {
      showspinner = true;
    });
    final refrence = FirebaseStorage.instance.ref().child("pdfs/$fileName.pdf");

    final uploadTask = refrence.putFile(file);

    await uploadTask.whenComplete(() => {});

    final downloadlink = await refrence.getDownloadURL();
    setState(() {
      showspinner = false;
    });

    return downloadlink;
  }

  void pickfile() async {
    final pickedFile = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (pickedFile != null) {
      String fileName = pickedFile.files[0].name;

      File file = File(pickedFile.files[0].path!);
      myfile = File(pickedFile.files[0].path!);
      final downloadlink = await uploadPdf(fileName, file);
      pdfurl = downloadlink;
      // getdata(pdfurl);
    }
  }

  void cleanAll() {
    setState(() {
      pdfurl = "";
      myfile = null;
      costModel.cost = null;
      transactionid == "N/A";
    });
  }

  getdata(String urlStr) async {
    log("Pdf url in get cost function");
    log(urlStr);
    var body = jsonEncode({'pdfurl': urlStr});
    setState(() {
      showspinner = true;
    });

    try {
      final response = await http.post(
          Uri.parse("https://nxs1qkpj-2000.inc1.devtunnels.ms/price"),
          body: body,
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          });
      log(response.body.toString());

      if (response.statusCode == 200) {
        setState(() {
          costModel = CostModel.fromJson(jsonDecode(response.body));
          log(costModel.cost.toString());
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("some error occured")));

        throw Exception();
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() {
      showspinner = false;
    });
  }
  //Paytm code

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            // CupertinoButton(child: const Icon(Icons.clear_all), onPressed: cleanAll),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  const Text(
                    " To clear buffer kindly press ",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 42, 110, 44)),
                  ),
                  TextButton(
                      onPressed: cleanAll, child: const Text("Reset Fields")),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "*Enter a unique Userkey before selecting the PDF",
                style:
                    TextStyle(fontWeight: FontWeight.w900, color: Colors.red),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: userkeycontroller,
              decoration: const InputDecoration(
                  labelText: "Userkey",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink),
                      borderRadius: BorderRadius.all(Radius.circular(12)))),
            ),
            const SizedBox(
              height: 50,
            ),

            CupertinoButton(
              child: (showspinner)
                  ? Row(
                      children: [
                        const Text("Uploading "),
                        Expanded(
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              color: Colors.pink,
                            ),
                          )),
                        )
                      ],
                    )
                  : Text(" 1 . Select PDF"),
              onPressed: () {
                if (myfile == null && userkeycontroller.text.isNotEmpty) {
                  pickfile();
                  userkey = userkeycontroller.text.trim();
                  userkeycontroller.clear();
                }
              },
              color: (myfile == null) ? Colors.pink : Colors.grey,
            ),

            (costModel.cost != null)
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Color.fromARGB(255, 241, 217, 225),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "1 . Cost :  ${costModel.cost.toString()} ₹",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "2 . Page Count:  ${costModel.pagecount.toString()} pages",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              "3 . Opacity : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.clip,
                            ),
                            Text(
                              "${costModel.opacity.toString()} ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.clip,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 20,
            ),

            CupertinoButton(
              child: Text(" 2. Make Payment"),
              onPressed: () {
                if (costModel.cost != null) {
                  int i = costModel.cost!.ceil() * 100;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              // PaymentPage(topay: costModel.cost.toString())));
                              PaymentPage(topay: i.toString())));
                }

                setState(() {
                  transactionid = "forTEst";
                });
              },
              color: Colors.pink,
            ),
            SizedBox(
              height: 20,
            ),

            CupertinoButton(
              child: Text("3 . Final Upload PDF"),
              onPressed: () {
                uploadPdfLink(
                    context,
                    pdfurl,
                    uuid.v1(),
                    transactionid,
                    "costModel.pagecount.toString()",
                    " costModel.cost.toString()",
                    "costModel.opacity.toString()");
                cleanAll();
              },
              color: Colors.pink,
            )
          ],
        ),
      ),
    );
  }
}
