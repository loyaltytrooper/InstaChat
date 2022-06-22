import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instachat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instachat/screens/loading_screen.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String routeID = '/chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override

  final messageFieldController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String message = '';

  void getCurrentUser() async {
    final user = await _auth.currentUser;
    if(user != null) {
      loggedInUser = user;
    }
  }

  // void getMessages() async {
  //   final messages = await _firestore.collection("chats").get();
  //   final allData = messages.docs.map((doc) => doc.data()).toList();
  //   print(allData);
  // }

  void messageStream() async {
    await for (var snap in _firestore.collection("chats").snapshots()) {
      for (var message in snap.docChanges) {
        print(message.doc.data());
      }
    }
  }

  void initState(){
    super.initState();
    getCurrentUser();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                 messageStream();
                 _auth.signOut();
                 Navigator.pop(context);
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageFieldController,
                      onChanged: (value) {
                        message = value;
                      },
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageFieldController.clear();
                      final data = {
                        "sender" : loggedInUser.email,
                        "message" : message,
                        "createdAt" : FieldValue.serverTimestamp(),
                      };
                      _firestore.collection("chats").add(data).then((documentSnapshot) => print('added data with ID ${documentSnapshot}'));
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection("chats").orderBy('createdAt').snapshots(),
      builder: (context, snapshot) {
        List<Widget> messageWidgets= [];
        if (snapshot.hasData) {
          final messageData = snapshot.data?.docs;

          for(var message in messageData!) {
            final d = message.data();
            final messageText = d['message'];
            final messageSender = d['sender'];
            final currentUser = loggedInUser.email;

            final messageBubbleWidget = MessageBubble(
                text: messageText,
                sender: messageSender,
                isMe: currentUser == messageSender
            );
            messageWidgets.add(messageBubbleWidget);
          }
        }
        return Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messageWidgets,
          )
        );
      }
    );
  }
}

class MessageBubble extends StatelessWidget {

  late String text;
  late String sender;
  late bool isMe;

  MessageBubble({required this.text, required this.sender, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(sender,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black38,
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(isMe ? 30 : 0), topRight: Radius.circular(isMe? 0 : 30), bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            elevation: 5,
            color: isMe? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe? Colors.white : Colors.indigoAccent,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
