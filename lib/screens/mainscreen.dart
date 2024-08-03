import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:todo/provider/file_details_provider.dart';
import 'package:todo/screens/myFile.dart';
import 'package:todo/screens/scanPage.dart';
import 'package:todo/widgets/dashboard.dart';

class Mainscreen extends ConsumerStatefulWidget {
  const Mainscreen({super.key});

  @override
  ConsumerState<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends ConsumerState<Mainscreen> {
  HawkFabMenuController hawkFabMenuController = HawkFabMenuController();

  int currentPageIndex = 0;
  late List<File> files = [];
  late List<String?> file_names;
  late List<String?> file_paths;

  pickFiles() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(allowMultiple: true);

      if (result != null) {
        files = result.paths.map((path) => File(path!)).toList();
        file_names = result.names;
        file_paths = result.paths;

        final fileProvider = ref.read(fileDetailsProviderProvider.notifier);

        fileProvider.addData(file_names, file_paths, files);
      } else {
        print('---------------------operation cancelled---------------------');
      }
    } catch (e) {
      print('Error ------------------------ $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CloudDox'),
      ),
      backgroundColor: const Color.fromARGB(255, 25, 26, 31),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Color.fromARGB(255, 201, 99, 133),
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.folder_open)),
            label: 'My Files',
          ),
        ],
      ),
      body: HawkFabMenu(
        body: [dashboardView(), myFile()][currentPageIndex],
        icon: AnimatedIcons.menu_arrow,
        fabColor: Color(0xFF755EE8),
        iconColor: Colors.white,
        hawkFabMenuController: hawkFabMenuController,
        items: [
          HawkFabMenuItem(
              labelBackgroundColor: Colors.transparent,
              label: "Upload Files",
              ontap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                pickFiles();
              },
              icon: Icon(Icons.upload_file_outlined),
              color: Color.fromARGB(255, 201, 99, 133),
              labelColor: Colors.white),
          HawkFabMenuItem(
              labelBackgroundColor: Colors.transparent,
              label: "Scan Documents",
              ontap: () async {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();

                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                try {
                  final imagesPath = await CunningDocumentScanner.getPictures(
                    noOfPages: 1, // Limit the number of pages to 1
                    isGalleryImportAllowed:
                        true, // Allow the user to also pick an image from his gallery
                  );

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => uploadedPage(
                        imagesPath: imagesPath,
                      ),
                    ),
                  );
                } catch (e) {
                  print(e);
                }
              },
              icon: Icon(Icons.document_scanner_outlined),
              color: Color.fromARGB(255, 201, 99, 133),
              labelColor: Colors.white),
          HawkFabMenuItem(
              labelBackgroundColor: Colors.transparent,
              label: "Logout",
              ontap: () async {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.home),
              color: Color.fromARGB(255, 201, 99, 133),
              labelColor: Colors.white)
        ],
      ),
    );
  }
}
