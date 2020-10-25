import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opScienceProject/models/user.dart';
import 'package:opScienceProject/providers/auht_provider.dart';
import 'package:opScienceProject/res/images.dart';
import 'package:opScienceProject/res/screen_size_utils.dart';
import 'package:opScienceProject/res/validators.dart';
import 'package:opScienceProject/screens/tab_view/Profile_page/personel_info.dart';

class ModifyInfoPage extends StatefulWidget {
  ModifyInfoPage({Key key}) : super(key: key);

  @override
  _ModifyInfoPageState createState() => _ModifyInfoPageState();
}

class _ModifyInfoPageState extends State<ModifyInfoPage> {
  TextEditingController _userNameController;
  TextEditingController _websiteController;
  TextEditingController _bioController;

  @override
  void initState() {
    _userNameController = TextEditingController();
    _websiteController = TextEditingController();
    _bioController = TextEditingController();
    getCurrentUserData();
    super.initState();
  }

  final formKey = GlobalKey<FormState>();

  User _user = User();
  bool loading = true;
  void getCurrentUserData() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseUser user = await auth.currentUser();

      final uid = user.uid;

      final document =
          await Firestore.instance.collection("users").document(uid).get();
      _user = User.fromMap(document.data);
      print(_user.userId);
      _userNameController.text = _user.name;
      _bioController.text = _user.bio;
      _websiteController.text = _user.website;
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
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Modify Profile',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.blue,
              size: 30,
            ),
            onPressed: () async {
              if (!formKey.currentState.validate()) {
                return;
              }
              await Firestore.instance
                  .collection('users')
                  .document(_user.userId)
                  .updateData({
                'name': _userNameController.text,
                'website': _websiteController.text,
                'bio': _bioController.text,
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTop(),
              _buildUpdating(
                'Username :',
                _userNameController,
                Validators.emptyValidator,
              ),
              _buildUpdating(
                'Website :',
                _websiteController,
                Validators.emptyValidator,
              ),
              _buildUpdating(
                'Bio :',
                _bioController,
                Validators.emptyValidator,
              ),
              InkWell(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.grey[200]),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Personel Information',
                        style: TextStyle(
                          fontSize: DS.setSP(15),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonelInfoPage(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildUpdating(
      String text, TextEditingController controller, Function validator) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(color: Colors.grey[600]),
          ),
          TextFormField(
            validator: validator,
            controller: controller,
          )
        ],
      ),
    );
  }

  Column _buildTop() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            width: DS.setWidth(150),
            height: DS.setHeight(200),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: _user.imageUrl == null
                    ? AssetImage(Images.boyDoc)
                    : NetworkImage(_user.imageUrl),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        InkWell(
          child: Text(
            'Change Picture',
            style: TextStyle(
              fontSize: DS.setSP(15),
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () => AuthProvider().uploadProfilePicture(ImageSource.gallery),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class _user {}
