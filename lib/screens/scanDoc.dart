import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/provider/imageUpload.dart';

final storageRef = FirebaseStorage.instance.ref();

class scanDoc extends ConsumerStatefulWidget {
  const scanDoc({super.key});

  @override
  ConsumerState<scanDoc> createState() => _scanDocState();
}

class _scanDocState extends ConsumerState<scanDoc> {
  @override
  Widget build(BuildContext context) {
    final uploadedPaths = ref.watch(imageUploaderProvider);
    final paths = uploadedPaths.filePaths;
    return paths!.isNotEmpty
        ? ListView.builder(
            itemCount: paths.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Image.file(File(paths[index])),
                  SizedBox(height: 60,),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                          onPressed: () {
                            setState(() {
                              paths.removeAt(index);
                            });
                          },
                          child: Text("Cancel")),
                      ElevatedButton(
                          onPressed: () async {
                            try {
                              //TODO : get name from dialog box 
                              final file = File(paths[index]);
                              await storageRef
                                  .child('filename.png')  //TODO: store with user-entered name
                                  .putFile(file);
                              print(
                                  '-----------------------------------Success Fully Uploaded file---------------------------');
                            } on Exception catch (e) {
                              print(e);
                            }
                          },
                          child: Text('Upload'))
                    ],
                  )
                ],
              );
            },
          )
        : Center(
            child: Text('Scan Images'),
          );
  }
}
