import 'package:flutter/material.dart';
import 'package:todo/widgets/filesView.dart';

class myFile extends StatefulWidget {
  const myFile({super.key});

  @override
  State<myFile> createState() => _myFileState();
}

class _myFileState extends State<myFile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: filesView(),);
  }
}