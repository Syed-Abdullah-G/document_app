import 'package:flutter/material.dart';
import 'package:todo/widgets/dashboard.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color.fromARGB(255, 25, 26, 31),
      appBar: AppBar(
        title: Text('DoxStore'),
        actions: [IconButton(onPressed: (){

        }, icon: Icon(Icons.exit_to_app,))],),
        body: dashboardView(),
    );
  }
}