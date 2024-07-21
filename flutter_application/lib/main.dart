import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/firebase_options.dart';
import 'package:flutter_application/views/screens/home_screen.dart';
import 'package:permission_handler/permission_handler.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  PermissionStatus cameraPermission = await Permission.camera.status;
  PermissionStatus locationPermission = await Permission.location.status;

  if (cameraPermission != PermissionStatus.granted) {
    cameraPermission = await Permission.camera.request();
  }

  if (locationPermission != PermissionStatus.granted) {
    locationPermission = await Permission.location.request();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
