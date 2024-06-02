// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationFunctions {

  static signUp(BuildContext context, String emailAddress, String password, String firstName, String lastName) async {

    try {

      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      if (credential.user?.uid!=null) {
        await FirebaseFirestore.instance.collection('users').doc(
        credential.user!.uid 
      ).set({
        'uid': credential.user!.uid,
        'firstName': firstName,
        'lastName': lastName,
        'email': emailAddress
      });

      }

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Your account has been created successfully.')));

    } on FirebaseAuthException catch (e) {

      if (e.code == 'weak-password') {

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The password provided is too weak.')));

      } else if (e.code == 'email-already-in-use') {

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The account already exists for that email.')));

      }

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong!! Please try again after sometime!!')));
      
      print(e);

    }
  }



  static signIn(BuildContext context, String emailAddress, String password) async {

    try {

      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailAddress, password: password);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You are successfully logged in.')));

    } on FirebaseAuthException catch (e) {

      if (e.code == 'user-not-found') {
        
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No user found for that email.')));

      } else if (e.code == 'wrong-password') {

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wrong password provided for that user.')));

      }

    }

  }
}
