import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weatherapp/View/otp.dart';

class LoginPage extends StatefulWidget {
  static String verify = "";
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loding = false;
  final auth = FirebaseAuth.instance;
  TextEditingController numbercontroller = TextEditingController();

  final _fromkey = GlobalKey<FormState>();
  TextEditingController countrycode = TextEditingController();
  var phone = "";
  @override
  void initState() {
    countrycode.text = "+91";
    super.initState();
  }

  verifyPhone() {
    if (countrycode.text.isEmpty) {
      // ignore: deprecated_member_use
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: const Text('snack'),
      // duration:
      const Duration(seconds: 1);
      // action:
      SnackBarAction(
        label: 'ACTION',
        onPressed: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const _initialCountryCode = 'IN';

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(
                        'https://img.freepik.com/free-vector/sky-background-video-conferencing_23-2148639325.jpg'),
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Form(
                  key: _fromkey,
                  child: Column(children: [
                    TextFormField(
                        onChanged: ((value) {
                          phone = value;
                        }),
                        controller: numbercontroller,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black)),
                            prefixText: "(+91)",
                            suffixIcon: const Icon(
                              Icons.check_circle,
                              color: Color.fromARGB(255, 166, 61, 170),
                              size: 32,
                            )),
                        validator: (Value) {
                          if (Value == null || Value.isEmpty) {
                            return 'please enter your mobile number';
                          } else if (Value.length < 10) {
                            return 'please enter your 10 digit mobile number ';
                          }
                          return null;
                        }),
                    SizedBox(height: Get.height * .03),
                    Card(
                        elevation: 5,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Container(
                          height: 50,
                          width: 250,
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 166, 61, 170),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                              child: InkWell(
                            onTap: (() async {
                              verifyPhone();
                              await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber: '${countrycode.text + phone}',
                                verificationCompleted:
                                    (PhoneAuthCredential credential) {},
                                verificationFailed:
                                    (FirebaseAuthException e) {},
                                codeSent:
                                    (String verificationId, int? resendToken) {
                                  LoginPage.verify = verificationId;
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Otp1(
                                              otp: countrycode.text + phone)));
                                },
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {},
                              );
                            }),
                            child: const Text(
                              "SEND OTP",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          )),
                        )),
                  ]),
                ),
              )
            ])));
  }
}
