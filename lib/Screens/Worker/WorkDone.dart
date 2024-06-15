import 'dart:io';

import 'package:clean_green_admin_and_worker/Controllers/AuthController.dart';
import 'package:clean_green_admin_and_worker/Controllers/FetchWorker.dart';
import 'package:clean_green_admin_and_worker/Controllers/ReportFetch.dart';
import 'package:clean_green_admin_and_worker/Models/FetchWorker.dart';
import 'package:clean_green_admin_and_worker/Models/ReportFetch.dart';
import 'package:clean_green_admin_and_worker/Screens/Worker/HomeScreenWorker.dart';
import 'package:clean_green_admin_and_worker/Widgets/Details.dart';
import 'package:clean_green_admin_and_worker/Widgets/ElevatedButtonModel.dart';
import 'package:clean_green_admin_and_worker/Widgets/ImagePicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class WorkDoneScreen extends StatefulWidget {
  WorkDoneScreen({required this.id, super.key});

  String id;

  @override
  State<WorkDoneScreen> createState() => _WorkDoneScreenState();
}

class _WorkDoneScreenState extends State<WorkDoneScreen> {
  FirebaseStorage storage = FirebaseStorage.instance;

  final MyModelControllerR _controller = Get.put(MyModelControllerR());
  final MyModelController1 _controllerW = Get.put(MyModelController1());
  AuthController auth = Get.put(AuthController());

  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  File? image;

  pickImage(ImageSource source) {
    AppImagePicker(source: source).pick(onPick: (File? image) {
      setState(() {
        this.image = image;
      });
    });
  }

  Future<String?> getDocumentIdBySerial(String id) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('RegisterProblem')
        .where('id', isEqualTo: id)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    }
    return null;
  }

  final FirebaseAuth auths = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    _controllerW.fetchAllModels();
    _controller.fetchAllModels();

    User? currentUser = auths.currentUser;
    String dealerEmail = currentUser?.email ?? '';

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 220, 215, 215),
        appBar: AppBar(
          title: const Text(
            "Submit Work",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: const Color.fromARGB(255, 220, 215, 215),
        ),
        body: Obx(() {
          if (_controller.fregis.isEmpty || _controllerW.fworker.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            FetchRegister? fetchRegister = _controller.fregis.firstWhereOrNull(
              (fetchRegister) => fetchRegister.id == widget.id,
              //  &&
              // FetchRegister.email == dealerEmail,
            );

            // Check if the model was found
            if (fetchRegister == null) {
              return const Center(
                  child: Text('No data available for the current user email'));
            }

            WorkerFetch? fetchWorker = _controllerW.fworker.firstWhereOrNull(
              (fetchWorker) => fetchWorker.email == dealerEmail,
            );

            // Check if the model was found
            if (fetchWorker == null) {
              return const Center(
                  child: Text('No data available for the current user email'));
            }

            List<Map<String, String>> details = [
              {"title": "Name: ", "content": fetchRegister.name},
              {"title": "Category: ", "content": fetchRegister.category},
              {"title": "Date: ", "content": fetchRegister.date},
              {"title": "Description: ", "content": fetchRegister.description},
              {"title": "Address: ", "content": fetchRegister.problemAddress},
            ];
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Custom3DCard(details: details),
                  ),
                  image != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 300,
                            width: 400,
                            decoration:
                                BoxDecoration(border: Border.all(width: 1.5)),
                            child: Image.file(
                              image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : const Text(
                          "No Image Selected",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     String message;

                  //     try {
                  //       Reference ref =
                  //           FirebaseStorage.instance.ref().child("SubmitImage");
                  //       UploadTask uploadTask = ref.putFile(image!);

                  //       TaskSnapshot taskSnapshot = await Future.value(uploadTask);
                  //       var newUrl = await taskSnapshot.ref.getDownloadURL();

                  //       print("Uploaded");
                  //       final collection =
                  //           FirebaseFirestore.instance.collection('submitImage');

                  //       await collection.doc().set({'image': newUrl.toString()});
                  //       message = "Successful";
                  //       print("ahlf");
                  //     } catch (_) {
                  //       message = "Error";
                  //     }
                  //     if (message == "Successful") {
                  //       Navigator.of(context).pop();
                  //     }
                  //   },
                  //   style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  //   child: const Text(
                  //     "Submit",
                  //     style: TextStyle(
                  //         fontSize: 20,
                  //         fontWeight: FontWeight.w400,
                  //         color: Colors.black),
                  //   ),
                  // ),

                  MyButton(
                      family: 'Roboto',
                      size: 20.0,
                      message: 'Submit',
                      onPressed: () async {
                        String? documentId =
                            await getDocumentIdBySerial(widget.id);
                        if (documentId != null) {
                          print("D1");
                          bool isDone = await auth.ProblemWorkdone(
                              widget.id,
                              fetchRegister.problemAddress,
                              currentDate,
                              'true',
                              fetchRegister.category,
                              fetchRegister.description,
                              fetchWorker.name,
                              image,
                              fetchWorker.email,
                              fetchRegister.problemAddress,
                              fetchWorker.state,
                              fetchWorker.city,
                              fetchWorker.pincode,
                              fetchWorker.mobileNumber);
                          print("D2");

                          bool isUpdate = await auth.UpdateRegisterProblem(
                              documentId,
                              fetchRegister.name,
                              fetchRegister.email,
                              fetchRegister.problemPhoto,
                              fetchRegister.state,
                              fetchRegister.city,
                              fetchRegister.address,
                              fetchRegister.pincode,
                              fetchRegister.mobileNumber,
                              fetchRegister.id,
                              fetchRegister.problemAddress,
                              fetchRegister.date,
                              'true',
                              fetchRegister.category,
                              fetchRegister.description);
                          print("D3");
                          if (isUpdate && isDone) {
                            Get.to(HomeScreenWorker());
                          } else {
                            Get.snackbar("Error", "Failed to update profile",
                                snackPosition: SnackPosition.BOTTOM);
                          }
                        } else {
                          Get.snackbar("Error", "Document not found",
                              snackPosition: SnackPosition.BOTTOM);
                        }
                      },
                      col1: Colors.grey,
                      col2: Colors.white,
                      col3: Colors.grey,
                      col4: Colors.grey),
                ],
              ),
            );
          }
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey,
          onPressed: () {
            pickImage(ImageSource.camera);
          },
          child: const Icon(
            Icons.add,
            color: Color.fromARGB(255, 25, 25, 25),
          ),
        ),
      ),
    );
  }
}
