import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/phone_model.dart';
import '../models/user_model.dart';
import '../screens/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

RegExp regExp = RegExp(p);
RegExp digitExp = RegExp(r'^[0-9]+$');
RegExp textExp = RegExp(r'^[a-zA-Z_\s\\p{L}]+$');
bool obSerText = true;

final TextEditingController userName = TextEditingController();
final TextEditingController phoneNumber = TextEditingController();
final TextEditingController password = TextEditingController();
final TextEditingController confirmPassword = TextEditingController();

bool isMale = true;
bool isLoading = false;
bool isRegisterSuccessfull = false;
bool isWarning = false;
bool isError = false;

String messageError = "";
String messageWarning = "";

class _RegisterState extends State<Register> {
  bool validateFullName = true;
  bool validatePhone = true;
  bool validatePassword = true;
  bool validateConfirmPass = true;

  void submit(context) async {
    UserCredential result;
    try {
      showDialog(
          context: context,
          builder: (_) {
            return Dialog(
              // The background color
              backgroundColor: const Color(0xff560f20),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SizedBox(
                      height: 20,
                    ),
                    CircularProgressIndicator(
                      color: Color(0xffecd8e0),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            );
          });

      result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: "${phoneNumber.text}@gmail.com", password: password.text);

      UserSQ newUser = UserSQ(
          email: "",
          phone: currentPhoneNumber.value + phoneNumber.text,
          fullName: userName.text,
          address: "",
          status: "INVALID",
          img: "",
          gender: 'Male',
          birthDate: "",
          idUser: result.user!.uid,
          dateEnter: DateTime.now().toString());

      await FirebaseFirestore.instance
          .collection("user")
          .doc(result.user!.uid)
          .set(newUser.toMap());

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("idUser", result.user!.uid);

      Navigator.pop(context);

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return Dialog(
              // The background color
              backgroundColor: const Color(0xff560f20),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Image(
                      image: AssetImage("assets/icons/success.png"),
                      width: 60,
                    ),
                    // Some text
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Register successfully",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            );
          });

      Timer(const Duration(milliseconds: 1500), () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => const Login()));
      });
    } on FirebaseAuthException catch (error) {
      Navigator.of(context).pop();

      var message = "Please Check Your Internet Connection ";

      if (error.code == "email-already-in-use") {
        message = "Phone is registered for another account";
      } else if (error.code == "network-request-failed") {
        message = "Please Check Your Internet Connection";
      }

      setState(() {
        isLoading = false;
      });

      showDialog(
          context: context,
          builder: (_) {
            return Dialog(
              // The background color
              backgroundColor: const Color(0xff560f20),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage("assets/icons/cancel.png"),
                      width: 60,
                    ),
                    // Some text
                    const SizedBox(height: 20),
                    Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xffecd8e0)),
                        ),
                        onPressed: () {
                          setState(() {
                            isError = false;
                            isLoading = false;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'OK',
                          style: TextStyle(
                            color: Color(0xff560f20),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ],
                ),
              ),
            );
          });
    } catch (error) {
      Navigator.of(context).pop();

      setState(() {
        isLoading = false;
      });
    }
  }

  void validation(BuildContext context) async {
    if (userName.text.isEmpty &&
        phoneNumber.text.isEmpty &&
        password.text.isEmpty &&
        phoneNumber.text.isEmpty) {
      setState(() {
        validatePhone = false;
        validateFullName = false;
        validatePassword = false;
        validateConfirmPass = false;
      });
    }

    if (validateConfirmPass) {
      if (validatePassword) {
        if (validateFullName) {
          if (validatePhone) {
            submit(context);
          }
        }
      }
    }
  }

  bool checkPhoneUnique = true;
  bool checkPhone = true;

  PhoneNumber currentPhoneNumber = listPhoneNumber[0];
  String phoneInput = listPhoneNumber[0].value + listPhoneNumber[0].format;

  late final SharedPreferences prefs;

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  Future<void> getPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    List<String> errorMessage = [
      "Full name is only character and not empty",
      "Phone is only ${currentPhoneNumber.digit} number and not empty",
      'Password must least 8 digit and not empty',
      'Confirm Password must equal to Password and not empty',
      'Phone is exist',
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // key: _scaffoldKey,
      body: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom / 2,
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/background_register.jpg"),
          fit: BoxFit.fill,
        )),
        child: SafeArea(
          child: GlassmorphicContainer(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.all(20),
            borderRadius: 20,
            linearGradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.8),
                  Colors.white.withOpacity(0.3),
                ],
                stops: const [
                  0.5,
                  1
                ]),
            border: 0,
            blur: 10,
            borderGradient: const LinearGradient(colors: [
              Colors.white,
              Colors.white,
            ]),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(0),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          ClipPath(
                            clipper: WaveShape(),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.topLeft,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/background_register.jpg"),
                                fit: BoxFit.cover,
                              )),
                              padding:
                                  const EdgeInsets.only(left: 70, right: 70),
                              height: 200,
                            ),
                          ),
                          Column(mainAxisSize: MainAxisSize.max, children: [
                            const Text(
                              "Sign up",
                              style: TextStyle(
                                  color: Color(0xff410000),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: const Text(
                                "Create your new account",
                                style: TextStyle(
                                  color: Color(0xff410000),
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            )
                          ]),
                        ],
                      ),
                    ),

                    // Full name
                    GlassmorphicContainer(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      height: 60,
                      margin: const EdgeInsets.only(
                          bottom: 10, top: 0, left: 20, right: 20),
                      borderRadius: 50,
                      linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.8),
                            Colors.white.withOpacity(0.6),
                            Colors.white.withOpacity(0.2),
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
                      child: TextField(
                        onChanged: (text) {
                          if (text.isEmpty || textExp.hasMatch(text)) {
                            setState(() {
                              validateFullName = true;
                            });
                          } else {
                            setState(() {
                              validateFullName = false;
                            });
                          }
                        },
                        cursorColor: const Color(0xff410000),
                        style: const TextStyle(
                          letterSpacing: 1,
                          fontSize: 20,
                          color: Color(0xff410000),
                        ),
                        controller: userName,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: 'Full Name',
                          prefixIcon: Icon(
                            Icons.account_circle,
                            color: Color(0xff7c0019),
                            size: 30,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !validateFullName,
                      child: Column(
                        children: [
                          Text(
                            errorMessage[0],
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.redAccent,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    // Phone Number
                    GlassmorphicContainer(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      height: 60,
                      margin: const EdgeInsets.only(
                          bottom: 10, top: 0, left: 20, right: 20),
                      borderRadius: 50,
                      linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.8),
                            Colors.white.withOpacity(0.6),
                            Colors.white.withOpacity(0.2),
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
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 6,
                            margin: const EdgeInsets.only(left: 20),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<PhoneNumber>(
                                menuMaxHeight:
                                    MediaQuery.of(context).size.height / 2,
                                isExpanded: true,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                dropdownColor: const Color(0xfff2f9fe),
                                value: currentPhoneNumber,
                                items: listPhoneNumber.map((e) {
                                  return DropdownMenuItem<PhoneNumber>(
                                    value: e,
                                    child: Text(
                                      e.value,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Color(0xff410000),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    currentPhoneNumber = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (text) {
                                if ((text.isEmpty || digitExp.hasMatch(text)) &&
                                    text.length == currentPhoneNumber.digit) {
                                  setState(() {
                                    validatePhone = true;
                                  });
                                } else {
                                  setState(() {
                                    validatePhone = false;
                                  });
                                }
                              },
                              cursorColor: const Color(0xff410000),
                              style: const TextStyle(
                                letterSpacing: 1,
                                fontSize: 20,
                                color: Color(0xff410000),
                              ),
                              controller: phoneNumber,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: currentPhoneNumber.format,
                                prefixIcon: const Icon(
                                  Icons.phone_android,
                                  color: Color(0xff7c0019),
                                  size: 30,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !validatePhone,
                      child: Column(
                        children: [
                          Text(
                            errorMessage[1],
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.redAccent,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !checkPhoneUnique,
                      child: Column(
                        children: [
                          Text(
                            errorMessage[4],
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.redAccent,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),

                    // Password
                    GlassmorphicContainer(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      height: 60,
                      margin: const EdgeInsets.only(
                          bottom: 10, top: 0, left: 20, right: 20),
                      borderRadius: 50,
                      linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.8),
                            Colors.white.withOpacity(0.6),
                            Colors.white.withOpacity(0.2),
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
                      child: TextField(
                        onChanged: (text) {
                          if (text.isEmpty || text.length >= 8) {
                            setState(() {
                              validatePassword = true;
                            });
                          } else {
                            setState(() {
                              validatePassword = false;
                            });
                          }
                        },
                        cursorColor: const Color(0xff410000),
                        style: const TextStyle(
                          letterSpacing: 1,
                          fontSize: 20,
                          color: Color(0xff410000),
                        ),
                        controller: password,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: "Password",
                          prefixIcon: Icon(
                            Icons.key_rounded,
                            color: Color(0xff7c0019),
                            size: 30,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !validatePassword,
                      child: Column(
                        children: [
                          Text(
                            errorMessage[2],
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.redAccent,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),

                    // Comfirm Password
                    GlassmorphicContainer(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      height: 60,
                      margin: const EdgeInsets.only(
                          bottom: 10, top: 0, left: 20, right: 20),
                      borderRadius: 50,
                      linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.8),
                            Colors.white.withOpacity(0.6),
                            Colors.white.withOpacity(0.2),
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
                      child: TextField(
                        onChanged: (text) {
                          if (text.isEmpty || text == password.text) {
                            setState(() {
                              validateConfirmPass = true;
                            });
                          } else {
                            setState(() {
                              validateConfirmPass = false;
                            });
                          }
                        },
                        cursorColor: const Color(0xff410000),
                        style: const TextStyle(
                          letterSpacing: 1,
                          fontSize: 20,
                          color: Color(0xff410000),
                        ),
                        controller: confirmPassword,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: "Confirm Password",
                          prefixIcon: Icon(
                            Icons.key_rounded,
                            color: Color(0xff7c0019),
                            size: 30,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !validateConfirmPass,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              errorMessage[3],
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),

                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "By creating, you are agreeing to our Terms of use and Privacy Policy.",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 16),
                            textAlign: TextAlign.center,
                          )),
                    ),
                    GlassmorphicContainer(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      height: 60,
                      margin: const EdgeInsets.only(
                          bottom: 0, top: 10, left: 20, right: 20),
                      borderRadius: 50,
                      linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xff410000).withOpacity(0.8),
                            const Color(0xff410000).withOpacity(0.6),
                            const Color(0xff410000).withOpacity(0.3),
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
                            'Create',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          onPressed: () {
                            validation(context);
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account ? ",
                          style: TextStyle(
                              color: Color(0xff410000),
                              fontSize: 17,
                              fontWeight: FontWeight.w700),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Login()));
                            });
                          },
                          child: const Text(
                            "Sign in",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                decoration: TextDecoration.underline,
                                decorationThickness: 2,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WaveShape extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var p = Path();
    p.lineTo(0, 50);
    p.cubicTo(width * 2 / 3, 0, width * 2 / 4, height, width, height - 50);
    p.lineTo(width, 0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
