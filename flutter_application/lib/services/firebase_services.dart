import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseServices {
  final _tripCollection = FirebaseFirestore.instance.collection('tripStories');
  final firebaseStorage = FirebaseStorage.instance;

  Future<void> uploadData(
      double long, double lat, String locationName, File imageFile) async {
    final imageReference = firebaseStorage
        .ref()
        .child("images")
        .child("${UniqueKey()}.jpg");
    final uploadTask = imageReference.putFile(
      imageFile,
    );

    await uploadTask.whenComplete(() async {
      final imageUrl = await imageReference.getDownloadURL();

      Map<String, dynamic> data = {
        'long': long,
        'lat': lat,
        'locationName': locationName,
        'imageUrl': imageUrl,
      };
      await _tripCollection.add(data);
    });
  }

  Stream<QuerySnapshot> getDatas() async* {
    yield* _tripCollection.snapshots();
  }
}
