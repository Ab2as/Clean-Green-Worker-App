import 'package:clean_green_admin_and_worker/Controllers/AuthController.dart';
import 'package:clean_green_admin_and_worker/Controllers/FetchWorker.dart';
import 'package:clean_green_admin_and_worker/Models/FetchWorker.dart';
import 'package:clean_green_admin_and_worker/Screens/Worker/CompletedScree.dart';
import 'package:clean_green_admin_and_worker/Screens/Worker/PendingScree.dart';
import 'package:clean_green_admin_and_worker/Screens/Worker/ProfileScreen.dart';
import 'package:clean_green_admin_and_worker/Widgets/Card3D.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreenWorker extends StatelessWidget {
  final AuthController auth = Get.put(AuthController());
  final MyModelController1 controller = Get.put(MyModelController1());

  final FirebaseAuth auths = FirebaseAuth.instance;
  String reqEmail = 'abbasfg@gmail.com';

  @override
  Widget build(BuildContext context) {
    controller.fetchAllModels();

    User? currentUser = auths.currentUser;
    String dealerEmail = currentUser?.email ?? '';

    return SafeArea(
      child: Scaffold(
        body: Obx(() {
          if (controller.fworker.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            WorkerFetch? fetchWorker = controller.fworker.firstWhereOrNull(
              (fetchWorker) => fetchWorker.email == dealerEmail,
            );

            // Check if the model was found
            if (fetchWorker == null) {
              return const Center(
                  child: Text('No data available for the current user email'));
            }

            return Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.grey, Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(ProfileScreen());
                            },
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  NetworkImage('${fetchWorker.profilePhoto}'),
                            ),
                          ),
                          const Expanded(
                            child: Text(
                              'Clean & Green',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 35,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "  Welcome",
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PlayFair'),
                          ),
                          Text(
                            '     ${fetchWorker.name}',
                            style: const TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PlayFair'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "  How we can help?",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PlayFair'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: SizedBox(
                        height: 240,
                        width: 190,
                        child: ThreeDCard(
                            imageUrl:
                                'https://img.freepik.com/free-vector/work-time-concept-illustration_114360-1074.jpg?t=st=1718385617~exp=1718389217~hmac=089e6195eb5c81cdd4409d214efa480342d6df5d5410701b83d0878090fa5c61&w=740',
                            text: "Pending",
                            onPressed: () {
                              Get.to(() => PendingScreen(
                                    category: fetchWorker.designation,
                                  ));
                            }),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        height: 240,
                        width: 190,
                        child: ThreeDCard(
                            imageUrl:
                                'https://img.freepik.com/free-vector/completed-concept-illustration_114360-3891.jpg?t=st=1718386725~exp=1718390325~hmac=bc9d8044464ad5d711a38584270b95dc70eacce94cdc89abf0132fd24f180c5c&w=740',
                            text: "Completed",
                            onPressed: () {
                              Get.to(() => CompletedScreen(
                                    category: fetchWorker.designation,
                                  ));
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
