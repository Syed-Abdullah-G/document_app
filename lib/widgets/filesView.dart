import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:flutter/material.dart';
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

  Future<void> downloadFromUrl(String url) async {
    FileDownloader.downloadFile(
        url: url,
        onDownloadCompleted: (String uri) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Download Successful ${uri}'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close')),
                    TextButton(
                        onPressed: () async {
                          final result = await OpenFile.open(uri);

                          
                       
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
