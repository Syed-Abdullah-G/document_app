import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:todo/widgets/dashboard.dart';

final storageRef = FirebaseStorage.instance.ref();

class uploadedPage extends StatefulWidget {
  uploadedPage({super.key, required this.imagesPath});

  List<String>? imagesPath;

  @override
  State<uploadedPage> createState() => _uploadedPageState();
}

class _uploadedPageState extends State<uploadedPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.imagesPath!.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    child: Image.file(File(widget.imagesPath![0])),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(onPressed: () {
                        Navigator.of(context).pop();
                      }, child: Text('Cancel')),
                      ElevatedButton(
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Enter Filename"),
                                    actions: [
                                      TextField(
                                        controller: _controller,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: "Enter Filename"),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        children: [
                                          TextButton.icon(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              label:
                                                  Icon(Icons.cancel_outlined)),
                                          TextButton.icon(
                                              onPressed: () async {
                                                try {
                                                  final filename =
                                                      _controller.text;
                                                  final file = File(
                                                      widget.imagesPath![0]);
                                                  await storageRef
                                                      .child(filename)
                                                      .putFile(file);
                                                  print(
                                                      '-----------------------------------Success Fully Uploaded file---------------------------');
                                                } catch (e) {
                                                  print(e);
                                                }
                                              },
                                              label: Icon(
                                                  Icons.check_circle_rounded)),
                                        ],
                                      )
                                    ],
                                  );
                                });
                          },
                          child: Text('Upload'))
                    ],
                  )
                ],
              )
            : Container());
  }
}
