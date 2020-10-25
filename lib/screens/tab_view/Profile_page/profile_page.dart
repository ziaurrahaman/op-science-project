import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:opScienceProject/models/user.dart';
import 'package:opScienceProject/providers/auht_provider.dart';
import 'package:opScienceProject/res/images.dart';
import 'package:opScienceProject/res/screen_size_utils.dart';
import 'package:opScienceProject/screens/tab_view/Profile_page/Modify_information.dart';

import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User _user = User();
  @override
  void initState() {
    getCurrentUserData();
    super.initState();
  }

  bool loading = true;
  void getCurrentUserData() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseUser user = await auth.currentUser();

      final uid = user.uid;

      final document =
          await Firestore.instance.collection("users").document(uid).get();
      _user = User.fromMap(document.data);
      print(_user.email);
      Future.delayed(Duration(seconds: 1));
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
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
                  'Profile',
                  style: TextStyle(
                    fontSize: DS.setSP(18),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            loading
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Selector<AuthProvider, FirebaseUser>(
                    selector: (context, AuthProvider value) =>
                        value.firebaseUser,
                    builder: (context, value, child) {
                      if (value == null) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'Login or SignUp',
                              style: TextStyle(
                                fontSize: DS.setSP(25),
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  buildTopContainer(),
                                  SizedBox(
                                    height: DS.setHeight(10),
                                  ),
                                  _buildModify('Modify Profile', context),
                                  SizedBox(
                                    height: DS.setHeight(10),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color:
                                          Color(0xffA3A3A3).withOpacity(0.28),
                                      border: Border.all(
                                          color: Colors.grey, width: 0.3),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: ExpansionTile(
                                      title: Text(
                                        'About',
                                        style: TextStyle(
                                          fontSize: DS.setSP(15),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      childrenPadding: EdgeInsets.only(
                                          left: 10, bottom: 10, right: 10),
                                      tilePadding: EdgeInsets.only(left: 10),
                                      children: [
                                        _buildName('Name:', _user.name),
                                        _buildName('DOB:', _user.dob ?? '--'),
                                        _buildName('Email:', _user.email),
                                        _buildName(
                                            'Gender:', _user.gender ?? '--'),
                                      ],
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        height: DS.getHeight * 0.40,
                                        width: DS.getWidth,
                                        child: Center(
                                          child: Image.asset(
                                            Images.boyDoc,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        height: DS.getHeight * 0.40,
                                        width: DS.getWidth,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.white.withOpacity(0),
                                              Colors.black.withOpacity(0.7),
                                            ],
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                height: DS.setHeightRatio(0.15),
                                                width: DS.getWidth,
                                                child: ListView.builder(
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'johnsmith11: ',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  DS.setSP(15),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Text(
                                                            'you are looking good',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  DS.setSP(15),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  itemCount: 5,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width: DS.getWidth * 0.8,
                                                    child: TextFormField(
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'Add comment',
                                                        hintStyle: TextStyle(
                                                          color:
                                                              Color(0xffFFFFFF)
                                                                  .withOpacity(
                                                                      0.51),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.send,
                                                    color: Color(0xffFFFFFF)
                                                        .withOpacity(0.51),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildName(String first, String second) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            first,
            style: TextStyle(
              fontSize: DS.setSP(13),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            second,
            style: TextStyle(
              fontSize: DS.setSP(13),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  InkWell _buildModify(String title, BuildContext context) {
    return InkWell(
      child: Container(
        height: DS.setHeight(50),
        width: DS.getWidth,
        decoration: BoxDecoration(
          color: Color(0xffA3A3A3).withOpacity(0.28),
          border: Border.all(color: Colors.grey, width: 0.3),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: DS.setSP(15),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: DS.setWidth(15),
            ),
            Image(image: AssetImage(Images.edit))
          ],
        ),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ModifyInfoPage(),
        ),
      ),
    );
  }

  Widget buildTopContainer() {
    return Card(
      elevation: 0,
      child: Row(
        children: [
          Container(
            width: DS.setWidth(100),
            height: DS.setHeight(120),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: _user.imageUrl == null
                    ? AssetImage(Images.boyDoc)
                    : NetworkImage(_user.imageUrl),
              ),
            ),
          ),
          Container(
            width: DS.getWidth * 0.5,
            height: DS.setHeightRatio(0.18),
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _user.name,
                  style: TextStyle(
                    fontSize: DS.setSP(15),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_user.likes.length} Likes',
                      style: TextStyle(
                        color: Color(0xffA3A3A3),
                        fontSize: DS.setSP(15),
                      ),
                    ),
                    Text(
                      '${_user.subscribers.length} Subscribers',
                      style: TextStyle(
                        color: Color(0xffA3A3A3),
                        fontSize: DS.setSP(15),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.email,
                      color: Color(0xffA3A3A3),
                    ),
                    SizedBox(
                      width: DS.setWidth(10),
                    ),
                    Icon(
                      Icons.flag,
                      color: Color(0xffA3A3A3),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
