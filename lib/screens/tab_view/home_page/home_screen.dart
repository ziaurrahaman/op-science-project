import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:opScienceProject/models/user.dart';
import 'package:opScienceProject/providers/auht_provider.dart';
import 'package:opScienceProject/screens/login_signup/login_page.dart';
import 'package:opScienceProject/screens/login_signup/signUp_page.dart';
import 'package:opScienceProject/screens/tab_view/Profile_page/edit_profile_screen.dart';
import 'package:opScienceProject/utils/auth_client.dart';
import 'package:opScienceProject/utils/database_client.dart';
import 'package:provider/provider.dart';

enum Mode {
  Login,
  Home,
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Mode _mode = Mode.Home;
  bool _isDropdownButtonPressed = false;
  User currentUser;
  String userId;
  bool loading = true;
  List<User> users = List<User>();
  List<User> sortedUser = List<User>();
  bool isFirstTime = false;
  bool isFirstTime2 = false;
  int index1;
  PageController pageController = PageController();
  final DatabaseClient _databaseClient = DatabaseClient.instance;

  void switchMode() {
    if (_mode == Mode.Home) {
      setState(() {
        _mode = Mode.Login;
      });
    } else {
      _mode = Mode.Home;
    }
  }

  @override
  void initState() {
    getUserID();

    super.initState();
  }

