import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/controllers/firebase_controller.dart';
import 'package:flutter_application/model/trip.dart';
import 'package:flutter_application/services/location_service.dart';
import 'package:flutter_application/views/widgets/add_story.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void reload() {
    setState(() {});
  }

  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await LocationService.getCurrentLocation();
      setState(() {});
    });
  }

  // void watchMyLocation() {
  //   LocationService.getLiveLocation().listen((location) {
  //     print("Live location: $location");
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    final firebaseController = FirebaseController();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Trip stories",
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 22, color: Colors.black),
        ),
      ),
      body: StreamBuilder(
        stream: firebaseController.getDatas(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error occurred'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No trips yet'),
            );
          }

          List<Trip> data = snapshot.data.docs.map<Trip>((doc) {
            return Trip.fromQuerySnapshot(doc);
          }).toList();
          return Column(
            children: [
              Expanded(
                  child: GridView.builder(
                      itemCount: data.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10),
                      itemBuilder: (context, index) {
                        return Container(
                          clipBehavior: Clip.hardEdge,
                          width: 200,
                          height: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  image: FadeInImage.memoryNetwork(
                                          image: data[index].imageUrl,
                                          placeholder: kTransparentImage)
                                      .image,
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.low)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        color: Colors.red),
                                    Text(
                                      data[index].locationName.length >= 10
                                          // ignore: prefer_interpolation_to_compose_strings
                                          ? " " +
                                              data[index]
                                                  .locationName
                                                  .substring(0, 10) +
                                              '..'
                                          : " " + data[index].locationName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 22,
                                          color: Colors.white),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }))
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AddStory(
                reload: reload,
              );
            },
          );
        },
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}
