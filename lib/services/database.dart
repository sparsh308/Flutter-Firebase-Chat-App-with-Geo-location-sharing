import 'package:chatApp/helper/Constants.dart';
import 'package:chatApp/models/searchmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class Databasemethods {
  String name;
  List<searchmodel> searchlist = new List<searchmodel>();
  getusersByUsername(String username) async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: username)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                searchmodel searchm =
                    new searchmodel(username: doc['name'], email: doc['email']);
                searchlist.add(searchm);
              })
            });
  }

  getusersByUsernameglobal() async {
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                searchmodel searchm =
                    new searchmodel(username: doc['name'], email: doc['email']);
                searchlist.add(searchm);
              })
            });
  }

  double lat;
  double longi;
  List<String> mylocation;
  savelocation() async {
    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    lat = position.latitude;
    longi = position.longitude;
    print(position.latitude);
    mylocation = [lat.toString(), longi.toString()];
    setlocation(mylocation);
  }

  setlocation(List m) {
    Map<String, dynamic> locationmap = {
      "Location": m,
    };
    FirebaseFirestore.instance
        .collection('location')
        .doc(Constants.MyName)
        .set(locationmap);
  }

  Future getusersByEmail(String email) async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                name = doc['name'];
              })
            });
    return name;
  }

  uploaduserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  CreateChatRoom(String ChatRoomId, ChatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRomm")
        .doc(ChatRoomId)
        .set(ChatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  setconversationmessages(String chatroomid, messageMap) {
    FirebaseFirestore.instance
        .collection('ChatRomm')
        .doc(chatroomid)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }
}
