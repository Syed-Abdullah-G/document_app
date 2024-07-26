import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
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

    return Column(children: [
      SizedBox(
        height: 70,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
            height: (MediaQuery.of(context).size.height) / 4,
            width: MediaQuery.of(context).size.width,
            child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              margin: EdgeInsets.all(10),
              color: Color.fromARGB(106, 199, 195, 186),
              child: Row(
                children: [
                  SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                          startAngle: 180,
                          endAngle: 360,
                          showTicks: false,
                          showLabels: false,
                          canScaleToFit: true,
                          radiusFactor: 0.8,
                          maximum: 5000,
                          axisLineStyle: AxisLineStyle(thickness: 40),
                          pointers: <GaugePointer>[
                            RangePointer(
                              enableAnimation: true,
                              animationType: AnimationType.easeOutBack,
                              width: 40,
                              color: Color(0xFF00A8B5),
                              value: totalSize,
                              gradient: SweepGradient(colors: <Color>[
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
                                needleLength: 0.98,
                                value: totalSize,
                                enableAnimation: true,
                                animationType: AnimationType.easeOutBack)
                          ])
                    ],
                  ),
                  SizedBox(
                    width: 80,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        totalSize.toStringAsFixed(2),
                        style: GoogleFonts.archivo(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Used Out of',
                        style: GoogleFonts.archivo(fontSize: 25, color: Colors.white),
                      ),
                      Text(
                        '5 GB',
                        style: GoogleFonts.archivo(color: Colors.white, fontSize: 50,fontWeight: FontWeight.w100),
                      )
                    ],
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
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton.icon(
                            onPressed: () {}, label: Icon(Icons.share)),
                        ElevatedButton.icon(
                            onPressed: () =>
                                downloadFromUrl(fileItems[index][1]),
                            label: Icon(Icons.download)),
                      ],
                    ));
              }),
        ),
      ),
    ]);
  }
}
