import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'authentication_class.dart';
import 'user_list_chat.dart';

class GoogleSignInBtn extends StatefulWidget {
  const GoogleSignInBtn({Key? key}) : super(key: key);

  @override
  State<GoogleSignInBtn> createState() => _GoogleSignInBtnState();
}

class _GoogleSignInBtnState extends State<GoogleSignInBtn> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Center(
          child: _isSigningIn
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                )
              : ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isSigningIn = true;
                    });

                    User? user = await Authentication.signInWithGoogle(context: context);
                    print("------------>> $user");

                      // For savinng data in firestore
                    if (user != null) {
                      // Check is already sign up
                      final QuerySnapshot result =await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: user.uid).get();
                      final List < DocumentSnapshot > documents = result.docs;
                      if (documents.isEmpty) {
                        // Update data to server if new user
                        FirebaseFirestore.instance.collection('users').doc(user.uid).set(
                            { 'name': user.displayName,'email':user.email, 'photoUrl': user.photoURL, 'id': user.uid, 'status':"unavailable"});
                      }
                    }

                    setState(() {
                      _isSigningIn = false;
                    });

                    if (user != null) {
                      print("+++++++++++++++>>>>>>>>");
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>UserInfoScreen(user: user)));
                   /*   Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserInfoScreen(
                            user: user,
                          ),
                        ),
                      );*/
                    }
                  },
                  child: Text("Sign in"),
                ),
        ),

    );
  }
}
