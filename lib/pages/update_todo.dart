// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateTodo extends StatefulWidget {

  final String title;
  final String description;
  final String idOfTodoDocumentToBeUpdated;
  
  const UpdateTodo({super.key, required this.title, required this.description, required this.idOfTodoDocumentToBeUpdated});

  @override
  State<UpdateTodo> createState() => _UpdateTodoState();
}

class _UpdateTodoState extends State<UpdateTodo> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    titleController.text = widget.title;
    descriptionController.text = widget.description; 
    super.initState();
  }

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text('Update Todo',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 200,
              color: Colors.grey.shade200,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(hintText: 'Enter Todo Title'),
                    controller: titleController,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(hintText: 'Enter Todo Description'),
                    controller: descriptionController,
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 40,
                    width: double.maxFinite,
                    child: ElevatedButton(onPressed: () async {
                      
                      if(user != null) {

                        if(titleController.text != '' && descriptionController.text != '') {

                            await FirebaseFirestore
                              .instance
                              .collection('users')
                              .doc(user!.uid)
                              .collection('todos')
                              .doc(widget.idOfTodoDocumentToBeUpdated)
                              .update({
                                'title': titleController.text,
                                'description': descriptionController.text
                              });

                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Todo updated successfully.')));
                          
                        } else {

                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill both the inpu fields.')));

                        }

                      }

                    }, child: Text('Update Todo', style: TextStyle(color: Colors.white)), style: ElevatedButton.styleFrom(backgroundColor: Colors.blue))
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}