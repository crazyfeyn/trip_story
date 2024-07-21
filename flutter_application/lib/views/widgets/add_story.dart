import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application/controllers/firebase_controller.dart';
import 'package:flutter_application/services/firebase_services.dart';
import 'package:flutter_application/services/location_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AddStory extends StatefulWidget {
  Function reload;

  AddStory({required this.reload, super.key});

  @override
  State<AddStory> createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory> {
  final firebaseController = FirebaseController();
  final _formkey = GlobalKey<FormState>();
  final textcontroller = TextEditingController();
  File? imageFile;
  LocationData? currenctLocation;

  void submit(BuildContext context) {
    if (_formkey.currentState!.validate()) {
      firebaseController.uploadData(currenctLocation!.longitude!,
          currenctLocation!.latitude!, textcontroller.text, imageFile!);
      _formkey.currentState!.save();
      textcontroller.clear();
      imageFile = null;
      widget.reload();
      Navigator.pop(context);
    }
  }

  void openGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      requestFullMetadata: false,
    );
    if (pickedImage != null) {
      setState(
        () {
          imageFile = File(pickedImage.path);
        },
      );
    }
  }

  void openCamera() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Trip'),
      content: Form(
        key: _formkey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: textcontroller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some information!';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Input place',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 10),
            currenctLocation == null
                ? Text('location is not selected')
                : Column(
                    children: [
                      Text("lat: ${currenctLocation!.latitude.toString()}"),
                      Text("lang ${currenctLocation!.longitude.toString()}"),
                    ],
                  ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await LocationService.getCurrentLocation();
                setState(() {
                  currenctLocation = LocationService.currentLocation;
                });
              },
              child: const Text("Get locations"),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: openCamera,
                  icon: const Icon(Icons.camera),
                  label: const Text("Camera"),
                ),
                TextButton.icon(
                  onPressed: openGallery,
                  icon: const Icon(Icons.image),
                  label: const Text("Gallery"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (imageFile != null)
              Container(
                width: 250,
                height: 150,
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Image.file(
                  imageFile!,
                  fit: BoxFit.cover,
                ),
              )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              textcontroller.clear();
              imageFile = null;
            });
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => submit(context),
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
