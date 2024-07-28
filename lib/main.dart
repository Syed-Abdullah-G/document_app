import 'package:flutter/material.dart';
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
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasker',
      home: AnimatedStack(
        backgroundColor: Color(0xff321B4A),
        fabBackgroundColor: Color(0xff321B4A),
        foregroundWidget: HomePage(),
        columnWidget: Column(
          children: <Widget>[
            IconButton.filledTonal(
              icon: Icon(Icons.upload_file_outlined),
              onPressed: () {},
            ),
            SizedBox(height: 20),
            IconButton.filledTonal(
              icon: Icon(Icons.scanner),
              onPressed: () {},
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
