import 'package:clean_green_admin_and_worker/Controllers/AuthController.dart';
import 'package:clean_green_admin_and_worker/Controllers/ReportFetch.dart';
import 'package:clean_green_admin_and_worker/Models/ReportFetch.dart';
import 'package:clean_green_admin_and_worker/Screens/Worker/WorkDone.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendingScreen extends StatefulWidget {
  PendingScreen({required this.category, super.key});

  String category;

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
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
            'Pending Screen',
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
                        fetchRegister.completed == 'false' &&
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
                                    // reg.email == dealerEmail
                                    //  &&
                                    fetchRegister.completed == 'false' &&
                                    fetchRegister.category == widget.category,
                              )
                              .length,
                          // _controller.filteredModels.length,
                          itemBuilder: (context, index) {
                            // FetchRegister regist =
                            //     _controller.filteredModels[index];
                            return InkWell(
                              onTap: () {
                                // _showReportDetailsDialog(context, regist);
                                _navigateToNextPage(context, fetchRegister.id);
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

  void _navigateToNextPage(BuildContext context, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              WorkDoneScreen(id: id)), // Pass the model name to the next page
    );
  }
}
