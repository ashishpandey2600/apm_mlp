import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SigninWithPhone extends StatefulWidget {
  const SigninWithPhone({super.key});

  @override
  State<SigninWithPhone> createState() => _SigninWithPhoneState();
}

class _SigninWithPhoneState extends State<SigninWithPhone> {
  TextEditingController phnumController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP based Login"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextFormField(
              controller: phnumController,
              decoration: InputDecoration(
                  hintText: "Phone Number ", labelText: "Phone Number"),
            ),
            SizedBox(
              height: 20,
            ),
            CupertinoButton(
              child: Text("Get OTP"),
              onPressed: () {},
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }
}
