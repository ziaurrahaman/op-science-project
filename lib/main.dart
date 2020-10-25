import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opScienceProject/providers/auht_provider.dart';
import 'package:opScienceProject/res/screen_size_utils.dart';
import 'package:opScienceProject/screens/splash_screen/splash_screen.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
          lazy: false,
        )
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'OP PVT',
        builder: (context, child) {
          ScreenUtil.instance = ScreenUtil(width: 414, height: 896)
            ..init(context);
          return child;
        },
        theme: ThemeData(
          fontFamily: 'Helvetica Neue',
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
