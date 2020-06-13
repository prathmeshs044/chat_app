import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethod {
  getUserByUsername(String username) async {
    return await Firestore.instance
        .collection('users')
        .where('name', isEqualTo: username)
        .getDocuments();
  }

  getUserByUserEmail(String userEmail) async {
    return await Firestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .getDocuments();
  }

  uploadUserInfo(userMap) {
    Firestore.instance.collection('users').add(userMap);
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    Firestore.instance
        .collection('ChatRoom')
        .document(chatRoomId)
        .setData(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConvoMessages(String chatroomid, messageMap) {
    Firestore.instance
        .collection('ChatRoom')
        .document(chatroomid)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConvoMessages(String chatroomid) async {
    return await Firestore.instance
        .collection('ChatRoom')
        .document(chatroomid)
        .collection('chats')
        .orderBy('time',descending: false)
        .snapshots();
  }
  
  getChatRooms(String username)async{
    return await Firestore.instance.collection('ChatRoom')
        .where('users',arrayContains: username)
        .snapshots();
  }
  
  
}
