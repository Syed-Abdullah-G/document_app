import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:core';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
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
  late List<File> files = [];
  late List<String?> file_names;
  double totalSize = 0.0;
  late List<String?> file_paths;

//   Future<double> getTotalSize() async {
//     try {
//       ListResult res =
//           await filesRef.listAll(); // Wait for listAll() to complete

//       for (Reference itemRef in res.items) {
//         double size = await getFileSize(
//             itemRef.fullPath);
//             print(itemRef.fullPath);// Wait for getFileSize() to complete
//         totalSize += size;

// // Add the size to totalSize
//       }
//       setState(() {
//         totalSize = totalSize;
//       });
//       return totalSize;
//     } catch (e) {
//       return 0.0;
//     }
//   }

  //storage operations

  void _pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    Navigator.pop(context);

    if (result != null) {
      setState(() {
        files = result.paths.map((path) => File(path!)).toList();
        file_names = result.names;
        file_paths = result.paths;
      });
    } else {
      print('---------------------operation cancelled---------------------');
    }
  }

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
    final formattedDate = DateFormat('MMMM d, yyyy').format(now);
    return Email == null
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(appBar: AppBar(title: Text('Home'),),
            body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                  child: Column(
                children: [
                  gradientCardSample(Email!, formattedDate, files),
                ],
              )),
              const SizedBox(
                height: 50,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     FutureBuilder(
              //       future: getTotalSize(),
              //       builder: (context, snapshot) {
              //         if (snapshot.hasData) {
              //           return SizedBox(
              //             height: 200,
              //             width: 200,
              //             child: SfRadialGauge(
              //                 enableLoadingAnimation: true,
              //                 animationDuration: 4500,
              //                 axes: <RadialAxis>[
              //                   RadialAxis(
              //                       minimum: 0,
              //                       maximum: 5,
              //                       ranges: <GaugeRange>[
              //                         GaugeRange(
              //                             startValue: 0,
              //                             endValue: 2.3,
              //                             color: Colors.green,
              //                             startWidth: 10,
              //                             endWidth: 10),
              //                         GaugeRange(
              //                             startValue: 2.3,
              //                             endValue: 4,
              //                             color: Colors.orange,
              //                             startWidth: 10,
              //                             endWidth: 10),
              //                         GaugeRange(
              //                             startValue: 4,
              //                             endValue: 5,
              //                             color: Colors.red,
              //                             startWidth: 10,
              //                             endWidth: 10)
              //                       ],
              //                       pointers: <GaugePointer>[
              //                         NeedlePointer(
              //                           value: totalSize,
              //                         )
              //                       ],
              //                       annotations: <GaugeAnnotation>[
              //                         GaugeAnnotation(
              //                             widget: Container(
              //                                 child: Text(totalSize.toString(),
              //                                     style: const TextStyle(
              //                                         fontSize: 25,
              //                                         fontWeight:
              //                                             FontWeight.bold))),
              //                             angle: 90,
              //                             positionFactor: 0.5)
              //                       ])
              //                 ]),
              //           );
              //         } else {
              //           return Container();
              //         }
              //       },
              //     ),
              //   ],
              // ),
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
                                    label: const Text('Upload Documents')),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Close BottomSheet')),
                              ],
                            ),
                          ),
                        );
                      },
                      context: context,
                    );
                    print('-------------after widget rebuild-------');
                    print(files);
                  },
                  label: const Icon(Icons.add)),
              Expanded(
                  child: files.isNotEmpty
                      ? ListView.builder(
                          itemCount: files.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                                onTap: () => OpenFile.open(files[index].path),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        title: Text(file_names[index]!),
                                      ),
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            try {
                                              final file =
                                                  File(files[index].path);
                                              await storageRef
                                                  .child(file_names[index]!)
                                                  .putFile(file);
                                              print(
                                                  '-----------------------------------Success Fully Uploaded file---------------------------');
                                            } on Exception catch (e) {
                                              print(e);
                                            }
                                          },
                                          child: const Text('Upload')),
                                    ),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                          onPressed: () async {
                                            await Share.shareXFiles(
                                                [XFile(files[index].path)],
                                                text: 'Great Document');
                                          },
                                          label: const Text('Share')),
                                    ),
                                  ],
                                ));
                          },
                        )
                      : Container())
            ],
          ));
  }
}
