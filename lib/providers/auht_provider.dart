import 'dart:async';
import 'dart:io';

import 'package:opScienceProject/models/user.dart';
import 'package:opScienceProject/providers/base_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opScienceProject/res/platform_dialogue.dart';
import 'package:opScienceProject/screens/tab_view/tab_view.dart';

import 'package:path_provider/path_provider.dart';

class AuthProvider extends BaseProvider {
  FirebaseStorage firebaseStorage;

  AuthProvider() {
    _auth = FirebaseAuth.instance;

    firebaseStorage = FirebaseStorage.instance;
    firebaseStorage
        .setMaxUploadRetryTimeMillis(Duration(seconds: 5).inMilliseconds);

    Timer(Duration(seconds: 2), () async {
      _user = await _auth.currentUser();
      if (_user == null) {
        Get.offAll(TabView());
      } else {
        navigateToTabsPage(_user);
      }
    });
  }

  FirebaseAuth _auth;
  FirebaseUser _user;
  FirebaseUser get firebaseUser => _user;

  User user;

  File image;

  String name;

  Future<void> signIn({String email, String password}) async {
    try {
      setViewState(true);
      final authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _user = authResult.user;

      setViewState(false);
      navigateToTabsPage(_user);
    } on SocketException catch (_) {
      showPlatformDialogue(title: "Network Connection Error");
    } catch (e) {
      setViewState(false);
      if (e.code == "ERROR_WRONG_PASSWORD") {
        showPlatformDialogue(title: "Wrong Password");
      } else if (e.code == "ERROR_USER_NOT_FOUND") {
        showPlatformDialogue(
          title: "User Not Found",
          content: Text("Please Check Your Email, Or Signing up"),
        );
      } else {
        showPlatformDialogue(title: e.code);
      }
    }
  }

  Future<void> signUp({String email, String password, String name}) async {
    try {
      setViewState(true);
      final authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = authResult.user;
      this.name = name;
      await _user.updateProfile((UserUpdateInfo()..displayName = name));
      await addUserDataToFirebase(name, email);
      setViewState(false);
      navigateToTabsPage(_user);
    } on SocketException catch (_) {
      setViewState(false);
      showPlatformDialogue(title: "Network Connection Error");
    } catch (e) {
      setViewState(false);
      if (e.code == "ERROR_EMAIL_ALREADY_IN_USE") {
        showPlatformDialogue(title: "Email Already In Use");
      } else {
        showPlatformDialogue(title: e.code);
      }
    }
  }

  Future<void> addUserDataToFirebase(String name, String email,
      [String imageUrl]) async {
    print("ADDING USER DATA TO FIRENASE");

    User user = User(
      email: email,
      name: name,
      likes: [],
      subscribers: [],
      userId: _user.uid,
      bio: '--',
      dob: '--',
      flag: '--',
      gender: '--',
      phoneNumber: '--',
      pinned: '--',
      subscribed: [],
      favourites: [],
      favourited: '--',
      liked: [],
      website: '--',
    );

    try {
      await Firestore.instance
          .collection("users")
          .document(_user.uid)
          .setData(user.toMap());
    } catch (e) {
      print("ERROR ADDING DATA TO FIREBAE");
      print(e);
      print(e.runtimeType);
    }
  }

  void navigateToTabsPage(FirebaseUser firebaseUser) async {
    if (firebaseUser != null) {
      Get.offAll(TabView());
    }
  }

  Future<bool> getUserData(FirebaseUser firebaseUser) async {
    final document = await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .get();
    print(document);
    if (document.exists) {
      return true;
    }
    return false;
  }

  signOut() {
    _user = null;
    name = null;
    _auth.signOut();

    Get.offAll(TabView());
  }

  uploadProfilePicture(ImageSource source) async {
    try {
      final image = await ImagePicker().getImage(source: source);
      if (image == null) return;
      setViewState(true);
      final filename = image.path.split("/").last;
      Directory tempDir = await getTemporaryDirectory();
      final compressedImage = await FlutterImageCompress.compressAndGetFile(
          image.path, tempDir.path + ".jpg");
      final storageReference =
          firebaseStorage.ref().child("profile_pictures").child(filename);
      final StorageUploadTask uploadTask =
          storageReference.putFile(compressedImage);
      final StorageTaskSnapshot snapshot = await uploadTask.onComplete;
      final imageUrl = await snapshot.ref.getDownloadURL();
      await updateProfilePicture(imageUrl);
      print("DOWNLOAD URL $imageUrl");
      setViewState(false);
    } on SocketException catch (_) {
      image = null;
      setViewState(false);
      showPlatformDialogue(title: "Network Connection Error");
      return false;
    } catch (e) {
      print(e);
      image = null;
      setViewState(false);
    }
  }

  Future<void> updateProfilePicture(String imageUrl) async {
    print(imageUrl);
    print(_user.uid);
    await Firestore.instance
        .collection("users")
        .document(_user.uid)
        .updateData({"profile_picture": imageUrl});
  }
}
