import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OtpLoginScreen extends StatefulWidget {
  const OtpLoginScreen({super.key});

  @override
  State<OtpLoginScreen> createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends State<OtpLoginScreen> {
  TextEditingController phnumController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP based Login"),
      ),
      body: Column(
        children: [
         
               TextFormField(
            controller: otpController,
            decoration: InputDecoration(hintText: "OTP",labelText: "OTP" ),
          ),
          SizedBox(height: 20,),
          CupertinoButton(child: Text("verify"), onPressed: (){},color: Colors.blue,)
        ],
      ),
    );
  }
}
