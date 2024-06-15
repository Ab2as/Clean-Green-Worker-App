import 'package:clean_green_admin_and_worker/Controllers/AuthController.dart';
import 'package:clean_green_admin_and_worker/Controllers/ReportFetch.dart';
import 'package:clean_green_admin_and_worker/Models/ReportFetch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompletedScreen extends StatefulWidget {
  CompletedScreen({required this.category, super.key});

  String category;

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  final MyModelControllerR _controller = Get.put(MyModelControllerR());
  AuthController auth = Get.put(AuthController());

  TextEditingController _searchController = TextEditingController();
  SharedPreferences? _prefs;
  final FirebaseAuth auths = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    _controller.fetchAllModels();

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 220, 215, 215),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.black,
            ),
          ),
          title: const Text(
            'Completed Screen',
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 221, 216, 216),
          elevation: 0.0,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search by Id No.',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                onChanged: (value) {
                  _controller.filterModels(value);
                },
              ),
            ),
            Obx(
              () {
                if (_controller.fregis.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  FetchRegister? fetchRegister =
                      _controller.fregis.firstWhereOrNull(
                    (fetchRegister) =>
                        fetchRegister.completed == 'true' &&
                        fetchRegister.category == widget.category,
                  );

                  // Check if the model was found
                  if (fetchRegister == null) {
                    return const Center(
                        child: Text(
                            'No data available for the current user email'));
                  }
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: ListView.builder(
                          itemCount: _controller.fregis
                              .where(
                                (fetchRegister) =>
                                    // reg.email == dealerEmail &&
                                    fetchRegister.completed == 'true' &&
                                    fetchRegister.category == widget.category,
                              )
                              .length,
                          itemBuilder: (context, index) {
                            // FetchRegister regist =
                            //     _controller.filteredModels[index];
                            return InkWell(
                              onTap: () {
                                _showReportDetailsDialog(
                                    context, fetchRegister);
                              },
                              child: Card(
                                color: fetchRegister.completed == 'true'
                                    ? const Color.fromARGB(255, 123, 172, 124)
                                    : const Color.fromARGB(255, 215, 154, 150),
                                elevation: 3,
                                child: ListTile(
                                  leading: Text(
                                    fetchRegister.id,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  title: Text(
                                    fetchRegister.category,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  subtitle: Text(
                                    fetchRegister.description,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Ptserif',
                                      color: Colors.black,
                                    ),
                                  ),
                                  trailing: fetchRegister.completed == 'true'
                                      ? const Icon(
                                          Icons.done_all_rounded,
                                          color: Colors.greenAccent,
                                        )
                                      : const Icon(
                                          Icons.pending_actions_rounded,
                                          color: Colors.redAccent,
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showReportDetailsDialog(
      BuildContext context, FetchRegister fetchRegister) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Report Details',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: ${fetchRegister.name}',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                'Address: ${fetchRegister.address}',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                'State: ${fetchRegister.state}',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                'City: ${fetchRegister.city}',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                'Pincode: ${fetchRegister.pincode}',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                'Register Date: ${fetchRegister.date}',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                'Designation: ${fetchRegister.category}',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                'Description: ${fetchRegister.description}',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                'Mobile Number: ${fetchRegister.mobileNumber}',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                'Email: ${fetchRegister.email}',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                'Close',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        );
      },
    );
  }
}
