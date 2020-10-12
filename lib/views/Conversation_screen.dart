import 'dart:async';

import 'package:chatApp/helper/Constants.dart';
import 'package:chatApp/services/database.dart';
import 'package:chatApp/views/map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Conversation extends StatefulWidget {
  String chateeeroomid;
  String recipent;
  Conversation({this.chateeeroomid, this.recipent});
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  TextEditingController messageeditingcontroller = new TextEditingController();
  Databasemethods databasemethods = new Databasemethods();
  final _controller = ScrollController();

  Widget ChatMessageList() {
    Query collectionReference = FirebaseFirestore.instance
        .collection('ChatRomm')
        .doc(widget.chateeeroomid)
        .collection('chats')
        .orderBy('time', descending: false);

    return StreamBuilder<QuerySnapshot>(
        stream: collectionReference.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          ob() {
            Timer(
                Duration(),
                () => _controller.animateTo(
                      _controller.position.maxScrollExtent,
                      duration: Duration(microseconds: 1),
                      curve: Curves.fastOutSlowIn,
                    ));
          }

          collectionReference.snapshots().listen((querySnapshot) {
            querySnapshot.docs.forEach((change) {
              ob();
            });
          });

          return ListView.builder(
              controller: _controller,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return MessageTile(
                  message: snapshot.data.docs[index].data()['message'],
                  isSendbyMe: snapshot.data.docs[index].data()['sendby'] ==
                      Constants.MyName,
                );
              });
        });
  }

  sendmessage() {
    if (messageeditingcontroller.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageeditingcontroller.text,
        "sendby": Constants.MyName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      databasemethods.setconversationmessages(widget.chateeeroomid, messageMap);
      messageeditingcontroller.text = "";
    }
  }

  @override
  void setState(fn) {
    // TODO: implement setState

    super.setState(fn);
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  showmap() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => myMap(
                  name: widget.recipent,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.location_on),
              onPressed: () {
                showmap();
              }),
        ],
        title: Text(widget.recipent),
      ),
      backgroundColor: Color(0xfff131313),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.9,
                child: ChatMessageList(),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(23),
                          color: Colors.white70),
                      height: MediaQuery.of(context).size.height * 0.10,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                                child: TextField(
                              style: TextStyle(color: Colors.white),
                              controller: messageeditingcontroller,
                              decoration: InputDecoration(
                                  hintText: "Type a Message",
                                  hintStyle: TextStyle(color: Colors.white70),
                                  border: InputBorder.none),
                            )),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                  borderRadius: BorderRadius.circular(250)),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    sendmessage();
                                  }),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendbyMe;
  MessageTile({this.message, this.isSendbyMe});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        width: MediaQuery.of(context).size.width,
        alignment: isSendbyMe ? Alignment.centerRight : Alignment.centerLeft,
        child: GestureDetector(
          onLongPress: () {},
          child: Container(
            decoration: BoxDecoration(
                borderRadius: isSendbyMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomLeft: Radius.circular(23))
                    : BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomRight: Radius.circular(23)),
                gradient: LinearGradient(
                    colors: isSendbyMe
                        ? [
                            Theme.of(context).accentColor,
                            Theme.of(context).primaryColor
                          ]
                        : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)])),
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Text(
                message,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
