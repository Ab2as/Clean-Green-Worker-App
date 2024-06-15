import 'package:cloud_firestore/cloud_firestore.dart';

class Workdone {
  String id;
  String problemAddress;
  String date;
  String completed;
  String category;
  String description;
  String name;
  String problemPhoto;
  String email;
  String address;
  String state;
  String city;
  String pincode;
  String mobileNumber;

  Workdone({
    required this.id,
    required this.problemAddress,
    required this.date,
    required this.completed,
    required this.category,
    required this.description,
    required this.name,
    required this.email,
    required this.problemPhoto,
    required this.address,
    required this.state,
    required this.city,
    required this.pincode,
    required this.mobileNumber,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "problemAddress": problemAddress,
        "date": date,
        "completed": completed,
        "category": category,
        "description": description,
        "name": name,
        "problemPhoto": problemPhoto,
        "email": email,
        "state": state,
        "city": city,
        "address": address,
        "pincode": pincode,
        "mobileNumber": mobileNumber,
      };

  static Workdone fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Workdone(
      id: snapshot['id'],
      problemAddress: snapshot['problemAddress'],
      date: snapshot['date'],
      completed: snapshot['completed'],
      category: snapshot['category'],
      description: snapshot['description'],
      name: snapshot['name'],
      email: snapshot['email'],
      problemPhoto: snapshot['problemPhoto'],
      address: snapshot['address'],
      state: snapshot['state'],
      city: snapshot['city'],
      pincode: snapshot['pincode'],
      mobileNumber: snapshot['mobileNumber'],
    );
  }
}
