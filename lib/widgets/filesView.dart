import 'dart:collection';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:todo/widgets/dashboard.dart';

class filesView extends StatefulWidget {
  const filesView({super.key});

  @override
  State<filesView> createState() => _filesViewState();
}

class _filesViewState extends State<filesView> {
  ListResult? listResult;


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }


  void loadData() async{
final storageRef = FirebaseStorage.instance.ref().child('files');
  ListResult result = await storageRef.listAll();
    setState(() {
      listResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (listResult == null) {
      return Center(child: CircularProgressIndicator(),);
    }
      
    return Scaffold(
      body: ListView.builder(
        itemCount: listResult!.items.length
        ,itemBuilder: (BuildContext context, int index) {
       final item = listResult!.items[index];
       return ListTile(title: Text(item.name),);
        }

      ),
    );
  }
}