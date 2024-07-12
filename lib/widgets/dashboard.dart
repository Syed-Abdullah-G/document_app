import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/provider/details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class dashboardView extends ConsumerStatefulWidget {
  const dashboardView({super.key});

  @override
  ConsumerState<dashboardView> createState() => dashboardViewState();
}

class dashboardViewState extends ConsumerState<dashboardView> {
  DateTime now = DateTime.now();
  String? Email;

  void _pickFiles() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
      allowMultiple: true,
    );

    if (result!= null) {
      for (PlatformFile file in result.files) {
        // Process each file individually
        print('File path: ${file.path}');
        print('File name: ${file.name}');
        print('File size: ${file.size}');
        // Add your file processing logic here
      }
    } else {
      print('No files selected');
    }
  } catch (e) {
    print('Error picking files: $e');
  }
}

  @override
  void initState() {
    super.initState();
    getEmail();
  }

  void getEmail() async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc('${FirebaseAuth.instance.currentUser!.uid}');
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>?;
        setState(() {
          Email = data?['email'];
        });
      },
      onError: (e) => print('Error getting document: $e'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMMM d, yyyy').format(now);
    return Email == null
        ? Center(child: CircularProgressIndicator())
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hi, ${Email}'),
              Text(formattedDate),
              SizedBox(
                height: 30,
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton.icon(
                                    onPressed: () {
                                      _pickFiles();
                                    },
                                    label: Text('Upload Documents')),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Close BottomSheet'))
                              ],
                            ),
                          ),
                        );
                      },
                      context: context,
                    );
                  },
                  label: Icon(Icons.add))
            ],
          );
  }
}
