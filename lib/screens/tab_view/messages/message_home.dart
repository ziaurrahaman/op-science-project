import 'package:flutter/material.dart';
import 'package:opScienceProject/res/images.dart';
import 'package:opScienceProject/res/screen_size_utils.dart';
import 'package:opScienceProject/screens/tab_view/messages/chat_screen.dart';

class MessageHome extends StatefulWidget {
  const MessageHome({Key key}) : super(key: key);

  @override
  _MessageHomeState createState() => _MessageHomeState();
}

class _MessageHomeState extends State<MessageHome> {
  TextEditingController _searchController;
  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: DS.setHeightRatio(0.17),
              width: DS.getWidth,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Center(
                child: Text(
                  'My Message Box',
                  style: TextStyle(
                    fontSize: DS.setSP(18),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0XFFA7A7A7).withOpacity(.18),
                    borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  controller: _searchController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: DS.setSP(20),
                  ),
                  decoration: InputDecoration(
                    fillColor: Color.fromRGBO(54, 31, 169, 0.05),
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      fontSize: DS.setSP(17),
                      color: Color(0XFFA7A7A7),
                    ),
                    prefixIcon: SizedBox(
                      width: 48,
                      height: 48,
                      child: Center(
                        child: Icon(
                          Icons.search,
                          color: Color(0XFFA7A7A7),
                          size: 22,
                        ),
                      ),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return _buildChats('Teacher Flo', context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChats(String name, BuildContext context) {
    return Container(
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.only(left: 0, right: 0),
                title: Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: DS.setSP(17)),
                      ),
                      Text(
                        '5 min',
                        style: TextStyle(
                          fontSize: DS.setSP(14),
                          color: Color(0XFFA7A7A7),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        appBarTitle: name,
                      ),
                    ),
                  );
                },
                subtitle: Text(
                  'Here is a demo of the displaying message',
                  style: TextStyle(
                    fontSize: DS.setSP(14),
                    color: Color(0XFFA7A7A7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                leading: Container(
                  width: DS.setWidth(80),
                  height: DS.setHeight(80),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage(Images.boyDoc),
                    ),
                  ),
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
