import 'dart:io';

import 'package:flutter_application/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseController {
  final firebaseServices = FirebaseServices();

  Future<void> uploadData(
      double long, double lat, String locationName, File imageFile) async {
    firebaseServices.uploadData(long, lat, locationName, imageFile);
  }

  Stream<QuerySnapshot> getDatas() async* {
    yield* firebaseServices.getDatas();
  }
}
