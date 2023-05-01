import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatapp_app/model/massage_model.dart';
import 'package:whatapp_app/model/user_model.dart';

import 'main.dart';
import 'model/chatroom_model.dart';

class ChatRoomView extends StatefulWidget {
  final UserModel userModel;
  final UserModel receiverUser;
  final User user;
  final ChatRoomModel chatRoomModel;

  const ChatRoomView({Key? key,
    required this.userModel,
    required this.receiverUser,
    required this.user,
    required this.chatRoomModel})
      : super(key: key);

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  TextEditingController messageController = TextEditingController();

  void sendMessage() {
    String msg = messageController.text.trim();
    messageController.clear();
    if (msg != '') {
      MessageModel newMessage = MessageModel(
          messageId: uuid.v1(),
          sender: widget.userModel.uid,
          createdOn: DateTime.now(),
          text: msg,
          seen: false);

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoomModel.chatroomId)
          .collection("message")
          .doc(newMessage.messageId)
          .set(newMessage.toMap());
widget.chatRoomModel.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoomModel.chatroomId).set(widget.chatRoomModel.toMap());

      log("Message send");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            widget.receiverUser.profilePic == null? Text(""): CircleAvatar(
              backgroundImage: NetworkImage(widget.receiverUser.profilePic!),
              backgroundColor: Colors.orange[200],
            ),
            SizedBox(
              width: 10,
            ),
            Text("${widget.userModel.fullName}"),
          ],
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                      .doc(widget.chatRoomModel.chatroomId)
                      .collection("message").orderBy("createdOn",descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnapshot = snapshot
                            .data as QuerySnapshot;

                        return ListView.builder(itemCount: dataSnapshot.docs
                            .length,
                          reverse: true,
                          itemBuilder: ( context, int index) {
                          MessageModel currentMessage = MessageModel.fromMap(dataSnapshot.docs[index].data() as Map<String, dynamic>);
                          return Row(
                            mainAxisAlignment: (currentMessage.sender == widget.userModel.uid)?MainAxisAlignment.end:MainAxisAlignment.start,
                            children: [
                              Container(
                              //  width: MediaQuery.of(context).size.width/2,
                                padding:const EdgeInsets.only(left: 10,top: 5,bottom: 5,right: 10),
                                  decoration: BoxDecoration(
                                      color: (currentMessage.sender == widget.userModel.uid)?Colors.orange[100]:Colors.green[100],
                                    borderRadius: BorderRadius.circular(25.0)
                                  ),
                                  margin: const EdgeInsets.only(top:5),
                                  child: Text(currentMessage.text.toString())),
                            ],
                          );
                          },);
                      } else if (snapshot.hasError) {
                        return const Center(child: Text(
                            "Error is occurred!"
                        ),);
                      } else {
                        return const Center(child: Text(
                            "Say hi to your friends"
                        ),);
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
            Container(
              color: Colors.orange[200],
              child: Row(
                children: [
                  Flexible(
                      child: TextField(
                        maxLines: null,
                        controller: messageController,
                        decoration: const InputDecoration(
                            hintText: "Enter Message",
                            border: InputBorder.none),
                      )),
                  IconButton(
                    onPressed: () {
                      sendMessage();
                    },
                    icon: Icon(Icons.send),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
