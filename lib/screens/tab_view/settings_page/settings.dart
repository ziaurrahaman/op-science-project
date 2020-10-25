import 'package:flutter/material.dart';
import 'package:opScienceProject/res/screen_size_utils.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildtile(
            'Update personel info',
            Icons.supervised_user_circle,
          ),
          _buildtile(
            'Contact us',
            Icons.contact_mail,
          ),
          _buildtile(
            'Rules & Comunity',
            Icons.people_outline,
          ),
          _buildtile(
            'Legal mentions',
            Icons.featured_play_list,
          ),
          _buildtile(
            'Language',
            Icons.language,
          ),
        ],
      ),
    );
  }

  Container _buildtile(String title, IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.grey[800],
          size: 40,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: DS.setSP(17),
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }
}
