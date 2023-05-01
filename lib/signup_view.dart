import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatapp_app/complete_profile_view.dart';
import 'package:whatapp_app/model/user_model.dart';

import 'login_view.dart';

class MySignupView extends StatefulWidget {
  const MySignupView({Key? key}) : super(key: key);

  @override
  State<MySignupView> createState() => _MySignupViewState();
}

class _MySignupViewState extends State<MySignupView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cnfrmPasswordController = TextEditingController();

  validationCheck() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String conformPassword = cnfrmPasswordController.text.trim();
    if (email == '' || password == "" || conformPassword == "") {
      print(" fill all Fields");
    } else if (password != conformPassword) {
      print("password and conformPassword not match");
    } else {
      signUp(email, password);
    }
  }

  signUp(String email, password) async {
    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code.toString());
    }
    if (userCredential != null) {
      String uid = userCredential.user!.uid;
      UserModel newUser =
          UserModel(uid: uid, email: email, fullName: "", profilePic: "");
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newUser.toMap())
          .then((value) {
        print("New user Created");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>  CompleteProfileView(
                      userModel: newUser,
                      firebaseUser: userCredential.user!,
                    )));
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Chat"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30.0,
                  ),
                  const Text("Login With Firebase",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          wordSpacing: 8,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2)),
                  const SizedBox(
                    height: 120.0,
                  ),
                  CommonTextField(
                    controller: emailController,
                    text: 'Email',
                    textInputType: TextInputType.text,
                    icon: const Icon(
                      Icons.email,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  CommonTextField(
                    controller: passwordController,
                    text: 'Password',
                    textInputType: TextInputType.text,
                    icon: const Icon(
                      Icons.lock,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  CommonTextField(
                    controller: cnfrmPasswordController,
                    text: 'conform password',
                    textInputType: TextInputType.text,
                    icon: const Icon(
                      Icons.email,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(
                    height: 60.0,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          onPressed: () {
                            validationCheck();
                          },
                          style: TextButton.styleFrom(
                            elevation: 6,
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 18),
                            side: const BorderSide(
                                color: Colors.black, width: 2.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22)),
                          ),
                          child: const Text("SingUp",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  wordSpacing: 2,
                                  letterSpacing: 2)))),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RichText(
                      text: TextSpan(
                        text: "Already exit Account?",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Login',
                              style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 15,
                                  wordSpacing: 8,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  color: Colors.orange),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pop();
                                }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
