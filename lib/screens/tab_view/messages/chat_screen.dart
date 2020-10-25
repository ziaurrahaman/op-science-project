import 'package:flutter/material.dart';
import 'package:opScienceProject/res/screen_size_utils.dart';

class ChatScreen extends StatefulWidget {
  final String appBarTitle;
  ChatScreen({
    Key key,
    this.appBarTitle,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController;
  @override
  void initState() {
    _messageController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          widget.appBarTitle,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: DS.getWidth * 0.8,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                            )
                          ],
                        ),
                        child: Text(
                            'This is a message sent by the user it self means it was sent by me.'),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: DS.getWidth * 0.8,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue[400],
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                            )
                          ],
                        ),
                        child: Text(
                          'This is a message sent by the Sender it means it was sent by the other person.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          _buildSendingRow()
        ],
      ),
    );
  }

  Widget _buildSendingRow() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400]),
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.photo,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
            Expanded(
              child: TextFormField(
                controller: _messageController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Send a message...',
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.send,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
