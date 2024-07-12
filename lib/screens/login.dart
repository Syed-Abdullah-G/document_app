import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/user_data.dart';
import 'package:todo/provider/details.dart';
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

          final uploadUserData = userDataNotifier.toMap(_enteredEmail, _enteredPassword, FirebaseAuth.instance.currentUser!.uid);


        await db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set(uploadUserData);
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authentication Failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color.fromARGB(255, 25, 26, 31),
      body: Column(
        children: [
          Image.asset(
            'assets/logo/logo-white-removebg-preview.png',
            width: 300,
            height: 300,
          ),
          Form(
              key: _formkey,
              child: _isLogin
                  ? Column(
                      children: [
                        Container(
                          child: Text(
                            'Login Page',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Email'),
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
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Password'),
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
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: _submit, child: Text('Login')),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = false;
                              });
                            },
                            child: Text('Create an account'))
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
                          decoration: InputDecoration(labelText: 'Email'),
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
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Password'),
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
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: _submit, child: Text('Create')),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = true;
                              });
                            },
                            child: Text('Login'))
                      ],
                    ))
        ],
      ),
    );
  }
}