  Future<void> getUserID() async {
    try {
      final _auth = AuthClient.instance;
      userId = await _auth.uid();

      currentUser = await _auth.getCurrentUserById();

      print('current User name in init: ${currentUser.name}');
      setState(() {
        loading = false;
      });
    } catch (e) {
      print(userId);
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> createUsersAcordingToFav(
      AsyncSnapshot<dynamic> snapshot, int index) async {
    final DatabaseClient _databaseClient = DatabaseClient.instance;

    var fav = await _databaseClient.getFavouriteUser(userId, currentUser);
    User userFromSnapShot = User(
      bio: snapshot.data.documents[index]['bio'],
      dob: snapshot.data.documents[index]['dob'],
      email: snapshot.data.documents[index]['email'],
      flag: snapshot.data.documents[index]['flag'],
      gender: snapshot.data.documents[index]['gender'],
      imageUrl: snapshot.data.documents[index]['profile_picture'],
      likes: snapshot.data.documents[index]['likes'],
      name: snapshot.data.documents[index]['name'],
      phoneNumber: snapshot.data.documents[index]['phoneNumber'],
      pinned: snapshot.data.documents[index]['pinned'],
      subscribers: snapshot.data.documents[index]['subscribers'],
      favourites: snapshot.data.documents[index]['favourites'],
      userId: snapshot.data.documents[index]['userId'],
      website: snapshot.data.documents[index]['website'],
    );
    print('favNameInHome: $fav');
    if (fav != null && isFirstTime == false) {
      isFirstTime = true;

      users.insert(0, fav);
      users.forEach((element) {
        if (!users.contains(userFromSnapShot)) {
          users.add(userFromSnapShot);
        }
      });
    } else {
      users.add(userFromSnapShot);
    }
  }

  changeProfileByIncreasingTheIndex() {
    pageController.nextPage(
        duration: Duration(seconds: 1), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    users.forEach((element) {
      print(element.toString());
    });

    final deviceSize = MediaQuery.of(context).size;
    print('screenWidth: ${deviceSize.width}');
    final screenSize =
        deviceSize.height - (MediaQuery.of(context).padding.top + 60);
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 0,
        onPressed: changeProfileByIncreasingTheIndex,
        child: Icon(
          MdiIcons.rocketLaunchOutline,
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            HomeScreenTopSection(deviceSize, screenSize),
            loading
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Expanded(
                    child: StreamBuilder(
                      stream:
                          Firestore.instance.collection('users').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            !snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.data.documents.length == 0) {
                          return Center(
                            child: Text("No Users Created."),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        }

                        users = new List<User>();

                        for (int i = 0;
                            i < snapshot.data.documents.length;
                            i++) {
                          var user = User(
                              bio: snapshot.data.documents[i]['bio'],
                              dob: snapshot.data.documents[i]['dob'],
                              email: snapshot.data.documents[i]['email'],
                              flag: snapshot.data.documents[i]['flag'],
                              gender: snapshot.data.documents[i]['gender'],
                              imageUrl: snapshot.data.documents[i]
                                  ['profile_picture'],
                              likes: snapshot.data.documents[i]['likes'],
                              name: snapshot.data.documents[i]['name'],
                              phoneNumber: snapshot.data.documents[i]
                                  ['phoneNumber'],
                              pinned: snapshot.data.documents[i]['pinned'],
                              subscribers: snapshot.data.documents[i]
                                  ['subscribers'],
                              favourites: snapshot.data.documents[i]
                                  ['favourites'],
                              userId: snapshot.data.documents[i]['userId'],
                              website: snapshot.data.documents[i]['website'],
                              isFavourited: false);

                          if (currentUser != null) {
                            user.isFavourited = snapshot
                                .data.documents[i]['favourites']
                                .contains(currentUser.userId);
                          }

                          users.add(user);
                        }

                        users.sort((User a, User b) {
                          if (b.isFavourited) {
                            return 1;
                          }
                          return -1;
                        });

                        return PageView.builder(
                          controller: pageController,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            return users.length <= 0
                                ? Center(
                                    child: Text("No Users Created."),
                                  )
                                : _buildContent(
                                    users[index], deviceSize, screenSize);
                          },
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(User user, Size deviceSize, double screenSize) {
    return Column(
      children: [
        Container(
          height: screenSize * 0.19,
          child: Padding(
            padding: EdgeInsets.only(left: 24, right: 20, top: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Advertisement',
                  style: TextStyle(
                      color: Color(0xff000000), fontFamily: 'Italianate'),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 60,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                ),
                SizedBox(
                  height: 0,
                ),
              ],
            ),
          ),
        ),
        HomeScreenLikeSubscribeEditFavouriteAndImagSection(
            deviceSize, screenSize, user, currentUser, userId),
        AboutMeSection(user, deviceSize, screenSize, _isDropdownButtonPressed)
      ],
    );
  }
}

// ignore: must_be_immutable
class AboutMeSection extends StatefulWidget {
  final User user;
  final Size deviceSize;
  final double screenSize;
  bool _isDropdownButtonPressed;

  AboutMeSection(this.user, this.deviceSize, this.screenSize,
      this._isDropdownButtonPressed);

  @override
  _AboutMeSectionState createState() => _AboutMeSectionState();
}

class _AboutMeSectionState extends State<AboutMeSection> {
  @override
  Widget build(BuildContext context) {
    // bool _isDropdownButtonPressed = false;
    return Column(
      children: [
        Container(
          height: widget.screenSize * 0.10,
          child: Padding(
            padding: EdgeInsets.only(
                left: 8,
                right: 8,
                top: 8,
                bottom: widget._isDropdownButtonPressed ? 0 : 8),
            child: Container(
              height: 40,
              width: widget.deviceSize.width,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset('assets/images/brightness_auto.png'),
                  ),
                  Spacer(),
                  Text(
                    'About Me',
                    style: TextStyle(
                        fontFamily: 'Brussels',
                        color: widget._isDropdownButtonPressed
                            ? Colors.black
                            : Colors.grey,
                        fontSize: 18),
                  ),
                  Spacer(),
                  IconButton(
                    icon: widget._isDropdownButtonPressed == true
                        ? Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.blue,
                          )
                        : Icon(Icons.keyboard_arrow_down),
                    color: Colors.grey,
                    onPressed: () {
                      setState(() {
                        widget._isDropdownButtonPressed =
                            !widget._isDropdownButtonPressed;
                      });
                    },
                  ),
                  SizedBox(
                    width: 8,
                  )
                ],
              ),
            ),
          ),
        ),
        widget._isDropdownButtonPressed
            ? ScreenWhenDropDownIsPressed(
                widget.user, widget.deviceSize, widget.screenSize)
            : ScreenWhenDoropdownIsNotPressed(
                widget.user, widget.deviceSize, widget.screenSize)
      ],
    );
  }
}

class HomeScreenTopSection extends StatelessWidget {
  final Size deviceSize;
  final double screenSize;

