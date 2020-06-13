import 'package:chatapp/helper/authenticate.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/conversation_screen.dart';
import 'package:chatapp/views/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethod authMethod = new AuthMethod();

  DatabaseMethod databaseMethod = new DatabaseMethod();

  Stream chatRoomsStreams;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStreams,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                      username: snapshot
                          .data.documents[index].data['chatroomid']
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(Constants.myName, ""),
                      chatroomid:
                          snapshot.data.documents[index].data['chatroomid']);
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    DatabaseMethod().getChatRooms(Constants.myName).then((snapshots) {
      setState(() {
        chatRoomsStreams = snapshots;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Let\'s Chit Chat ',
          style: TextStyle(fontFamily: 'OpenSans'),
        ),
        backgroundColor: Color(0xff202c3b),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              authMethod.signOut();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Authenticate(),
                  ));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(child: chatRoomList()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchScreen(),
              ));
        },
        child: Icon(Icons.search),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String username;

  final String chatroomid;

  ChatRoomsTile({this.username, @required this.chatroomid});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ConversationScreen(chatroomid: chatroomid)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16.0),
        color: Colors.blueAccent,
        child: Row(
          children: <Widget>[
            Container(
              height: 30,
              width: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(40)),
              child: Text(
                '${username.substring(0, 1).toUpperCase()}',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 12.0,
            ),
            Text(
              username,
              textAlign: TextAlign.start,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}
