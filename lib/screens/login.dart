import 'package:custom_button_builder/custom_button_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/models/user_data.dart';
import 'package:todo/provider/details.dart';

final _firebase = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formkey = GlobalKey<FormState>();

  var _enteredEmail = '';
  var _enteredPassword = '';
  var _isLogin = true;

  void _submit() async {
    final isValid = _formkey.currentState!.validate();

    if (!isValid) {
      return;
    }
    print(_enteredEmail);

    _formkey.currentState!.save();

    try {
      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        print(
            '---------------------Account Successfully Created---------------------------');

        final userlogin = userData(
            email: _enteredEmail,
            password: _enteredPassword,
            userid: FirebaseAuth.instance.currentUser!.uid);

        final userDataNotifier = ref.watch(userDataNotifierProvider.notifier);
        userDataNotifier.addData(userlogin);

        final uploadUserData = userDataNotifier.toMap(_enteredEmail,
            _enteredPassword, FirebaseAuth.instance.currentUser!.uid);

        await db
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(uploadUserData);
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authentication Failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 25, 26, 31),
        body: Form(
            key: _formkey,
            child: _isLogin
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: screenHeight * 0.1,
                      ),
                      Text(
                        'Login',
                        style: GoogleFonts.archivo(
                            fontSize: 70, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),SizedBox(height: 300,width: 600,
                        child: Card(shape: 
                        RoundedRectangleBorder(
                          side: const BorderSide(color: Color(0xff706AFD)),
                          borderRadius: BorderRadius.circular(10)
                        ),
                            color: const Color.fromARGB(115, 138, 136, 136),
                              margin: const EdgeInsets.all(50),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: TextFormField(
                                      decoration:  InputDecoration(border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),borderSide: BorderSide.none 
                                      ),
                                        filled: true,fillColor: Colors.grey,labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                                          labelText: 'Email'),
                                      onSaved: (String? value) {
                                        setState(() {
                                          _enteredEmail = value!;
                                        });
                                      },
                                      validator: (String? value) {
                                        return (value == null ||
                                                !value.contains('@'))
                                            ? 'Please enter a proper Email address'
                                            : null;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.01,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: TextFormField(
                                      decoration:  InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none
                                        ),filled: true,fillColor: Colors.grey,labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                                          labelText: 'Password'),
                                      onSaved: (String? value) {
                                        setState(() {
                                          _enteredPassword = value!;
                                        });
                                      },
                                      validator: (String? value) {
                                        return (value == null || value.length < 4)
                                            ? 'Please choose a proper password'
                                            : null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      ),
                      CustomButton(
                        width: 200,
                        backgroundColor: Colors.white,
                        isThreeD: true,
                        height: 50,
                        borderRadius: 25,
                        animate: true,
                        margin: const EdgeInsets.all(10),
                        onPressed: _submit,
                        child: const Text(
                          "Login",style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        height:10,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account ?",style: GoogleFonts.dmSans(),),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = false;
                                });
                              },
                              child: const Text('Create an account',style: TextStyle(color: Color.fromARGB(255, 51, 103, 194)),)),
                        ],
                      )
                    ],
                  )
                :                        Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: screenHeight * 0.1,
                      ),
                      Text(
                        'Create Account',
                        style: GoogleFonts.archivo(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),SizedBox(height: 300,width: 600,
                        child: Card(shape: 
                        RoundedRectangleBorder(
                          side: const BorderSide(color: Color(0xff706AFD)),
                          borderRadius: BorderRadius.circular(10)
                        ),
                            color: const Color.fromARGB(115, 138, 136, 136),
                              margin: const EdgeInsets.all(50),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: TextFormField(
                                      decoration:  InputDecoration(border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),borderSide: BorderSide.none 
                                      ),
                                        filled: true,fillColor: Colors.grey,labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                                          labelText: 'Email'),
                                      onSaved: (String? value) {
                                        setState(() {
                                          _enteredEmail = value!;
                                        });
                                      },
                                      validator: (String? value) {
                                        return (value == null ||
                                                !value.contains('@'))
                                            ? 'Please enter a proper Email address'
                                            : null;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.01,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: TextFormField(
                                      decoration:  InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none
                                        ),filled: true,fillColor: Colors.grey,labelStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                                          labelText: 'Password'),
                                      onSaved: (String? value) {
                                        setState(() {
                                          _enteredPassword = value!;
                                        });
                                      },
                                      validator: (String? value) {
                                        return (value == null || value.length < 4)
                                            ? 'Please choose a proper password'
                                            : null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      ),
                      CustomButton(
                        width: 200,
                        backgroundColor: Colors.white,
                        isThreeD: true,
                        height: 50,
                        borderRadius: 25,
                        animate: true,
                        margin: const EdgeInsets.all(10),
                        onPressed: _submit,
                        child: const Text(
                          "Create",style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        height:10,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account ?",style: GoogleFonts.dmSans(),),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = true;
                                });
                              },
                              child: const Text('Login',style: TextStyle(color: Color.fromARGB(255, 51, 103, 194)),)),
                        ],
                      )
                    ],
                  )));
  }
}
