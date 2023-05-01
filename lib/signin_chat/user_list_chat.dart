import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'authentication_class.dart';
import 'chat_screen.dart';
import 'google_signin.dart';

/*class HomeScreen extends StatefulWidget {
  HomeScreen ({Key? key, required User user}): _user = user,
  super(key: key);

  final User _user;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _user;
  bool _isSigningOut = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
    _user = widget._user;

  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where('email', isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        print("${value.docs.length}       va;lueeeee");
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(_user.displayName ?? ''),
        actions: [
          _isSigningOut
              ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          )
              : ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isSigningOut = true;
                });
                await Authentication.signOut(context: context);
                setState(() {
                  _isSigningOut = false;
                });
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => GoogleSignInBtn(),
                  ),
                );
              },
              child:Icon(Icons.exit_to_app)
          ),
        ],
      ),
      body: isLoading
          ? Center(
        child: Container(
          height: size.height / 20,
          width: size.height / 20,
          child: CircularProgressIndicator(),
        ),
      )
          : Column(
        children: [
          SizedBox(
            height: size.height / 20,
          ),
          Container(
            height: size.height / 14,
            width: size.width,
            alignment: Alignment.center,
            child: Container(
              height: size.height / 14,
              width: size.width / 1.15,
              child: TextField(
                controller: _search,
                decoration: InputDecoration(
                  hintText: "Search",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height / 50,
          ),
          ElevatedButton(
            onPressed: onSearch,
            child: Text("Search"),
          ),
          SizedBox(
            height: size.height / 30,
          ),
          userMap != null
              ? ListTile(
            onTap: () {
              String roomId = chatRoomId(
                  _auth.currentUser!.displayName!,
                  userMap!['name']);

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Chat(
                    chatRoomId: roomId,
                    peerName: userMap?['name'],
                  ),
                ),
              );
            },
            leading: Icon(Icons.account_box, color: Colors.black),
            title: Text(
              userMap!['name'],
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(userMap!['email']),
            trailing: Icon(Icons.chat, color: Colors.black),
          )
              : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.group),
        onPressed: () {
           */ /*Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => GroupChatHomeScreen(),
              ));*/ /*
        },
        )
      );

  }
}*/

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  Map<String, dynamic>? userMap;
  late User _user;
  bool _isSigningOut = false;
  //String? chatroom;

  @override
  void initState() {
    _user = widget._user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("People List"),
        centerTitle: true,
        actions: [
          _user.photoURL != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.grey,
                      child: Image.network(
                        _user.photoURL!,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                )
              : ClipOval(
                  child: Material(
                    color: Colors.grey.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
          SizedBox(
            width: 5,
          ),
          _isSigningOut
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                )
              : ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isSigningOut = true;
                    });
                    await Authentication.signOut(context: context);
                    setState(() {
                      _isSigningOut = false;
                    });
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => GoogleSignInBtn(),
                      ),
                    );
                  },
                  child: Icon(Icons.exit_to_app)),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('id', isNotEqualTo: (_user.uid))
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if ((snapshot.data?.docs.length ?? 0) > 0) {
                  return ListView.builder(
                    // padding: EdgeInsets.all(10),
                    itemBuilder: (context, index)
                    {
                      print("length=======> ${snapshot.data?.docs.length}");
                     return buildItem(context, snapshot.data?.docs[index], _user);},
                    itemCount: snapshot.data?.docs.length,
                    //controller: listScrollController,
                  );
                } else {
                  return Center(
                    child: Text("No users For chat"),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepOrange,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

String chatRoomId(String user1, String user2) {
  print("===========////////////1 ${user1[0].toLowerCase().codeUnits[0]}");
  print("===========|||||||||||||||||2 ${user1[0].toLowerCase().codeUnits[0]}");
  if (user1[0].toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]) {
    return "$user1$user2";
  } else {
    return "$user2$user1";
  }
}

Future<String?> chatRoom(User user, DocumentSnapshot doc) async {
String? chatroom ;
  print("${user.uid}${doc['id']}");
  //var roomIdOne = '${user.uid}${doc['id']}';
  var roomIdOne = '${user.displayName}${doc['name']}';
  var roomIdTwo = '${doc['name']}${user.displayName}';
 // var roomIdTwo = '${doc['id']}${user.uid}';
  print("${doc['name']}${user.displayName} ");
  //print("${FieldPath.documentId.}");
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection("chatroom")
      .where(roomIdOne, isEqualTo: true)
      .where(roomIdTwo, isEqualTo: true)
      .get();

  if (snapshot.docs.length > 0) {
    print("Existsss");
    var docData = snapshot.docs[0].data();
    print("${docData} doccccccccccccccc");

    chatroom = docData as String?;
  } else {
    print("doesnot exist");
    String roomId = chatRoomId("${user.displayName}", "${doc['name']}");

    FirebaseFirestore.instance.collection("chatroom").doc(roomId);

    chatroom = roomId;
  }
  return chatroom;
}

Widget buildItem(BuildContext context, DocumentSnapshot? doc, User user) {
  return Column(
    children: [
  Container(
    color: Colors.orange[100],
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    margin: EdgeInsets.symmetric(vertical: 10),
    child: GestureDetector(
      onTap: () async {
        String? chatRoomId = await chatRoom(user, doc!);

        if (chatRoomId != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Chat(
                        chatRoomId: chatRoomId,
                        peerName: doc['name'],
                      )));
        } else {
          Text("There is smth wrong");
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(child: Text(doc?['name'])),
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(doc?['photoUrl']),
          ),
        ],
      ),
    ),
  ),
  SizedBox(
    height: 20,
  )
    ],
  );
}

//User Infolist
/*Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(),

              SizedBox(height: 16.0),
              Text(
                'Hello',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 26,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                _user.displayName!,
                style: TextStyle(
                  color:Colors.yellow,
                  fontSize: 26,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '( ${_user.email!} )',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 24.0),
              Text(
                'You are now signed in using your Google account. To sign out of your account click the "Sign Out" button below.',
                style: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                    fontSize: 14,
                    letterSpacing: 0.2),
              ),
              SizedBox(height: 16.0),


              ElevatedButton(
                  onPressed: (){
             */
