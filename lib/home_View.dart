import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatapp_app/chatroom_view.dart';
import 'package:whatapp_app/model/chatroom_model.dart';
import 'package:whatapp_app/model/firebasehelper.dart';
import 'package:whatapp_app/model/user_model.dart';
import 'package:whatapp_app/searchpage.dart';

import 'login_view.dart';

class HomePageView extends StatefulWidget {
  final UserModel userModel;
  final User user;

  const HomePageView({Key? key, required this.userModel, required this.user})
      : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const MyChat()));
              },
              icon: Icon(Icons.exit_to_app))
        ],
        title: const Text("Home Page"),
        centerTitle: true,
      ),
      body: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chatrooms')
              .where("participants.${widget.userModel.uid}", isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                QuerySnapshot chatRoomSnapshot =
                    snapshot.data as QuerySnapshot;
                return ListView.builder(
                    itemCount: chatRoomSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                          chatRoomSnapshot.docs[index].data()
                              as Map<String, dynamic>);
                      Map<String, dynamic> participants =
                          chatRoomModel.participants!;
                      List<String> participantKeys =
                          participants.keys.toList();
                      participantKeys.remove(widget.userModel.uid);
                      return FutureBuilder(
                          future: FirebaseHelper()
                              .getUserModelById(participantKeys[0]),
                          builder: (context, userData) {
                            if (userData.connectionState ==
                                ConnectionState.done) {
                              if (userData.data != null) {
                                UserModel targetUser =
                                    userData.data as UserModel;
                                return ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChatRoomView(
                                                  user: widget.user,
                                                  userModel: widget.userModel,
                                                  chatRoomModel:
                                                      chatRoomModel,
                                                  receiverUser: targetUser,
                                                )));
                                  },
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        targetUser.profilePic.toString()),
                                  ),
                                  title: Text(targetUser.fullName.toString()),
                                  subtitle:
                                      (chatRoomModel.lastMessage.toString() !=
                                              "")
                                          ? Text(chatRoomModel.lastMessage
                                              .toString())
                                          :  Text(
                                              "Say hi to your new friend",
                                              style: TextStyle(
                                                  color: Colors.green[100]),
                                            ),
                                );
                              } else {
                                return Container();
                              }
                            } else {
                              return Container();
                            }
                          });
                    });
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("Some error is occurred!"),
                );
              } else {
                return const Center(
                  child: Text("No Chats"),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchPageView(
                      userModel: widget.userModel, user: widget.user)));
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
