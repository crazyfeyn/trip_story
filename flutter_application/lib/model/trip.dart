import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  String locationName;
  double long;
  double lat;
  String imageUrl;

  Trip(
      {required this.locationName,
      required this.long,
      required this.lat,
      required this.imageUrl});

  factory Trip.fromQuerySnapshot(QueryDocumentSnapshot query) {
    return Trip(
        locationName: query['locationName'],
        long: query['long'],
        lat: query['lat'],
        imageUrl: query['imageUrl']);
  }
}
