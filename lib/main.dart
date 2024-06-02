// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebaseflutter/pages/authentication_form.dart';
import 'package:firebaseflutter/pages/home.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(

        stream: FirebaseAuth.instance.authStateChanges(), 

        builder: ((context, snapshot) {

          if(snapshot.hasData) {

            return const MyHomePage();

          } else {

            return const AuthenticationForm();
            
          }

        })),
    );
  }
}