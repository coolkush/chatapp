import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatapp_app/model/user_model.dart';
import 'home_View.dart';
import 'login_view.dart';

class CompleteProfileView extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const CompleteProfileView(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  TextEditingController fullNameController = TextEditingController();
  File? imageFile;

  void checkValues(String name, File? image) {
    if (name == "" || image == null) {
      print("fill all fields");
    } else {
      uploadFolder();
    }
  }

  void uploadFolder() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilePicture")
        .child(widget.userModel.uid.toString())
        .putFile(imageFile!);

    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();
    String fullName = fullNameController.text.trim();

    widget.userModel.fullName = fullName;
    widget.userModel.profilePic = imageUrl;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      print("data uploaded");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePageView(
                    user: widget.firebaseUser,
                    userModel: widget.userModel,
                  )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // if (imageFile != null)
                GestureDetector(
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            color: Colors.amber,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(context);
                                        return getImage(
                                            source: ImageSource.camera);
                                      },
                                      child: const Text('From camera ',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white))),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        getImage(source: ImageSource.gallery);
                                      },
                                      child: const Text('From gallery ',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white))),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage:
                          (imageFile != null) ? FileImage(imageFile!) : null,
                      child: (imageFile == null)
                          ? const Icon(
                              Icons.person,
                              size: 60,
                            )
                          : null,
                    )),

                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 60.0,
                ),
                CommonTextField(
                  controller: fullNameController,
                  text: 'Full Name',
                  textInputType: TextInputType.text,
                  icon: const Icon(
                    Icons.info,
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
                          checkValues(
                              fullNameController.text.trim(), imageFile);
                        },
                        style: TextButton.styleFrom(
                          elevation: 6,
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 18),
                          side:
                              const BorderSide(color: Colors.black, width: 2.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22)),
                        ),
                        child: const Text("Submit",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                wordSpacing: 2,
                                letterSpacing: 2)))),
                const SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getImage({required ImageSource source}) async {
    final file = await ImagePicker().pickImage(
      source: source,
    );

    if (file?.path != null) {
      setState(() {
        imageFile = File(file!.path);
      });
    }
  }
}

/*
Future<void> CostumBottomSheet(BuildContext context1){
  return showModalBottomSheet<void>(
    context: context1,
    builder: (BuildContext context) {
      return Container(
        height: 200,
        color: Colors.amber,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Modal BottomSheet'),
              ElevatedButton(

                    onPressed: ()=> getImage(source: ImageSource.camera),
                    child: const Text('From Camera ',
                        style: TextStyle(fontSize: 18,color: Colors.white))

              )
            ],
          ),
        ),
      );
    },
  );
}*/
