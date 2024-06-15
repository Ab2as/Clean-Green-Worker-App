import 'dart:io';

import 'package:clean_green_admin_and_worker/Controllers/AuthController.dart';
import 'package:clean_green_admin_and_worker/Controllers/FetchWorker.dart';
import 'package:clean_green_admin_and_worker/Models/FetchWorker.dart';
import 'package:clean_green_admin_and_worker/Screens/Worker/HomeScreenWorker.dart';
import 'package:clean_green_admin_and_worker/Widgets/ElevatedButtonModel.dart';
import 'package:clean_green_admin_and_worker/Widgets/ImagePicker.dart';
import 'package:clean_green_admin_and_worker/Widgets/TextFieldModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // string for displaying the error Message
  String? errorMessage;
  final AuthController auth = Get.put(AuthController());
  final MyModelController1 controller = Get.put(MyModelController1());
  final String requiredEmail =
      'qwert@zxc.com'; // Replace with the required email
  String uidD = '';
  String designation = '';
  String organization = '';

  final FirebaseAuth auths = FirebaseAuth.instance;
  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final userNameEditingController = new TextEditingController();
  final shopAddressEditingController = new TextEditingController();
  final cityEditingController = new TextEditingController();
  final stateEditingController = new TextEditingController();
  final pincodeEditingController = new TextEditingController();
  final mobileNumberEditingController = new TextEditingController();

  // AuthController authController = Get.put(AuthController());
  File? image;

  pickImage(ImageSource source) {
    AppImagePicker(source: source).pick(onPick: (File? img) {
      setState(() {
        this.image = img;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    controller.fetchAllModels();

    User? currentUser = auths.currentUser;
    String dealerEmail = currentUser?.email ?? '';

    Future<String?> getDocumentIdBySerial(String email) async {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('WorkerProfile')
          .where('email', isEqualTo: dealerEmail)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.id;
      }
      return null;
    }
    //name,add,city,state,pin,photo

    return SafeArea(
      child: Scaffold(
        body: Obx(
          () {
            if (controller.fworker.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              WorkerFetch? fetchWorker = controller.fworker.firstWhereOrNull(
                (fetchWorker) => fetchWorker.email == dealerEmail,
              );

              // Check if the model was found
              if (fetchWorker == null) {
                return const Center(
                    child:
                        Text('No data available for the current user email'));
              }
              // uidD = model.uid;
              uidD = fetchWorker.uid;
              designation = fetchWorker.designation;
              organization = fetchWorker.organization;
            }

            return Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.grey, Colors.white],
                    begin: Alignment.centerLeft,
                    end: Alignment.bottomRight),
              ),
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: const Icon(Icons.arrow_back),
                              iconSize: 30.0,
                            )),

                        Stack(
                          children: [
                            image != null
                                ? CircleAvatar(
                                    radius: 65,
                                    backgroundImage: FileImage(image!))
                                : const CircleAvatar(
                                    radius: 65,
                                    backgroundImage: NetworkImage(
                                        'https://as1.ftcdn.net/v2/jpg/03/46/83/96/1000_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg'),
                                  ),
                            Positioned(
                              bottom: -10,
                              left: 80,
                              child: IconButton(
                                onPressed: () {
                                  pickImage(ImageSource.camera);
                                },
                                icon: const Icon(Icons.add_a_photo),
                              ),
                            ),
                          ],
                        ),
                        // firstNameField,
                        const SizedBox(height: 20),
                        MyTextFormField(
                          myController: userNameEditingController,
                          fieldName: "Name",
                          myIcon: Icons.person_2_rounded,
                          iconColor: Colors.black,
                          keyboard: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter the Name";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            userNameEditingController.text = value!;
                          },
                          errorMessage: "Enter the Name",
                          obscureText: false,
                        ),
                        const SizedBox(height: 20),
                        MyTextFormField(
                          myController: shopAddressEditingController,
                          fieldName: "Shop Address",
                          myIcon: Icons.business,
                          iconColor: Colors.black,
                          keyboard: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter the Shop Address";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            shopAddressEditingController.text = value!;
                          },
                          errorMessage: "Enter the Shop Address",
                          obscureText: false,
                        ),
                        const SizedBox(height: 20),
                        MyTextFormField(
                          myController: cityEditingController,
                          fieldName: "City",
                          myIcon: Icons.place,
                          iconColor: Colors.black,
                          keyboard: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter the City";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            cityEditingController.text = value!;
                          },
                          errorMessage: "Enter the City",
                          obscureText: false,
                        ),
                        const SizedBox(height: 20),
                        MyTextFormField(
                          myController: stateEditingController,
                          fieldName: "State",
                          myIcon: Icons.place,
                          iconColor: Colors.black,
                          keyboard: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter the State";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            stateEditingController.text = value!;
                          },
                          errorMessage: "Enter the State",
                          obscureText: false,
                        ),
                        const SizedBox(height: 20),
                        MyTextFormField(
                          myController: pincodeEditingController,
                          fieldName: "Pincode",
                          myIcon: Icons.pin,
                          iconColor: Colors.black,
                          keyboard: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter the Pincode";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            pincodeEditingController.text = value!;
                          },
                          errorMessage: "Enter the Pincode",
                          obscureText: false,
                        ),
                        const SizedBox(height: 20),
                        MyTextFormField(
                          myController: mobileNumberEditingController,
                          fieldName: "Mobile Number",
                          myIcon: Icons.pin,
                          iconColor: Colors.black,
                          keyboard: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return (errorMessage);
                            }
                            if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
                                .hasMatch(value)) {
                              return ("Enter the Valid Mobile Number)");
                            }
                            return null;
                          },
                          onSaved: (value) {
                            pincodeEditingController.text = value!;
                          },
                          errorMessage: "Enter the Mobile Number",
                          obscureText: false,
                        ),
                        const SizedBox(height: 20),
                        MyTextFormField(
                          myController: mobileNumberEditingController,
                          fieldName: "Mobile Number",
                          myIcon: Icons.pin,
                          iconColor: Colors.black,
                          keyboard: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return (errorMessage);
                            }
                            if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
                                .hasMatch(value)) {
                              return ("Enter the Valid Mobile Number)");
                            }
                            return null;
                          },
                          onSaved: (value) {
                            pincodeEditingController.text = value!;
                          },
                          errorMessage: "Enter the Mobile Number",
                          obscureText: false,
                        ),
                        const SizedBox(height: 20),
                        MyButton(
                            family: 'Roboto',
                            size: 20.0,
                            message: "Edit Profile",
                            col1: const Color.fromARGB(255, 104, 103, 91),
                            col2: const Color.fromARGB(255, 0, 0, 0),
                            col3: const Color.fromARGB(255, 230, 220, 220),
                            col4: Colors.grey,
                            onPressed: () async {
                              String? documentId =
                                  await getDocumentIdBySerial(dealerEmail);
                              if (documentId != null) {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();

                                  if (userNameEditingController
                                          .text.isNotEmpty &&
                                      requiredEmail.isNotEmpty &&
                                      image != null &&
                                      stateEditingController.text.isNotEmpty &&
                                      cityEditingController.text.isNotEmpty &&
                                      shopAddressEditingController
                                          .text.isNotEmpty &&
                                      pincodeEditingController
                                          .text.isNotEmpty) {
                                    bool isUpdated =
                                        await auth.UpdateRegisterWorker(
                                            documentId,
                                            userNameEditingController.text,
                                            dealerEmail,
                                            image,
                                            stateEditingController.text,
                                            cityEditingController.text,
                                            shopAddressEditingController.text,
                                            pincodeEditingController.text,
                                            mobileNumberEditingController.text,
                                            designation,
                                            organization,
                                            uidD);
                                    if (isUpdated) {
                                      Get.to(() => HomeScreenWorker());
                                    } else {
                                      Get.snackbar(
                                          "Error", "Failed to update profile",
                                          snackPosition: SnackPosition.BOTTOM);
                                    }
                                  } else {
                                    Get.snackbar("Error",
                                        "Please fill all fields and select an image",
                                        snackPosition: SnackPosition.BOTTOM);
                                  }
                                }
                              } else {
                                Get.snackbar("Error", "Document not found",
                                    snackPosition: SnackPosition.BOTTOM);
                              }
                            }),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
