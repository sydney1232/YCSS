import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ycss/constants/color_palette.dart';
import 'package:ycss/firebase_services/firebase_crud.dart';
import 'package:ycss/firebase_services/firebase_utils.dart';

class MessagingPage extends StatefulWidget {
  const MessagingPage({Key? key}) : super(key: key);

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

FirestoreService firestoreService = FirestoreService();

final messageBoxTextEditingController = TextEditingController();
final ScrollController _sc = ScrollController();

class _MessagingPageState extends State<MessagingPage> {
  bool _userScrolling = false;

  @override
  void initState() {
    super.initState();
    _sc.addListener(_scrollListener);

    // Delay the scroll to the bottom to ensure the frame is built
    Future.delayed(Duration(milliseconds: 500), () {
      if (_sc.hasClients) {
        _sc.jumpTo(_sc.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _sc.removeListener(_scrollListener);
  }

  void sendMessage(String username, String body) {
    firestoreService
        .addMessaging(
      username,
      body,
    )
        .then((_) {
      // Scroll to the bottom after message has been sent and added
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _sc.animateTo(
          _sc.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    });
    messageBoxTextEditingController.clear();
  }

  void _scrollListener() {
    if (_sc.offset >= _sc.position.maxScrollExtent &&
        !_sc.position.outOfRange) {
      // User is at the bottom of the list
      setState(() {
        _userScrolling = false;
      });
    } else {
      // User has manually scrolled up
      setState(() {
        _userScrolling = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final String userName = currentUser.displayName ?? 'User';
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: lightPink),
        centerTitle: true,
        backgroundColor: blue,
        title: Text(
          "Logged in as $userName",
          style: TextStyle(color: lightPink, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            child: StreamBuilder<QuerySnapshot>(
                stream: firestoreService.getMessagesByTimestamp(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List messageList = snapshot.data!.docs;

                    return ListView.builder(
                        controller: _sc,
                        itemCount: messageList.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = messageList[index];

                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;

                          //When new message comes in, automaticaly scrolls down to bottom
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            if (!_userScrolling) {
                              _sc.animateTo(
                                _sc.position.maxScrollExtent,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          });

                          String message = data['body'];
                          String sender = data['sender'];
                          Timestamp timestamp = data['timestamp'];

                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: sender == userName
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: sender == userName
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      convertToLocalDateAndTime(timestamp),
                                    ),
                                    Container(
                                      constraints:
                                          BoxConstraints(maxWidth: 200),
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: sender == userName
                                            ? lightPink
                                            : blue,
                                        borderRadius: sender == userName
                                            ? const BorderRadius.only(
                                                bottomLeft: Radius.circular(8),
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8))
                                            : const BorderRadius.only(
                                                bottomRight: Radius.circular(8),
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8)),
                                      ),
                                      child: Text(
                                        message,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Text(
                                      sender == userName ? "" : sender,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        });
                  } else {
                    return Center(child: const Text("No messages"));
                  }
                }),
          )),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8, bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Set the background color
                      borderRadius:
                          BorderRadius.circular(20.0), // Add rounded corners
                    ),
                    child: TextFormField(
                      controller: messageBoxTextEditingController,
                      maxLines: null,
                      cursorColor: lightPink,
                      decoration: InputDecoration(
                        hintText: "Enter your message here...",
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: blue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      sendMessage(
                          userName, messageBoxTextEditingController.text);

                      //Scroll to the latest message before message is sent
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        _sc.animateTo(
                          _sc.position.maxScrollExtent,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      });
                    },
                    icon: Icon(
                      Icons.send,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
