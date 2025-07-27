import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import 'home.dart';

class Verify extends StatefulWidget {
  const Verify({super.key, required this.phoneUser, required this.idUser});
  final String phoneUser;
  final String idUser;

  @override
  State<Verify> createState() => _VerifyState();
}

int page = 0;

class _VerifyState extends State<Verify> {

  String otp = "";

  Widget getOTP() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 20 , bottom: MediaQuery.of(context).viewInsets.bottom / 2,),
        decoration: const BoxDecoration(
          color: Color(0xff410000),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Image(
                image: AssetImage("assets/images/verify1.png"),
                width: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "OTP Verification",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "We will send you a one-time password to this mobile number",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.normal),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Your Number",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.normal),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.phoneUser,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              GlassmorphicContainer(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                height: 60,
                margin: const EdgeInsets.only(
                    bottom: 0, top: 70, left: 20, right: 20),
                borderRadius: 50,
                linearGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xffffffff).withOpacity(0.8),
                      const Color(0xffffffff).withOpacity(0.6),
                      const Color(0xffffffff).withOpacity(0.3),
                    ],
                    stops: const [
                      0.5,
                      0.8,
                      1
                    ]),
                border: 0,
                blur: 0,
                borderGradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.8),
                      Colors.white.withOpacity(0.2),
                    ],
                    stops: const [
                      0.5,
                      1
                    ]),
                child: ButtonTheme(
                  child: MaterialButton(
                    minWidth: double.infinity,
                    child: const Text(
                      'Get OTP',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    onPressed: () {
                      setState(() {
                        submitPhoneNumber(context);
                      });
                    },
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  Widget getVerify() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xff410000),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Image(
                image: AssetImage("assets/images/verify2.png"),
                width: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "OTP Verification",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text(
                    "Enter the OTP sent to",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(widget.phoneUser,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              OtpTextField(
                textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
                keyboardType: TextInputType.number,
                numberOfFields: 6,
                borderColor: const Color(0xFF410000),
                showFieldAsBox: true,
                fieldWidth: 50,
                filled: true,
                fillColor: Colors.white,

                onSubmit: (String verificationCode) {
                  setState(() {
                    otp = verificationCode;
                    submitOTP();
                    verify(context);
                    //page = 2;
                  });
                }, // end onSubmit
              ),
              //Text(status,),
              GlassmorphicContainer(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                height: 60,
                margin: const EdgeInsets.only(
                    bottom: 0, top: 70, left: 20, right: 20),
                borderRadius: 50,
                linearGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xffffffff).withOpacity(0.8),
                      const Color(0xffffffff).withOpacity(0.6),
                      const Color(0xffffffff).withOpacity(0.3),
                    ],
                    stops: const [
                      0.5,
                      0.8,
                      1
                    ]),
                border: 0,
                blur: 0,
                borderGradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.8),
                      Colors.white.withOpacity(0.2),
                    ],
                    stops: const [
                      0.5,
                      1
                    ]),
                child: ButtonTheme(
                  child: MaterialButton(
                    minWidth: double.infinity,
                    child: const Text(
                      'Verify',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    onPressed: () {
                      if(verifyTr) {
                        page = 2;
                      }
                    },
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  Widget getSuccess() {

    Navigator.pop(context);
    Timer(const Duration(milliseconds: 2000), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
    });

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xff410000),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Image(
                image: AssetImage("assets/images/verify3.png"),
                width: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Verified",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Your account has been verified successfully",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.normal),
              ),
              GlassmorphicContainer(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                height: 60,
                margin: const EdgeInsets.only(
                    bottom: 0, top: 70, left: 20, right: 20),
                borderRadius: 50,
                linearGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xffffffff).withOpacity(0.8),
                      const Color(0xffffffff).withOpacity(0.6),
                      const Color(0xffffffff).withOpacity(0.3),
                    ],
                    stops: const [
                      0.5,
                      0.8,
                      1
                    ]),
                border: 0,
                blur: 0,
                borderGradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.8),
                      Colors.white.withOpacity(0.2),
                    ],
                    stops: const [
                      0.5,
                      1
                    ]),
                child: ButtonTheme(
                  child: MaterialButton(
                    minWidth: double.infinity,
                    child: const Text(
                      'Done',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                      });
                    },
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  late String status = "";
  late AuthCredential phoneAuthCredential;
  late String verificationID;
  late int code;
  late String errorMessage = "";
  bool verifyTr = false;

  @override
  void initState() {
    super.initState();
  }

  void handleError(e) {
    Navigator.pop(context);
    if (kDebugMode) {
      print(e.message);
    }
    setState(() {
      errorMessage += e.message + '\n';
      status += e.message + '\n';
    });

    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: const Color(0xff560f20),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(image: AssetImage("assets/icons/cancel.png"),width: 60,),
                  // Some text
                  const SizedBox(height: 20),
                  Text(errorMessage,style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),),
                  const SizedBox(height: 20,),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color> (const Color(0xffecd8e0)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }, child: const Text('OK' , style: TextStyle(
                    color: Color(0xff560f20),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),)),
                ],
              ),
            ),
          );
        }
    );

  }

  @override
  Widget build(BuildContext context) {
    if (page == 1) {
      return getVerify();
    } else if (page == 2) {
      return getSuccess();
    } else {
      return getOTP();
    }
  }

  Future<void> submitPhoneNumber(context) async {

    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: const Color(0xff560f20),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(height: 20,),
                  CircularProgressIndicator(color: Color(0xffecd8e0),),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          );
        }
    );

    String phoneNumber = widget.phoneUser;
    if (kDebugMode) {
      print(phoneNumber);
    }

    void verificationCompleted(AuthCredential phoneAuth) {
      if (kDebugMode) {
        print('verificationCompleted');
      }
      setState(() {
        status += 'verificationCompleted\n';
        phoneAuthCredential = phoneAuth;
      });

      if (kDebugMode) {
        print(phoneAuthCredential);
      }
    }

    void verificationFailed(FirebaseAuthException error) {
      Navigator.pop(context);
      if (kDebugMode) {
        print('verificationFailed');
      }
      handleError(error);
      showDialog(
          context: context,
          builder: (_) {
            return Dialog(
              // The background color
              backgroundColor: const Color(0xff560f20),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(image: AssetImage("assets/icons/cancel.png"),width: 60,),
                    // Some text
                    const SizedBox(height: 20),
                    Text(errorMessage,style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),),
                    const SizedBox(height: 20,),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color> (const Color(0xffecd8e0)),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }, child: const Text('OK' , style: TextStyle(
                      color: Color(0xff560f20),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),)),
                  ],
                ),
              ),
            );
          }
      );

    }

    void codeOTPSent(String verificationId, [int? code]) {
      if (kDebugMode) {
        print ('OTP sent') ;
      }

      setState(() {
        verificationID = verificationId;
        this.code = code!;
        status += 'Code Sent\n';
      });

      if (kDebugMode) {
        print(verificationId);
      }
      //this.code = code!;
      if (kDebugMode) {
        print(code.toString());
      }
    }
    
    void codeAutoRetrievalTimout(String verificationId) {
      if (kDebugMode) {
        print('codeAutoRetrievalTimeout');
      }
      setState(() {
        status += 'codeAutoRetrievalTimeout\n';
      });
      if (kDebugMode) {
        print(verificationId);
      }
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
        timeout: const Duration(milliseconds: 3000),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeOTPSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimout
    ).then((value) {
      setState(() {
        page = 1;
      });
    });

    Navigator.pop(context);
  }

  void submitOTP() {

    String smsCode = otp;
    phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: smsCode);
  }
  
  Future<void> verify(context) async {
    if (kDebugMode) {
      print('Verify');
    }
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return Dialog(
              // The background color
              backgroundColor: const Color(0xff560f20),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SizedBox(height: 20,),
                    CircularProgressIndicator(color: Color(0xffecd8e0),),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            );
          }
      );
      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential).then((value) async => await FirebaseFirestore.instance.collection('user').doc(widget.idUser).update(
          {'status' : 'VALID'}));
      setState(() {
        status += 'Signed In\n';
        verifyTr = true;
        page = 2;
      });
      

      if (kDebugMode) {
        print("success");
      }
    }
    on FirebaseAuthException catch(err) {
      Navigator.pop(context);
      String message = "Error";
      if(err.code == "invalid-verification-code") {
        message = "OTP not match";
      }

      showDialog(
          context: context,
          builder: (_) {
            return Dialog(
              // The background color
              backgroundColor: const Color(0xff560f20),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(image: AssetImage("assets/icons/cancel.png"),width: 60,),
                    // Some text
                    const SizedBox(height: 20),
                    Text(message,style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),),
                    const SizedBox(height: 20,),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color> (const Color(0xffecd8e0)),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }, child: const Text('OK' , style: TextStyle(
                      color: Color(0xff560f20),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),)),
                  ],
                ),
              ),
            );
          }
      );

    }
    catch (e) {
      handleError(e);
      if (kDebugMode) {
        print('Error Verify');
      }
      showDialog(
          context: context,
          builder: (_) {
            return Dialog(
              // The background color
              backgroundColor: const Color(0xff560f20),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(image: AssetImage("assets/icons/cancel.png"),width: 60,),
                    // Some text
                    const SizedBox(height: 20),
                    Text(errorMessage,style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),),
                    const SizedBox(height: 20,),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color> (const Color(0xffecd8e0)),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }, child: const Text('OK' , style: TextStyle(
                      color: Color(0xff560f20),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),)),
                  ],
                ),
              ),
            );
          }
      );
    }
  }
}
