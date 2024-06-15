import 'package:cloud_firestore/cloud_firestore.dart';

class Worker {
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

  Worker({
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

  Map<String, dynamic> toJson() => {
        "name": name,
        "profilePhoto": profilePhoto,
        "email": email,
        "uid": uid,
        "state": state,
        "city": city,
        "address": address,
        "pincode": pincode,
        "mobileNumber": mobileNumber,
        "designation": designation,
        "organization": organization,
      };

  static Worker fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Worker(
      name: snapshot['name'],
      email: snapshot['email'],
      profilePhoto: snapshot['profilePhoto'],
      uid: snapshot['uid'],
      address: snapshot['address'],
      state: snapshot['state'],
      city: snapshot['city'],
      pincode: snapshot['pincode'],
      mobileNumber: snapshot['mobileNumber'],
      designation: snapshot['designation'],
      organization: snapshot['organization'],
    );
  }
}
