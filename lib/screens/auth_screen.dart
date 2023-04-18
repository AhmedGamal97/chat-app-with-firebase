import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final auth = FirebaseAuth.instance;
  bool _isLoading = false;
  void submitAuthForm(String email, String password, String username,
      File image, bool isLogin, BuildContext ctx) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin == true) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_imnage')
            .child('${authResult.user!.uid}jpg');
        await ref.putFile(image);
        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users/')
            .doc(authResult.user!.uid)
            .set({
          'username': username,
          'password': password,
          'image_url': url,
        });
      }
    } on FirebaseAuthException catch (e) {
      String message = 'error Occurred';
      if (isLogin == false && e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (isLogin == false && e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (isLogin == true && e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (isLogin == true && e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      final snackBar = SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(submitAuthForm, _isLoading),
    );
  }
}
