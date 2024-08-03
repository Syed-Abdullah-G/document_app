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
  bool isUploading = false;

  Future<void> uploadFile(String filename) async {
    setState(() {
      isUploading = true;
    });
    try {
      final file = File(widget.imagesPath![0]);
      final uploadTask = storageRef.child(filename).putFile(file);

      //waiting for uploadTask to finish and then setting isUploading to false
      await uploadTask;
      setState(() {
        isUploading = false;
      });
      print(
          '-----------------------------------Success Fully Uploaded file---------------------------');
      Navigator.of(context).pop();
    } catch (e) {
      // Handle upload errors here
      print('Upload error: $e');
      setState(() {
        isUploading = false;
      });
      // Show an error message to the user
    }
  }

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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel')),
                      SizedBox(
                        width: 30,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            final filename = _controller.text;
                            await uploadFile(filename);
                          },
                          child: isUploading
                              ? CircularProgressIndicator()
                              : Text('Upload'))
                    ],
                  ),
                ],
              )
            : Container());
  }
}
