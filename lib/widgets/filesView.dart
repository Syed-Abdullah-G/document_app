import 'dart:collection';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/widgets/dashboard.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

final storageRef = FirebaseStorage.instance.ref();

class filesView extends StatefulWidget {
  const filesView({super.key});

  @override
  State<filesView> createState() => _filesViewState();
}

class _filesViewState extends State<filesView> {
  List fileItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async {
    try {
      ListResult listResult = await storageRef.listAll();
      for (Reference item in listResult.items) {
        String url = await item.getDownloadURL();
        setState(() {
          fileItems.add([item.name, url]);
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  downloadFromUrl(String url) async {
    final directory = await getApplicationDocumentsDirectory();
  final fileName = url.split('/').last;
  final filePath = '${directory.path}/$fileName';
  final file = File(filePath);
    FileDownloader.downloadFile(
        url: url,
        onDownloadCompleted: (String uri) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Download Successful'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close')),
                    TextButton(
                        onPressed: () async {
                          await OpenFile.open(filePath);
                        },
                        child: Text('Open')),
                  ],
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    print(
        "------------------------------------------------------------${fileItems}");
    if (fileItems.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount: fileItems.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                title: Text(
                  fileItems[index][0],
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                        onPressed: () {}, label: Icon(Icons.share)),
                    ElevatedButton.icon(
                        onPressed: () => downloadFromUrl(fileItems[index][1]),
                        label: Icon(Icons.download)),
                  ],
                ));
          }),
    );
  }
}
