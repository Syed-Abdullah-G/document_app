import 'package:flutter/material.dart';
import 'package:todo/screens/home.dart';

class InitialSplash extends StatefulWidget {
  const InitialSplash({super.key});

  @override
  State<InitialSplash> createState() => _InitialSplashState();
}

class _InitialSplashState extends State<InitialSplash> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: RichText(text: const TextSpan(
        children: [
          TextSpan(text: "Clou",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40)),
          TextSpan(text: "Dox", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Color(0xFF706AFD)))
        ]
      )),),
    );
  }
}
