import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class Chat extends StatelessWidget {
  final String peerName;
  final String chatRoomId;
   Chat({Key? key, required this.chatRoomId,required this.peerName}) : super(key: key) ;



  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.displayName,
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();
      await _firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .add(messages);
    } else {
      if (kDebugMode) {
        print("Enter Some Text");
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(peerName),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: size.height,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chatroom')
                    .doc(chatRoomId)
                    .collection('chats')
                    .orderBy("time", descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {

                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return messages(size, map, context);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    //onSubmitted: (value) => callback(),
                    decoration: InputDecoration(
                      hintText: "Enter a Message...",
                      border: const OutlineInputBorder(),
                    ),
                    controller: _message,
                  ),
                ),
                SizedBox(width: 10,),
                IconButton(
                    icon: Icon(Icons.send), onPressed: onSendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    return  Container(
      width: size.width,
      alignment: map['sendby'] == _auth.currentUser!.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.blue,
        ),
        child: Text(
          map['message'],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );

  }
}












/*class Chat extends StatefulWidget {
  final String?  peerId;
  final String?  peerName;

  const Chat({Key? key, this.peerId,this.peerName}) : super(key: key);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {


  final CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
   String? peerId;
   String? peerName;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  var chatDocId;

  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() async {
    await chats
        .where('users', isEqualTo: {peerId: null, currentUserId: null})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            chatDocId = querySnapshot.docs.single.id;
          });

          print(chatDocId);
        } else {
          await chats.add({
            'users': {currentUserId: null, peerId: null},
            'names':{currentUserId:FirebaseAuth.instance.currentUser?.displayName,peerId:peerName }
          }).then((value) => {chatDocId = value});
        }
      },
    )
        .catchError((error) {});
  }



  Future<void> callback() async {
    if (messageController.text.length > 0) {
      await FirebaseFirestore.instance..collection('chats').doc(chatDocId).collection('messages').add({
        'text': messageController.text,
        'from': currentUserId,
        'date': DateTime.now().toIso8601String().toString(),
      });
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.peerName.toString()),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: chats
                    .doc('groupChatId')
                   .collection('messages')
                    .orderBy('date',descending: true)
                    .limit(1)
                    .snapshots(),
                   builder: (context, snapshot) {
                     if (snapshot.hasError) {
                       return Center(
                         child: Text("Something went wrong"),
                       );
                     }
                     if (snapshot.connectionState == ConnectionState.waiting) {
                       return Center(
                         child: Text("Loading"),
                       );
                     }
                     if(snapshot.hasData){
                       var data;
                       return ListView(
                         reverse: true,
                         controller: scrollController,
                         children: snapshot.data!.docs.map((DocumentSnapshot document){
                           data=document.data();
                           print(document.toString());
                           print(data['msg']);
                           return Padding(
                             padding: EdgeInsets.symmetric(horizontal: 10),
                             child: Container(
                               color: Colors.orange,
                               child: Text(data['msg']),

                             ),
                           );
                         }).toList(),
                       );
                     }
                     else {
                       return Container();
                     }
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onSubmitted: (value) => callback(),
                      decoration: InputDecoration(
                        hintText: "Enter a Message...",
                        border: const OutlineInputBorder(),
                      ),
                      controller: messageController,
                    ),
                  ),
                  SizedBox(width: 10,),
                  SendButton(
                    text: "Send",
                    callback: callback,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}



class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const SendButton({Key? key, required this.text, required this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.orange,
      onPressed: callback,
      child: Text(text),
    );
  }
}

class Message extends StatelessWidget {
  final String from;
  final String text;
  final bool me;

  const Message({Key? key, required this.from, required this.text, required this.me}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment:
        me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            from,
          ),
          Material(
            color: me ? Colors.teal : Colors.red,
            borderRadius: BorderRadius.circular(10.0),
            elevation: 6.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Text(
                text,
              ),
            ),
          )
        ],
      ),
    );
  }
}*/
