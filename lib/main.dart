import 'dart:io';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/provider/file_details_provider.dart';
import 'package:todo/provider/imageUpload.dart';
import 'package:todo/screens/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:animated_stack/animated_stack.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerStatefulWidget {
  MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasker',
      home: AnimatedStack(
        backgroundColor: Color.fromARGB(255, 153, 139, 168),
        fabBackgroundColor: Color.fromARGB(255, 209, 165, 20),
        foregroundWidget: HomePage(),
        columnWidget: Column(
          children: <Widget>[
            IconButton.filledTonal(
              icon: Icon(Icons.upload_file_outlined),
              onPressed: () {
                pickFiles();
              },
            ),
            SizedBox(height: 20),
            IconButton.filledTonal(
              icon: Icon(Icons.scanner),
              onPressed: () async {
                try {
                  final imagesPath = await CunningDocumentScanner.getPictures(
                    noOfPages: 1, // Limit the number of pages to 1
                    isGalleryImportAllowed:
                        true, // Allow the user to also pick an image from his gallery
                  );
                  final filePathProvider = ref.read(imageUploaderProvider.notifier);
                  filePathProvider.addData(imagesPath);
                  
                  
                } catch (e) {
                  print(e);
                }
              },
            ),
            SizedBox(height: 20),
            IconButton.filledTonal(
              icon: Icon(Icons.logout_outlined),
              onPressed: () {},
            ),
          ],
        ),
        bottomWidget: Container(
          decoration: BoxDecoration(
            color: Color(0xff645478),
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
          ),
          width: 260,
          height: 50,
          child: OutlinedButton(
            child: Text('Log Out'),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ),
      ),
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.grey, brightness: Brightness.dark),
          textTheme: TextTheme(
            displayLarge: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
            ),
            titleLarge: GoogleFonts.oswald(
              fontSize: 30,
              fontStyle: FontStyle.italic,
            ),
            bodyMedium: GoogleFonts.merriweather(),
            displaySmall: GoogleFonts.pacifico(),
          )),
    );
  }
}
