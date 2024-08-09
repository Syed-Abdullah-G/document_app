import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:core';
import 'package:intl/intl.dart';
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
  bool _uploading = false;

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
      height: MediaQuery.of(context).size.height * 0.2,
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
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(email,
                    textAlign: TextAlign.start,
                    style: MyTextSample.headline(context)!.copyWith(
                        color: Colors.white,
                        fontFamily: "monospace",
                        fontSize: 20)), // Adds a title to the card
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
                        margin: const EdgeInsets.all(20),
                        color: const Color.fromARGB(255, 211, 205, 187),
                        shadowColor: Colors.blueAccent,
                        child: fileProvider.files.isNotEmpty
                            ? Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: fileProvider.files.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                            onTap: () => OpenFile.open(
                                                fileProvider.files[index].path),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(25),
                                                          border: const Border(
                                                              top: BorderSide(
                                                                  width: 0.7,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255)),
                                                              bottom: BorderSide(
                                                                  width: 0.7,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255)))),
                                                      child: ListTile(
                                                          title: Text(
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            fileProvider
                                                                    .file_names[
                                                                index]!,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14),
                                                          ),
                                                          trailing:
                                                              PopupMenuButton(
                                                            icon: const Icon(
                                                                color: Colors
                                                                    .black,
                                                                Icons
                                                                    .more_horiz),
                                                            itemBuilder:
                                                                (context) => [
                                                              PopupMenuItem(
                                                                value: 0,
                                                                child: _uploading
                                                                    ? const CircularProgressIndicator()
                                                                    : Text(
                                                                        "Upload",
                                                                        style: GoogleFonts.archivo(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                              ),
                                                              PopupMenuItem(
                                                                value: 1,
                                                                child: Text(
                                                                  "Delete",
                                                                  style: GoogleFonts.archivo(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),
                                                            ],
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                            elevation: 5,
                                                            offset:
                                                                const Offset(
                                                                    0, 50),
                                                            onSelected:
                                                                (value) async {
                                                              switch (value) {
                                                                case 0:
                                                                  setState(() {
                                                                    _uploading =
                                                                        true;
                                                                  });
                                                                  try {
                                                                    final file = File(fileProvider
                                                                        .files[
                                                                            index]
                                                                        .path);
                                                                    await storageRef
                                                                        .child(fileProvider.file_names[
                                                                            index]!)
                                                                        .putFile(
                                                                            file);
                                                                    print(
                                                                        '-----------------------------------Success Fully Uploaded file---------------------------');
                                                                  } on Exception catch (e) {
                                                                    print(e);
                                                                  } finally {
                                                                    setState(
                                                                        () {
                                                                      _uploading =
                                                                          false;
                                                                    });
                                                                  }

                                                                  break;
                                                                case 1:
                                                                  fileProvider
                                                                      .files
                                                                      .removeAt(
                                                                          index);
                                                                  fileProvider
                                                                      .file_names
                                                                      .removeAt(
                                                                          index);
                                                                  setState(
                                                                      () {});

                                                                  break;
                                                              }
                                                            },
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ));
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            _uploading = true;
                                          });
                                          try {
                                            for (int i = 0;
                                                i < fileProvider.files.length;
                                                i++) {
                                              final file = File(
                                                  fileProvider.files[i].path);
                                              await storageRef
                                                  .child(fileProvider
                                                      .file_names[i]!)
                                                  .putFile(file);
                                            }
                                          } on Exception catch (e) {
                                            print(e);
                                          } finally {
                                            setState(() {
                                              _uploading = false;
                                            });
                                            fileProvider.files.clear();
                                          }
                                        },
                                        child: _uploading
                                            ? const CircularProgressIndicator(
                                                color: Colors.white,
                                              )
                                            : const Text("Upload All")),
                                  ),
                                ],
                              )
                            : Container())
                    : const Center(
                        child: Text(
                        "Upload files using the + icon ",
                        style: TextStyle(fontSize: 15),
                      )),
              ),
            ],
          );
  }
}
