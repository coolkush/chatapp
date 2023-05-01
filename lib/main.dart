
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:whatapp_app/home_View.dart';
import 'package:whatapp_app/model/firebasehelper.dart';
import 'package:whatapp_app/model/user_model.dart';
import 'login_view.dart';

var uuid = Uuid();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? currentUser = FirebaseAuth.instance.currentUser;
  //runApp(const MyApp());
  if(currentUser != null){
    UserModel? userModel = await FirebaseHelper().getUserModelById(currentUser.uid);
    if(userModel != null){
      runApp( AlreadyLogin(userModel: userModel, user: currentUser,));
    }else{
      runApp(const MyApp());
    }

  }else{
    runApp(const MyApp());
  }
 
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      //home: GoogleSignInBtn(),
      home: const MyChat(),
    );
  }
}

class AlreadyLogin extends StatelessWidget {
  final UserModel userModel;
  final User user;
  const AlreadyLogin({Key? key, required this.userModel, required this.user}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home:  HomePageView(userModel: userModel , user:  user),
    );
  }
}