import 'dart:async';

import 'package:flutter_todo_app/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  int start = 30;
  bool wait = false;
  String buttonName = "Send";
  AuthClass authClass = AuthClass();
  String verificationIdFinal = "";
  String smsCode = "";
  String phoneNumber = "";

  void onPressContinue() {
    if (phoneNumber.isEmpty) {
      showSnackBar("Please, Enter your phone number.");
      return;
    }
    if (smsCode.length != 6) {
      showSnackBar("Please, Enter OTP!");
      return;
    }
    authClass.signInwithPhoneNumber(verificationIdFinal, smsCode, context);
  }

  void onPressSend() async {
    if (!wait) {
      if (phoneNumber.isEmpty) {
        showSnackBar("Please, Enter your phone number.");
        return;
      }
      setState(() {
        start = 30;
        wait = true;
        buttonName = "Resend";
      });
      await authClass.verifyPhoneNumber(phoneNumber, context, setData);
      // setData("123456");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Sign In With Phone",
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 50),
              textField(),
              const SizedBox(height: 30),
              SizedBox(
                width: MediaQuery.of(context).size.width - 30,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey,
                        margin: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                    const Text(
                      "Enter 6 digit OTP",
                      style: TextStyle(fontSize: 16),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              otpField(),
              const SizedBox(height: 40),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: "Send OTP again in ",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    TextSpan(
                      text: "00:$start",
                      style: const TextStyle(
                          fontSize: 16, color: Colors.pinkAccent),
                    ),
                    const TextSpan(
                      text: " seconds ",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: MediaQuery.of(context).size.width - 60,
                height: 60,
                child: OutlinedButton(
                  onPressed: onPressContinue,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.login),
                      SizedBox(width: 10),
                      Text(
                        "Continue",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void startTimer() {
    const onsec = Duration(seconds: 1);
    Timer _ = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  Widget otpField() {
    return OTPTextField(
      length: 6,
      width: MediaQuery.of(context).size.width - 34,
      fieldWidth: 58,
      otpFieldStyle: OtpFieldStyle(
          backgroundColor: Theme.of(context).colorScheme.surface,
          enabledBorderColor: Theme.of(context).colorScheme.onSurface),
      style: TextStyle(
          fontSize: 17, color: Theme.of(context).colorScheme.onBackground),
      textFieldAlignment: MainAxisAlignment.spaceAround,
      fieldStyle: FieldStyle.box,
      onCompleted: (pin) {
        print("Completed: " + pin);
        setState(() {
          smsCode = pin;
        });
      },
    );
  }

  Widget textField() {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: IntlPhoneField(
        languageCode: "en",
        disableLengthCheck: true,
        onChanged: (phone) {
          phoneNumber = phone.completeNumber;
        },
        onCountryChanged: (country) {
          print('Country changed to: ' + country.name);
        },
        decoration: InputDecoration(
          label: const Text(
            "Phone Number",
            style: TextStyle(fontSize: 17),
          ),
          border: const OutlineInputBorder(),
          suffixIcon: InkWell(
            onTap: onPressSend,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Text(
                buttonName,
                style: TextStyle(
                  color: wait
                      ? Colors.grey
                      : Theme.of(context).colorScheme.onBackground,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        initialCountryCode: 'BD',
      ),
    );
  }

  void setData(String verificationId, Exception? error) {
    if (verificationId.isEmpty) {
      resetTimer();
      return;
    }
    setState(() {
      verificationIdFinal = verificationId;
    });
    startTimer();
  }

  void showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ));
  }

  void resetTimer() {
    setState(() {
      wait = false;
    });
  }
}
