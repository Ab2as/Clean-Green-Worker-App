import 'package:clean_green_admin_and_worker/Models/FetchWorker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class MyModelController1 extends GetxController {
  var fworker = <WorkerFetch>[].obs;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var filteredModels = <WorkerFetch>[].obs; // New list for filtered models

  Future<void> fetchAllModels() async {
    try {
      QuerySnapshot query = await _db.collection('WorkerProfile').get();
      fworker.value = query.docs.map((doc) {
        WorkerFetch fetchWorker = WorkerFetch.fromFirestore(doc);
        return fetchWorker;
      }).toList();
      filteredModels.value = List.from(fworker);
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void filterModels(String query) {
    filteredModels.value = fworker.where((fetchWorker) {
      // Case-insensitive search by dealer name
      return fetchWorker.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
