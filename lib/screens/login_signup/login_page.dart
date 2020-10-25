import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:opScienceProject/providers/auht_provider.dart';
import 'package:opScienceProject/res/screen_size_utils.dart';
import 'package:opScienceProject/res/validators.dart';
import 'package:opScienceProject/screens/login_signup/signUp_page.dart';

import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _userNameController;
  TextEditingController _passwordController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AuthProvider, bool>(
      selector: (context, AuthProvider value) => value.isLoading,
      builder: (context, value, child) {
        return LoadingOverlay(isLoading: value, child: child);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            width: DS.getWidth,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'OP SCIENCES',
                      style: TextStyle(
                        fontSize: DS.setSP(25),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: DS.setHeight(100)),
                    SizedBox(
                      width: DS.getWidth * .7,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: TextFormField(
                          validator: Validators.emailValidator,
                          controller: _userNameController,
                          keyboardType: TextInputType.name,
                          style: TextStyle(
                            fontSize: DS.setSP(20),
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade300,
                            filled: true,
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              fontSize: DS.setSP(17),
                              color: Colors.grey[700],
                            ),
                            prefixIcon: SizedBox(
                              width: 48,
                              height: 48,
                              child: Icon(
                                Icons.person,
                                color: Colors.grey[700],
                              ),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: DS.setHeight(20),
                    ),
                    SizedBox(
                      width: DS.getWidth * .7,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: TextFormField(
                          validator: Validators.passwordValidator,
                          controller: _passwordController,
                          keyboardType: TextInputType.name,
                          obscureText: true,
                          style: TextStyle(
                            fontSize: DS.setSP(20),
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade300,
                            filled: true,
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              fontSize: DS.setSP(17),
                              color: Colors.grey[700],
                            ),
                            prefixIcon: SizedBox(
                              width: 48,
                              height: 48,
                              child: Icon(
                                Icons.person,
                                color: Colors.grey[700],
                              ),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: DS.setHeight(20),
                    ),
                    InkWell(
                      onTap: () {
                        if (!formKey.currentState.validate()) return;
                        context.read<AuthProvider>().signIn(
                              email: _userNameController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                      },
                      child: Container(
                        width: DS.getWidth * .7,
                        height: DS.getHeight * 0.05,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: DS.setSP(25),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: DS.setHeight(20),
                    ),
                    Text(
                      'or',
                      style: TextStyle(
                        fontSize: DS.setSP(15),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: DS.setHeight(25),
                    ),
                    InkWell(
                      child: Container(
                        width: DS.getWidth * .7,
                        height: DS.getHeight * 0.05,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "SignUp",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: DS.setSP(25),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
