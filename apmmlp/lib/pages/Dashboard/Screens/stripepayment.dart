import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class PaymentPage extends StatefulWidget {
  final String topay;

  const PaymentPage({super.key, required this.topay});
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool showSpinner = false;
  static const String stripePublishableKey =
      "pk_test_51MgTytSBFYgXPIOlEFMuYRJoQbkRsZKsD4CVwfRF0uetXfJ0jziew5vs2t0qzfct84amgmPDyPdZ4qjFi1yYbsF200VdZuqz1p";
//payment intent Step 1
  late Map<String, dynamic> paymentIntent;

  @override
  void initState() {
    super.initState();
    // Initialize the Stripe SDK with your publishable key
    // Stripe.publishableKey = stripePublishableKey;
    log("Cost to print");
    log(widget.topay.toString());
  }

  Future<void> payment() async {
    setState(() {
      showSpinner = true;
    });
    try {
      Map<String, dynamic> body = {
        'amount': widget.topay.toString(), //its 100.00
        'currency': 'INR',
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization':
              'Bearer sk_test_51MgTytSBFYgXPIOlIDbyBBm4AJ3NxlAgG9TYLxoc9TqDTHnKX5MrF5z0Korl9kqDoRgYDLqMPn353dqv0j7NtI8F00LR2bkEXt',
          'Content-type': 'application/x-www-form-urlencoded'
        },
      );
      paymentIntent = json.decode(response.body);
    } catch (e) {
      throw Exception(e);
    }
    //step 2 Initialize payment sheet

    // var gpay = const PaymentSheetGooglePay(
    //     merchantCountryCode: "INR", currencyCode: "INR", testEnv: true);

    // await Stripe.instance
    //     .initPaymentSheet(
    //         paymentSheetParameters: SetupPaymentSheetParameters(
    //             paymentIntentClientSecret: paymentIntent['client_secret'],
    //             style: ThemeMode.light,
    //             merchantDisplayName: 'APM',
    //             googlePay: gpay))
    //     .then((value) {
    //   print(value.toString());
    // });
    // setState(() {
    //   showSpinner = false;
    // });
    //Step 3 Display payment sheet So the user can make payment

    // try {
    //   await Stripe.instance.presentPaymentSheet().then((value) => {
    //         //Success state
    //         print("payment success")
    //       }); //where u wana u redirect to your user after the payment
    // } catch (e) {
    //   setState(() {
    //     showSpinner = false;
    //   });
    //   throw Exception(e);
    // }

  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stripe payment"),
        backgroundColor: Colors.pink,
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Column(children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "You have to pay ₹${int.parse(widget.topay) / 100} only/-",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
                child: TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.pink)),
              child: Text(
                "Make Payment",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment done"),backgroundColor: Colors.green,));
                Navigator.pop(context);

                // payment();
              },
            )),
          ]),
        ),
      ),
    );
  }
}
