import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:opScienceProject/models/user.dart';
import 'package:opScienceProject/screens/login_signup/login_page.dart';
import 'package:opScienceProject/screens/tab_view/Profile_page/edit_profile_screen.dart';
import 'package:opScienceProject/screens/tab_view/Profile_page/profile_page.dart';
import 'package:opScienceProject/screens/tab_view/home_page/home_screen.dart';
import 'package:opScienceProject/screens/tab_view/searchPage/search_page.dart';
import 'package:opScienceProject/screens/tab_view/settings_page/settings.dart';
import 'package:opScienceProject/utils/auth_client.dart';

class TabView extends StatefulWidget {
  TabView({Key key}) : super(key: key);

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  int currentIndex = 0;

  String currentUserId;
  User currentUser;
  List<StatefulWidget> tabs;
  List<BottomNavigationBarItem> navBarItems;

  @override
  void initState() {
    getUserID().then((value) {
      getTabs();
      getBottomNavigationbarItem();
    });

    super.initState();
  }

  Future<void> getUserID() async {
    try {
      final _auth = AuthClient.instance;
      currentUserId = await _auth.uid();
      print('userIdInGetUserIdMethod: $currentUserId');
    } catch (e) {}
  }

  getTabs() {
    if (currentUserId != null) {
      print('userIdInGetTabs when userId not equal to null');
      setState(() {
        tabs = [
          HomeScreen(),
          ProfilePage(),
          EditProfileScreen(),
          Settings(),
        ];
      });
    }
    if (currentUserId == null) {
      print('userIdInGetTabs when userId  equal to null');
      setState(() {
        tabs = [
          HomeScreen(),
          SearchPage(),
          LoginPage(),
          Settings(),
        ];
      });
    }
  }

  getBottomNavigationbarItem() {
    if (currentUserId != null) {
      print(
          'currentUserId in tabview when id not equal to null: $currentUserId');
      setState(() {
        navBarItems = [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            title: Text(
              'Home',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            title: Text(
              'Search',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            title: Text(
              'Profile',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            title: Text('Settings'),
          ),
        ];
      });
    }
    if (currentUserId == null) {
      print('currentUserId in tabview: $currentUserId');
      setState(() {
        navBarItems = [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            title: Text(
              'Home',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            title: Text(
              'Search',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            title: Text(
              'Profile',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            title: Text('Settings'),
          ),
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentIndex],
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8,
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          elevation: 10,
          selectedIconTheme: IconThemeData(color: Colors.grey[900], size: 30),
          unselectedIconTheme: IconThemeData(
            size: 30,
          ),
          items: navBarItems,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
