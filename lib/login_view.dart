import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:whatapp_app/signup_view.dart';

import 'home_View.dart';
import 'model/user_model.dart';

class MyChat extends StatefulWidget {
  const MyChat({Key? key}) : super(key: key);

  @override
  State<MyChat> createState() => _MyChatState();
}

class _MyChatState extends State<MyChat> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  validationCheck() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email == '' || password == "") {
      print(" fill all the Fields");
    } else {
      logIn(email, password);
    }
  }

 void logIn(String email, password) async {
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code.toString());
    }
    if (userCredential != null) {
      String uid = userCredential.user!.uid;
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      UserModel userModel= UserModel.fromMap(userData.data() as Map<String, dynamic>);

      print("Log in SuccessFul");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePageView(
                user: userCredential!.user!,
                userModel: userModel,
              )));
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
                    height: 60.0,
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
                    height: 80.0,
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
                          child: const Text("Login",
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
                        text: "Don't have an account? ",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Register',
                              style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 15,
                                  wordSpacing: 8,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  color: Colors.orange),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MySignupView()),
                                  );
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

class CommonTextField extends StatelessWidget {
  TextEditingController controller;
  Icon icon;
  String text;
  TextInputType textInputType;

  CommonTextField({
    Key? key,
    required this.textInputType,
    required this.text,
    required this.controller,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        isDense: true,
        prefixIconColor: Colors.orange,
        prefix: Padding(
          padding: const EdgeInsets.only(
            right: 15.0,
          ),
          child: icon,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
        hoverColor: Colors.orange,
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
        label: SizedBox(
          width: MediaQuery.of(context).size.width / (42.0 / text.length),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(color: Colors.orange),
              )
            ],
          ),
        ),
      ),
      keyboardType: textInputType,
    );
  }
}
