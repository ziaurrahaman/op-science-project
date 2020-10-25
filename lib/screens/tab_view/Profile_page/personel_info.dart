import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:opScienceProject/models/user.dart';
import 'package:opScienceProject/res/screen_size_utils.dart';
import 'package:opScienceProject/res/validators.dart';

class PersonelInfoPage extends StatefulWidget {
  const PersonelInfoPage({Key key}) : super(key: key);

  @override
  _PersonelInfoPageState createState() => _PersonelInfoPageState();
}

class _PersonelInfoPageState extends State<PersonelInfoPage> {
  TextEditingController _emailController;

  TextEditingController _phoneController;

  TextEditingController _genderController;

  String dateOfBirth;
  final format = DateFormat("yyyy-MM-dd");
  User _user = User();
  @override
  void initState() {
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _genderController = TextEditingController();

    getCurrentUserData();

    super.initState();
  }

  void getCurrentUserData() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();

    final uid = user.uid;

    final document =
        await Firestore.instance.collection("users").document(uid).get();

    _user = User.fromMap(document.data);
    _emailController.text = _user.email;
    _genderController.text = _user.gender;
    _phoneController.text = _user.phoneNumber;
    dateOfBirth = _user.dob;
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        title: Text(
          'Personel Information',
          style: TextStyle(
            color: Colors.black,
          ),
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
                'email': _emailController.text,
                'gender': _genderController.text,
                'phoneNumber': _phoneController.text,
                'dob': dateOfBirth,
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: DS.setHeight(100),
              ),
              _buildUpdating('Email Address :', _emailController,
                  Validators.emailValidator),
              _buildUpdating(
                  'Phone Number :', _phoneController, Validators.emptyValidator,
                  keyboard: TextInputType.phone),
              _buildUpdating(
                'Gender :',
                _genderController,
                Validators.emptyValidator,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(1950, 3, 5),
                        maxTime: DateTime.now(),
                        theme: DatePickerTheme(
                          backgroundColor: Color(0xFF0F0F0F),
                          itemStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          cancelStyle:
                              TextStyle(color: Colors.white, fontSize: 16),
                          doneStyle:
                              TextStyle(color: Colors.white, fontSize: 16),
                        ), onChanged: (date) {
                      print('change $date in time zone ' +
                          date.timeZoneOffset.inHours.toString());
                    }, onConfirm: (date) {
                      setState(
                        () {
                          dateOfBirth = format.format(date).toString();
                          print('confirm $date');
                        },
                      );
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: (dateOfBirth == null)
                          ? Row(
                              children: <Widget>[
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(
                                  width: DS.setWidth(100),
                                ),
                                Center(
                                  child: Text(
                                    'Select your date of birth',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Row(
                              children: <Widget>[
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: DS.setWidth(100),
                                ),
                                Text(
                                  dateOfBirth,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildUpdating(
      String text, TextEditingController controller, Function validator,
      {TextInputType keyboard}) {
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
            keyboardType: keyboard ?? TextInputType.text,
            validator: validator,
            controller: controller,
          )
        ],
      ),
    );
  }
}
