import 'package:cloud_firestore/cloud_firestore.dart';

class WorkerFetch {
  String name;
  String profilePhoto;
  String email;
  String uid;
  String address;
  String state;
  String city;
  String pincode;
  String mobileNumber;
  String designation;
  String organization;

  WorkerFetch({
    required this.name,
    required this.email,
    required this.profilePhoto,
    required this.address,
    required this.state,
    required this.city,
    required this.pincode,
    required this.uid,
    required this.mobileNumber,
    required this.designation,
    required this.organization,
  });

  factory WorkerFetch.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return WorkerFetch(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profilePhoto: data['profilePhoto'] ?? '',
      address: data['address'] ?? '',
      state: data['state'] ?? '',
      city: data['city'] ?? '',
      pincode: data['pincode'] ?? '',
      mobileNumber: data['mobileNumber'] ?? '',
      designation: data['designation'] ?? '',
      organization: data['organization'] ?? '',
      uid: data['uid'] ?? '',
    );
  }
}
