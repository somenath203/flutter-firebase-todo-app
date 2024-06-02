// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:firebaseflutter/services/functions/authentication.dart';
import 'package:flutter/material.dart';


class AuthenticationForm extends StatefulWidget {
  
  const AuthenticationForm({super.key});

  @override
  State<AuthenticationForm> createState() => _AuthenticationFormState();
}

class _AuthenticationFormState extends State<AuthenticationForm> {

  final _formkey = GlobalKey<FormState>();

  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';

  bool isLogin = true; 

  changeIsLoginValue() {
    setState(() {
      isLogin = !isLogin; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          title:
              const Text('Login/Signup', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        body: Form(
          key: _formkey,
          child: Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (!isLogin) TextFormField(
                  key: const ValueKey('first_name'),
                  decoration: const InputDecoration(hintText: 'Enter First Name', prefixIcon: Icon(Icons.person_outline)),
                  validator: (val) {
                    if (val.toString().isEmpty) {
                      return 'Input field is either empty.';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (val) {
                    setState(() {
                      firstName = val.toString();
                    });
                  }, // placeholder
                ),
                if (!isLogin) TextFormField(
                  key: const ValueKey('last_name'),
                  decoration: const InputDecoration(hintText: 'Enter Last Name', prefixIcon: Icon(Icons.person_2_outlined)), 
                  validator: (val) { 
                    if (val.toString().isEmpty) {
                      return 'Input field is either empty.';
                    } else {
                      return null;
                    }
                   },
                  onSaved: (val) {
                    setState(() {
                      lastName = val.toString();
                    });
                  }// placeholder
                ),
                TextFormField(
                  key: const ValueKey('email_address'),
                  decoration: const InputDecoration(hintText: 'Enter Email Address', prefixIcon: Icon(Icons.email_outlined)),
                  validator: (val) {
                    if (val.toString().isEmpty || !val.toString().contains('@')) {
                      return 'Input field is either empty or email address is in wrong format.';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (val) {
                    setState(() {
                      email = val.toString();
                    });
                  } // placeholder
                ),
                TextFormField(
                  key: const ValueKey('password'),
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Enter Password', prefixIcon: Icon(Icons.lock_outline)), 
                  validator: (val) {
                    if (val.toString().isEmpty || val.toString().length < 6) {
                      return 'Input field is either empty or the length of the string is less than 6.';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (val) {
                    setState(() {
                      password = val.toString();
                    });
                  }// placeholder
                ),
                
                SizedBox(height: 20),

                SizedBox(
                  width: double.maxFinite,
                  height: 40,
                  child: ElevatedButton(onPressed: (){
                    if(_formkey.currentState!.validate()) {

                      _formkey.currentState!.save(); 

                      isLogin ? AuthenticationFunctions.signIn(context, email, password) : AuthenticationFunctions.signUp(context, email, password, firstName, lastName);
                    }
                  }, child: Text( isLogin ? 'Login' : 'Signup', style: TextStyle(color: Colors.white)), style: ElevatedButton.styleFrom(backgroundColor: Colors.blue))
                ),

                TextButton(onPressed: () => changeIsLoginValue(), child: isLogin ? Text('Don\'t have an account? Signup', style: TextStyle(color: Colors.blue)) : Text('Already have an account? Login', style: TextStyle(color: Colors.blue)))
              ],
            ),
          ),
        ));
  }
}
