// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebaseflutter/pages/update_todo.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text('YourTodo',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            actions: [
              IconButton(onPressed: (){
                FirebaseAuth.instance.signOut();
              }, icon: const Icon(Icons.logout_outlined), color: Colors.white) 
            ],
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
                    decoration: InputDecoration(hintText: 'Enter Todo Title'),
                    controller: titleController,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(hintText: 'Enter Todo Description'),
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
                              .instance.collection('users')
                              .doc(user?.uid)
                              .collection('todos')
                              .add({
                                'title': titleController.text,
                                'description': descriptionController.text
                             });
                          
                        } else {

                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill both the inpu fields.')));

                        }

                      }

                    }, child: Text('Create Todo', style: TextStyle(color: Colors.white)), style: ElevatedButton.styleFrom(backgroundColor: Colors.blue))
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(

                child: StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).collection('todos').snapshots(), builder: (context, snapshot) {
                  
                  if(snapshot.connectionState == ConnectionState.waiting) {

                    return const Center(
                      child: CircularProgressIndicator()
                    );

                  } else {

                    final docs = snapshot.data!.docs;

                    return ListView.builder(itemCount: docs.length, itemBuilder: (context, index) {
                      return Dismissible(
                        key: ValueKey(docs[index].id),
                        onDismissed: (direction) async {
                          await FirebaseFirestore
                            .instance.collection('users')
                            .doc(user?.uid)
                            .collection('todos')
                            .doc(docs[index].id)
                            .delete();
                        }, 
                        child: ListTile( 
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateTodo(
                                title: docs[index]['title'], 
                                description: docs[index]['description'], 
                                idOfTodoDocumentToBeUpdated: docs[index].id)
                              ));
                            },
                            title: Text(docs[index]['title']), 
                            subtitle: Text(docs[index]['description'])
                      ));
                    });

                  }
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
