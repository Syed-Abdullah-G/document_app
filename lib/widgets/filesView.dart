import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

final filesRef = FirebaseStorage.instance.ref();

class filesView extends StatefulWidget {
  const filesView({super.key});

  @override
  State<filesView> createState() => _filesViewState();
}

class _filesViewState extends State<filesView> {
  List fileItems = [];
  final Color _darkNeedleColor = const Color(0xFFDCDCDC);
  double totalSize = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    getTotalSize();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const filesView()));
    });
  }

  Future<double> getTotalSize() async {
    try {
      ListResult res =
          await filesRef.listAll(); // Wait for listAll() to complete

      for (Reference itemRef in res.items) {
        double size = await getFileSize(
            itemRef.fullPath); // Wait for getFileSize() to complete
        totalSize += size;

// Add the size to totalSize
      }
      setState(() {
        totalSize = totalSize;
      });
      return totalSize;
    } catch (e) {
      return 0.0;
    }
  }

  Future<double> getFileSize(String cloudPath) async {
    try {
      final fileRef = filesRef.child(cloudPath);

      final metadata = await fileRef.getMetadata();
      final fileSize = metadata.size;

      final sizeInMB = fileSize! / 1048576;

      return sizeInMB;
    } on Exception catch (e) {
      print(e);
      return 0.0;
    }
  }

  loadData() async {
    try {
      ListResult listResult = await filesRef.listAll();
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

  deleteData(String fileName, int index) async {
    final deleteRef = filesRef.child(fileName);

    final result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Deletion'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context)
                      .pop(false), // Close dialog with false
                  child: const Text('No')),
              TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(true), // Close dialog with true
                  child: const Text('Yes')),
            ],
          );
        });

    if (result == true) {
      await deleteRef.delete();
      setState(() {
        fileItems.removeAt(index);
      });
      // await loadData();
      // await getTotalSize();
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
                  title: Text('Download Successful $uri'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close')),
                    TextButton(
                        onPressed: () async {
                          await OpenFile.open(uri);
                        },
                        child: const Text('Open')),
                  ],
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    if (fileItems.length == 0 && getTotalSize() == 0.0) {
      return Center(
        child: Lottie.asset("assets\animations\loading_animation.json",
            width: 100, height: 100, fit: BoxFit.fill),
      );
    } else {
      return Column(children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
              height: (MediaQuery.of(context).size.height) / 4,
              width: MediaQuery.of(context).size.width,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                color: const Color.fromARGB(106, 158, 147, 172),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                              startAngle: 180,
                              endAngle: 360,
                              showTicks: false,
                              showLabels: false,
                              canScaleToFit: true,
                              radiusFactor: 0.8,
                              maximum: 5000,
                              axisLineStyle: AxisLineStyle(
                                  thickness:
                                      MediaQuery.of(context).size.height *
                                          0.02),
                              pointers: <GaugePointer>[
                                RangePointer(
                                  enableAnimation: true,
                                  animationType: AnimationType.easeOutBack,
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                  color: const Color(0xFF00A8B5),
                                  value: totalSize,
                                  gradient: const SweepGradient(colors: <Color>[
                                    Color(0xFFD046CA),
                                    Color(0xFF6094EA)
                                  ], stops: <double>[
                                    0.25,
                                    0.75
                                  ]),
                                ),
                                NeedlePointer(
                                    knobStyle: KnobStyle(
                                        color: _darkNeedleColor,
                                        knobRadius: 5,
                                        sizeUnit: GaugeSizeUnit.logicalPixel),
                                    needleEndWidth: 2,
                                    needleStartWidth: 2,
                                    needleColor: _darkNeedleColor,
                                    needleLength:
                                        MediaQuery.of(context).size.height *
                                            0.15,
                                    value: totalSize,
                                    enableAnimation: true,
                                    animationType: AnimationType.easeOutBack)
                              ])
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 130,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          Text(
                            totalSize.toStringAsFixed(2),
                            style: GoogleFonts.archivo(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Used Out of',
                            style: GoogleFonts.archivo(
                                fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            '5 GB',
                            style: GoogleFonts.archivo(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w100),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemCount: fileItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      title: Text(
                        fileItems[index][0],
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: PopupMenuButton(
                        icon: const Icon(Icons.more_horiz),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 0,
                            child: Text(
                              "Share",
                              style: GoogleFonts.archivo(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
                          PopupMenuItem(
                            value: 1,
                            child: Text(
                              "Download",
                              style: GoogleFonts.archivo(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: Text(
                              "Delete",
                              style: GoogleFonts.archivo(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 5,
                        offset: const Offset(0, 50),
                        onSelected: (value) async {
                          switch (value) {
                            case 0:
                              await Share.share(
                                  'Check out this file: ${fileItems[index][1]}');
                              break;
                            case 1:
                              await downloadFromUrl(fileItems[index][1]);
                              break;
                            case 2:
                              await deleteData(fileItems[index][0], index);
                              break;
                          }
                        },
                      ));
                }),
          ),
        ),
      ]);
    }
  }
}
