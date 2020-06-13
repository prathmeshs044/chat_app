import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/conversation_screen.dart';
import 'package:chatapp/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethod databaseMethod = new DatabaseMethod();
  TextEditingController searchTextEditingController = new TextEditingController();

  QuerySnapshot searchSnapshot;

  //=============SearchList=====================
  Widget searchList(){
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
          return SearchTile(
            username: searchSnapshot.documents[index].data['name'],
            userEmail: searchSnapshot.documents[index].data['email'],

          );
        }): Container();
  }

  initiateSearch(){
    databaseMethod.getUserByUsername(searchTextEditingController.text).
    then((val){
    setState(() {
      searchSnapshot = val;
    });
    });
  }
//  ===============Create Chat Room=============

  createChatRoomAndStartConvo({String userName}){

    List<String> users = [userName,Constants.myName];

     String chatroomid =  getChatRoomId(userName, Constants.myName);

     Map<String,dynamic> chatRoomMap ={
       'users':users,
       'chatroomid': chatroomid,
     };

     DatabaseMethod().createChatRoom(chatroomid,chatRoomMap);
     Navigator.push(context, MaterialPageRoute(
         builder: (context) => ConversationScreen(
           chatroomid : chatroomid
         )
     ));


  }

  Widget SearchTile({String username,String userEmail}){
    return Container(
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(username,style: simpleTextStyle(),),
              Text(userEmail,style: simpleTextStyle(),),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatRoomAndStartConvo(userName: username);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              child: Text('Message',style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }
  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(12.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,

                      style: TextStyle(
                        color: Colors.white
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search username',
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                const Color(0x36FFFFFF),
                                const Color(0x0FFFFFFF)
                              ]
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.search,size: 25.0,),
                        )),
                  )
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

