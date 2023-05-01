import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatapp_app/chatroom_view.dart';
import 'package:whatapp_app/login_view.dart';
import 'package:whatapp_app/main.dart';
import 'package:whatapp_app/model/chatroom_model.dart';

import 'model/user_model.dart';

class SearchPageView extends StatefulWidget {
  final UserModel userModel;
  final User user;

  const SearchPageView({Key? key, required this.userModel, required this.user})
      : super(key: key);

  @override
  State<SearchPageView> createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<SearchPageView> {
  TextEditingController searchController = TextEditingController();

  Future<ChatRoomModel?> getChatroomModel(UserModel receiverUser) async {
   ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${receiverUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.length > 0) {
      //fetch chatroom
      log("already exit");
      var docData =snapshot.docs[0].data();
      ChatRoomModel exitingChatroom = ChatRoomModel.fromMap(docData as Map<String , dynamic>);
      chatRoom = exitingChatroom;
    } else {
      //create New chat room
      log("Not exit ");
      ChatRoomModel newChatRoom =
          ChatRoomModel(chatroomId: uuid.v1(), lastMessage: "", participants: {
        widget.userModel.uid.toString(): true,
        receiverUser.uid.toString(): true,
      });
      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatRoom.chatroomId)
          .set(newChatRoom.toMap());
    }
    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Page"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonTextField(
                  textInputType: TextInputType.text,
                  text: "",
                  controller: searchController,
                  icon: const Icon(Icons.search)),
              const SizedBox(
                height: 20,
              ),
              CupertinoButton(
                  child: const Text('Search'),
                  onPressed: () {
                    setState(() {});
                  }),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where("email", isEqualTo: searchController.text)
                      .where("email", isNotEqualTo: widget.userModel.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnapshot =
                            snapshot.data as QuerySnapshot;

                        if (dataSnapshot.docs.length > 0) {
                          Map<String, dynamic> userMap =
                              dataSnapshot.docs[0].data() as Map<String, dynamic>;

                          UserModel searchedUser = UserModel.fromMap(userMap);
                          return ListTile(
                            onTap: () async {
                              ChatRoomModel? chatRoomModel =
                                  await getChatroomModel(searchedUser);
                              if(chatRoomModel != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChatRoomView(
                                            user: widget.user,
                                            userModel: widget.userModel,
                                            chatRoomModel: chatRoomModel,
                                            receiverUser: searchedUser,
                                          )));
                              }
                            },
                            leading: searchedUser.profilePic == null ? const Text(""):CircleAvatar(
                              backgroundImage:
                                  NetworkImage(searchedUser.profilePic!),
                            ),
                            title: searchedUser.fullName == null ? const Text(""):Text(searchedUser.fullName!),
                            subtitle:searchedUser.email == null ? const Text(""): Text(searchedUser.email!),
                            trailing: const Icon(
                              Icons.keyboard_arrow_right,
                              size: 30,
                              color: Colors.orange,
                            ),
                          );
                        } else {
                          return const Text('Not Result found!');
                        }
                      } else if (snapshot.hasError) {
                        return const Text('An Error Occurred!');
                      } else {
                        return const Text('Not Data found!');
                      }
                    } else {
                      return const CircularProgressIndicator();
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
