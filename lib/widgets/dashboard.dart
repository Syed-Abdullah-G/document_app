import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:core';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:todo/provider/file_details_provider.dart';
import 'package:todo/styles/styles.dart';

final storageRef = FirebaseStorage.instance.ref();

class dashboardView extends ConsumerStatefulWidget {
  const dashboardView({super.key});

  @override
  ConsumerState<dashboardView> createState() => dashboardViewState();
}

class dashboardViewState extends ConsumerState<dashboardView> {
  DateTime now = DateTime.now();
  String? Email;

  //storage operations

  Future<void> _initData() async {
    getEmail();
    // await getTotalSize();
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<double> getFileSize(String cloudPath) async {
    try {
      final fileRef = storageRef.child(cloudPath);

      final metadata = await fileRef.getMetadata();
      final fileSize = metadata.size;

      final sizeInMB = fileSize! / 1048576;

      return sizeInMB;
    } on Exception catch (e) {
      print(e);
      return 0.0;
    }
  }

  void getEmail() async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
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

  Widget gradientCardSample(String email, String date, List<File> files) {
    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF846AFF),
              Color(0xFF755EE8),
              Colors.purpleAccent,
              Color.fromARGB(231, 231, 224, 18),
            ],
          ),
          borderRadius: BorderRadius.circular(
              16)), // Adds a gradient background and rounded corners to the container
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(email,
                    textAlign: TextAlign.start,
                    style: MyTextSample.headline(context)!.copyWith(
                        color: Colors.white,
                        fontFamily: "monospace")), // Adds a title to the card
                const Spacer(),

                Text(date,
                    style: MyTextSample.subhead(context)!.copyWith(
                        color: Colors.white,
                        fontFamily: "monospace")) // Adds a subtitle to the card
              ],
            ),
          ),

          // Adds a price to the bottom of the card
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fileProvider = ref.watch(fileDetailsProviderProvider);
    print('##########################${fileProvider.file_names}');
    final formattedDate = DateFormat('MMMM d, yyyy').format(now);
    return Email == null
        ? const Center(child: CircularProgressIndicator())
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                  child: Column(
                children: [
                  gradientCardSample(Email!, formattedDate, fileProvider.files),
                ],
              )),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: fileProvider.files.isNotEmpty
                    ? Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        margin: EdgeInsets.all(35),
                        color: Color.fromARGB(255, 211, 205, 187),
                        shadowColor: Colors.blueAccent,
                        child: fileProvider.files.isNotEmpty
                            ? ListView.builder(
                                itemCount: fileProvider.files.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                      onTap: () => OpenFile.open(
                                          fileProvider.files[index].path),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    border: Border(
                                                        top: BorderSide(
                                                            width: 0.7,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255)),
                                                        bottom: BorderSide(
                                                            width: 0.7,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255)))),
                                                child: ListTile(
                                                  title: Text(
                                                    fileProvider
                                                        .file_names[index]!,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  trailing: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      ElevatedButton(
                                                          onPressed: () async {
                                                            try {
                                                              final file = File(
                                                                  fileProvider
                                                                      .files[
                                                                          index]
                                                                      .path);
                                                              await storageRef
                                                                  .child(fileProvider
                                                                          .file_names[
                                                                      index]!)
                                                                  .putFile(
                                                                      file);
                                                              print(
                                                                  '-----------------------------------Success Fully Uploaded file---------------------------');
                                                            } on Exception catch (e) {
                                                              print(e);
                                                            }
                                                          },
                                                          child: const Text(
                                                              'Upload')),
                                                      ElevatedButton.icon(
                                                          onPressed: () async {
                                                            await Share
                                                                .shareXFiles([
                                                              XFile(fileProvider
                                                                  .files[index]
                                                                  .path)
                                                            ], text: 'Document');
                                                          },
                                                          label: Icon(Icons
                                                              .share_outlined)),
                                                      ElevatedButton.icon(
                                                          onPressed: () {
                                                            fileProvider.files
                                                                .removeAt(
                                                                    index);
                                                            fileProvider
                                                                .file_names
                                                                .removeAt(
                                                                    index);
                                                            setState(() {});
                                                          },
                                                          label: Icon(
                                                              Icons.remove)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ));
                                },
                              )
                            : Container())
                    : Center(
                        child: Text(
                        "Upload files using the + icon ",
                        style: TextStyle(fontSize: 15),
                      )),
              ),
            ],
          );
  }
}
