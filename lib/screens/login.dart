import 'dart:developer';
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
                            fontSize: 80, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 197, 174, 216),
                              borderRadius: BorderRadius.circular(30)),
                          height: screenHeight * 0.3,
                          width: screenWidth * 0.8,
                          child: Card(
                            color: Colors.transparent,
                            margin: EdgeInsets.all(50),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
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
                                  height: screenHeight * 0.02,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
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
                          )),
                          SizedBox(height: 10,),
                      CustomButton(
                        width: 200,
                        backgroundColor: Colors.white,
                        isThreeD: true,
                        height: 50,
                        borderRadius: 25,
                        animate: true,
                        margin: const EdgeInsets.all(10),
                        onPressed: () {},
                        child: Text(
                          "Login",style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height:10,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account ? Create one",style: GoogleFonts.dmSans(),),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = false;
                                });
                              },
                              child: const Text('Create an account')),
                        ],
                      )
                    ],
                  )
                : Column(
                    children: [
                      Container(
                        child: Text(
                          'Create an account',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Email'),
                        onSaved: (String? value) {
                          setState(() {
                            _enteredEmail = value!;
                          });
                        },
                        validator: (String? value) {
                          return (value == null || !value.contains('@'))
                              ? 'Please enter a proper Email address'
                              : null;
                        },
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Password'),
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
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      ElevatedButton(
                          onPressed: _submit, child: const Text('Create')),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = true;
                            });
                          },
                          child: const Text('Login'))
                    ],
                  )));
  }
}
