import 'dart:io';

import 'package:clean_green_admin_and_worker/Controllers/AuthController.dart';
import 'package:clean_green_admin_and_worker/Screens/SplashScreen.dart';
import 'package:clean_green_admin_and_worker/Screens/Worker/HomeScreenWorker.dart';
import 'package:clean_green_admin_and_worker/Widgets/ElevatedButtonModel.dart';
import 'package:clean_green_admin_and_worker/Widgets/ImagePicker.dart';
import 'package:clean_green_admin_and_worker/Widgets/TextFieldModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // string for displaying the error Message
  String? errorMessage;

  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final userNameEditingController = new TextEditingController();
  final addressEditingController = new TextEditingController();
  final cityEditingController = new TextEditingController();
  final stateEditingController = new TextEditingController();
  final pincodeEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final mobileEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();
  final designationEditingController = new TextEditingController();
  final organizationEditingController = new TextEditingController();

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = const [
      DropdownMenuItem(
          child: Text("Yellow Spot (Public Urination Spot)"),
          value: "Yellow Spot (Public Urination Spot)"),
      DropdownMenuItem(
          child: Text("Overflow of Sewerage or Storm Water"),
          value: "Overflow of Sewerage or Storm Water"),
      DropdownMenuItem(child: Text("Dead Animal(s)"), value: "Dead Animal(s)"),
      DropdownMenuItem(
          child: Text("Dustbins Not Cleaned"), value: "Dustbins Not Cleaned"),
      DropdownMenuItem(
          child: Text("Open Manholes Or Drains"),
          value: "Open Manholes Or Drains"),
      DropdownMenuItem(
          child: Text("Sweeping not done"), value: "Sweeping not done"),
      DropdownMenuItem(
          child: Text("Electricity Problem"), value: "Electricity Problem"),
      DropdownMenuItem(
          child: Text("No water supply"), value: "No water supply"),
      DropdownMenuItem(
          child: Text("Stagnant Water On The Road"),
          value: "Stagnant Water On The Road"),
      DropdownMenuItem(
          child: Text("Improper Disposal of Fecal Waste/Septage"),
          value: "Improper Disposal of Fecal Waste/Septage"),
      DropdownMenuItem(
          child: Text("Burning of Garbage in Open Space"),
          value: "Burning of Garbage in Open Space"),
      DropdownMenuItem(
          child: Text("Debris Removal/Construction Material"),
          value: "Debris Removal/Construction Material"),
    ];

    return menuItems;
  }

  String? selectedValue = null;

  AuthController authController = Get.put(AuthController());
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
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 232, 241, 250), Colors.grey],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 30,
                              color: Colors.black,
                            )),
                        const Expanded(
                          child: Text(
                            'SignUp',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
                        image != null
                            ? CircleAvatar(
                                radius: 65, backgroundImage: FileImage(image!))
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
                      myController: addressEditingController,
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
                        addressEditingController.text = value!;
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
                    // MyTextFormField(
                    //   myController: designationEditingController,
                    //   fieldName: "Designation",
                    //   myIcon: Icons.description_rounded,
                    //   iconColor: Colors.black,
                    //   keyboard: TextInputType.name,
                    //   validator: (value) {
                    //     if (value!.isEmpty) {
                    //       return (errorMessage);
                    //     }
                    //   },
                    //   onSaved: (value) {
                    //     designationEditingController.text = value!;
                    //   },
                    //   errorMessage: "Enter the Designation",
                    //   obscureText: false,
                    // ),
                    DropdownButtonFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.battery_0_bar_rounded,
                            color: Colors.black,
                          ),
                          labelText: "Select Category",
                          labelStyle:
                              TextStyle(color: Colors.white.withOpacity(0.9)),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.3),
                        ),
                        validator: (value) =>
                            value == null ? "Select a Category" : null,
                        dropdownColor: Colors.white.withOpacity(0.7),
                        value: selectedValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue!;
                          });
                        },
                        items: dropdownItems),
                    const SizedBox(height: 20),
                    MyTextFormField(
                      myController: organizationEditingController,
                      fieldName: "Organization",
                      myIcon: Icons.business_center_rounded,
                      iconColor: Colors.black,
                      keyboard: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter the Organization";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        organizationEditingController.text = value!;
                      },
                      errorMessage: "Enter the Organization",
                      obscureText: false,
                    ),
                    const SizedBox(height: 20),
                    MyTextFormField(
                      myController: mobileEditingController,
                      fieldName: "Mobile Number",
                      myIcon: Icons.mobile_friendly_rounded,
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
                      myController: emailEditingController,
                      fieldName: "Email",
                      myIcon: Icons.email_rounded,
                      iconColor: Colors.black,
                      keyboard: TextInputType.emailAddress,
                      errorMessage: "Please enter a correct Email",
                      obscureText: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return (errorMessage);
                        }
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return ("Please Enter a valid email");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        emailEditingController.text = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    MyTextFormField(
                      myController: passwordEditingController,
                      fieldName: "Password",
                      myIcon: Icons.key_rounded,
                      iconColor: Colors.black,
                      keyboard: TextInputType.emailAddress,
                      errorMessage: "Password is required for login",
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return (errorMessage);
                        }
                        if (!RegExp(r'^.{6,}$').hasMatch(value)) {
                          return ("Enter Valid Password(Min. 6 Character)");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        passwordEditingController.text = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    MyTextFormField(
                        myController: confirmPasswordEditingController,
                        fieldName: "Confirm Password",
                        myIcon: Icons.key_rounded,
                        iconColor: Colors.black,
                        keyboard: TextInputType.visiblePassword,
                        validator: (value) {
                          if (confirmPasswordEditingController.text !=
                              passwordEditingController.text) {
                            return "Password don't match";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          confirmPasswordEditingController.text = value!;
                        },
                        errorMessage: "Enter the Password",
                        obscureText: true),
                    const SizedBox(height: 20),
                    MyButton(
                        col3: Colors.grey,
                        col4: Colors.grey,
                        family: 'Roboto',
                        size: 20.0,
                        message: "SignUp",
                        col1: Colors.black,
                        col2: Colors.white,
                        onPressed: () async {
                          bool isregistered =
                              await authController.registerWorker(
                                  userNameEditingController.text,
                                  emailEditingController.text,
                                  passwordEditingController.text,
                                  image,
                                  stateEditingController.text,
                                  cityEditingController.text,
                                  addressEditingController.text,
                                  pincodeEditingController.text,
                                  mobileEditingController.text,
                                  designationEditingController.text,
                                  organizationEditingController.text);
                          if (isregistered) {
                            var sharedPref =
                                await SharedPreferences.getInstance();
                            sharedPref.setBool(
                                SplashScreenState.KEYLOGIN, true);
                            Get.to(() => HomeScreenWorker());
                          } else {
                            Get.snackbar("Error", "Failed to Upload Profile",
                                snackPosition: SnackPosition.BOTTOM);
                          }
                        }),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