  HomeScreenTopSection(this.deviceSize, this.screenSize);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenSize * 0.15,
      width: deviceSize.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
        color: const Color(0xff000000),
        boxShadow: [
          BoxShadow(
            color: const Color(0x29939393),
            offset: Offset(0, 10),
            blurRadius: 30,
          ),
        ],
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20, bottom: 10, right: 16, left: 16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                  color: const Color(0xff707070),
                  borderRadius: BorderRadius.circular(8)),
              child: Image.asset(
                'assets/images/flask.png',
                height: 24,
                width: 24,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 12,
                ),
                Text(
                  'Op sciences',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, fontFamily: 'Emmett'),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'The school of sciences',
                  style: TextStyle(
                      fontFamily: 'Emmett', color: Colors.white, fontSize: 12),
                )
              ],
            ),
            Spacer(),
            Selector<AuthProvider, FirebaseUser>(
              selector: (context, AuthProvider value) => value.firebaseUser,
              builder: (context, value, child) {
                if (value == null) {
                  return Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          // color: Colors.grey,
                        ),
                        height: 48,
                        width: 80,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          color: const Color(0xff707070),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ));
                          },
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              fontFamily: 'Emmett',
                              fontSize: 12,
                              color: const Color(0xffefefef),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          // color: Colors.grey,
                        ),
                        height: 48,
                        width: 80,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          color: const Color(0xff707070),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SignUpPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontFamily: 'Emmett',
                              fontSize: 12,
                              color: const Color(0xffefefef),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container(
                    width: 48,
                    height: 48,
                    child: GestureDetector(
                      child: Image.asset(
                        'assets/images/door_open.png',
                        height: 24,
                        width: 24,
                      ),
                      onTap: () {
                        context.read<AuthProvider>().signOut();
                      },
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
}

class HomeScreenLikeSubscribeEditFavouriteAndImagSection
    extends StatelessWidget {
  final Size deviceSize;
  final double screenSize;
  final User user;
  final User currentUser;
  final String userId;
  final DatabaseClient _databaseClient = DatabaseClient.instance;

  HomeScreenLikeSubscribeEditFavouriteAndImagSection(this.deviceSize,
      this.screenSize, this.user, this.currentUser, this.userId);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenSize * 0.21,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            height: 140,
            width: deviceSize.width,
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            top: 0,
            child: Image.asset(
              'assets/images/default_add_image2.png',
              fit: BoxFit.fitWidth,
              height: 130,
              width: deviceSize.width,
            ),
          ),
          userId == user.userId
              ? SizedBox()
              : Positioned(
                  left: 10,
                  bottom: 0,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        shape: BoxShape.circle,
                        color: Colors.white),
                    child: IconButton(
                      icon: Icon(
                        Icons.star,
                        color: _databaseClient.isFavouritedAlready(
                                user, userId, currentUser)
                            ? Colors.yellow[800]
                            : Colors.grey,
                      ),
                      onPressed: () {
                        _databaseClient.implementFavourite(
                            user, currentUser, userId);
                      },
                    ),
                  )),
          Positioned(
            bottom: 0,
            left: 60,
            child: Container(
              width: deviceSize.width > 400 ? 120 : 100,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Colors.black)),
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 8),
                child: Text(
                  '${user.name}',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Emmett',
                      fontSize: deviceSize.width > 500 ? 16 : 14,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ),
          userId == user.userId
              ? Selector<AuthProvider, FirebaseUser>(
                  selector: (context, AuthProvider value) => value.firebaseUser,
                  builder: (context, value, child) {
                    if (value == null) {
                      return SizedBox();
                    } else {
                      return Positioned(
                          left: deviceSize.width > 400 ? 185 : 120,
                          bottom: 0,
                          child: Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                shape: BoxShape.rectangle,
                                color: Colors.white),
                            child: Padding(
                              padding: EdgeInsets.all(0.0),
                              child: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (ctx) => EditProfileScreen()));
                                },
                              ),
                            ),
                          ));
                    }
                  },
                )
              : SizedBox(),
          userId == user.userId
              ? SizedBox()
              : Positioned(
                  left: deviceSize.width > 400 ? 240 : 180,
                  bottom: 0,
                  child: Selector<AuthProvider, FirebaseUser>(
                    selector: (context, AuthProvider value) =>
                        value.firebaseUser,
                    builder: (context, value, child) {
                      if (value == null) {
                        return Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              shape: BoxShape.circle,
                              color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset('assets/images/thumbs_up.png'),
                          ),
                        );
                      } else {
                        return InkWell(
                          onTap: () async {
                            _databaseClient.implementLikeOrDislike(
                                user, currentUser, userId);
                          },
                          child: Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                shape: BoxShape.circle,
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(MdiIcons.thumbUp,
                                  color: user.likes.contains(userId)
                                      ? Colors.grey
                                      : Colors.blue),
                            ),
                          ),
                        );
                      }
                    },
                  )),
          userId == user.userId
              ? SizedBox()
              : Positioned(
                  bottom: 0,
                  left: deviceSize.width > 400 ? 300 : 240,
                  child: Selector<AuthProvider, FirebaseUser>(
                    selector: (context, AuthProvider value) =>
                        value.firebaseUser,
                    builder: (context, value, child) {
                      return InkWell(
                        child: Container(
                          height: 48,
                          width: 100,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            onPressed: value == null
                                ? () {}
                                : () async {
                                    _databaseClient
                                        .implementSubscribeOrUnsubscribe(
                                            user, currentUser, userId);
                                  },
                            color: user.subscribers.contains(userId)
                                ? Colors.grey
                                : Color(0xffff0000),
                            child: Text(
                              user.subscribers.contains(userId)
                                  ? 'UnSubscribe'
                                  : 'Subscribe',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ))
        ],
      ),
    );
  }
}

