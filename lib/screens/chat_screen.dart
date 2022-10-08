import 'package:flutter/material.dart';
import 'package:amaterasu/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';//for authentication
import 'package:cloud_firestore/cloud_firestore.dart';//to store messages in cloud firestore

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class ChatScreen extends StatefulWidget {

  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final messageTextController = TextEditingController();//for erasing text after sending it
  final _auth = FirebaseAuth.instance;

  String messageText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try{
      final user = await _auth.currentUser();
      if(user!=null){
        loggedInUser = user;
        //print(loggedInUser.email);
      }
    }catch(e){
      print(e);
    }
  }

  //getting data from firebase but here we are not lisening for new data
  /*void getMessages() async {//if we use this method instead of streams then if any new message comes then we have to call this method again and again to get new messages
    final messages = await _firestore.collection('messages').getDocuments();//get all documents inside messages collection
    for(var message in messages.documents){
      print(message.data);
    }
  }*/

  //listening for data from firebase using streams.for single item we used Future<String> and for plural item we use Stream<String>.with stream we will be notified as soon as we have new data
  void messagesStream() async{//now by using streams we are subscribing to stream service by which if any new message arrives then the function will be notified and inner code will be reruned automatically and a new stream will be returned i.e the stream will listen for new messeages forever
    await for(var snapshot in _firestore.collection('messages').snapshots()){
      for(var message in snapshot.documents){
        print(message.data);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,//will control this textfield
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //Implement send functionality.
                      messageTextController.clear();//will clead the textfield
                      _firestore.collection('messages').add({
                        'text':messageText,
                        'sender':loggedInUser.email,
                      });//to transfer data to firestore
                    },
                    child: Text(
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

class MessagesStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(//StreamBuilder<T> class will turn our snapshots of data into actual widgets everytime new data comes through so its able to rebuild everytime new data comes through
      //StreamBuilder returns widgets
      stream: _firestore.collection('messages').snapshots(),

      builder: (context, snapshot){//AsyncSnapshot<T> class Immutable representation of the most recent interaction with an asynchronous computation.
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents.reversed;//snapshot is tha async snapshot .data is the querysnapshot .documents is the list of messages inside the querysnapshot//reverse() will reverse the list bcz we have made listview{ reverse:true} due to which messages will go to top now if we reverse top message will go to bottom i.e order is right
        List<MessageBubble> messageBubbles = [];
        for(var message in messages){
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];


          final currentUser = loggedInUser.email;



          final messageBubble = MessageBubble(sender: messageSender,text: messageText,isMe: currentUser == messageSender);
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(//for infinite scrolling
            reverse: true,//ListView will be sticky towards bottom of the view all messages will go to top.Due to this we will not have to scroll for new messages
            padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20),

            children: messageBubbles,
          ),
        );
      },
    );
  }
}


class MessageBubble extends StatelessWidget {

  MessageBubble({this.sender,this.text,this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),//in all directions
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(//wrapping with material widget to apply more styling properties
            //borderRadius: BorderRadius.circular(30.0),//to make circular box
            borderRadius: isMe ? BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ) : BorderRadius.only(
              topRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            //will allow us to setup different border radius for each corners
            elevation: 5.0,//drop shadow
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white: Colors.black54,
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
//const initilizes an object