class ScreenWhenDropDownIsPressed extends StatelessWidget {
  final User user;
  final Size deviceSize;
  final double screenSize;
  ScreenWhenDropDownIsPressed(this.user, this.deviceSize, this.screenSize);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenSize * 0.35,
      width: deviceSize.width,
      decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 32,
            ),
            Row(
              children: [
                Text(
                  'UserName: ',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Emmett'),
                ),
                Text(
                  '${user.name} ',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Emmett'),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  'Email: ',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Emmett'),
                ),
                Text(
                  '${user.email} ',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Emmett'),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bio:   ',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Emmett'),
                ),
                Container(
                  width: deviceSize.width * 0.80,
                  child: Text(
                    '${user.bio}',
                    maxLines: 4,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ScreenWhenDoropdownIsNotPressed extends StatelessWidget {
  final User user;
  final Size deviceSize;
  final double screenSize;
  ScreenWhenDoropdownIsNotPressed(this.user, this.deviceSize, this.screenSize);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenSize * 0.35,
      child: Row(
        children: [
          Container(
            height: screenSize * 0.35,
            width: deviceSize.width * 0.3,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.black)),
            child: Column(
              children: [
                Spacer(),
                Text(
                  '${user.likes.length}',
                  style: TextStyle(fontSize: 18, fontFamily: 'Emmett'),
                ),
                Text(
                  'Likes',
                  style: TextStyle(fontSize: 18, fontFamily: 'Emmett'),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '${user.subscribers.length}',
                  style: TextStyle(fontSize: 18, fontFamily: 'Emmett'),
                ),
                Text(
                  'Subscriber',
                  style: TextStyle(fontSize: 18, fontFamily: 'Emmett'),
                ),
                Spacer(),
              ],
            ),
          ),
          Container(
            height: screenSize * 0.35,
            width: deviceSize.width * 0.70,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: user.imageUrl == null
                        ? AssetImage(
                            'assets/images/boydoc.png',
                          )
                        : NetworkImage(
                            user.imageUrl,
                          ))),
          )
        ],
      ),
    );
  }
}
