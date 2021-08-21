import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class AppUserModel {
  final String? id;
  final String? userName;
  final String? firstName;
  final String? lastName;
  final String? phoneNo;
  final String? password;
  final String? timestamp;
  final bool? isAdmin;
  final String? email;
  final bool? isTeacher;
  final String? photoUrl;
  final String? rollNo;
  final String? grades;
  // final Map? sectionsAppointed;
  AppUserModel(
      {this.id,
      this.userName,
      this.firstName,
      this.lastName,
      this.phoneNo,
      this.password,
      this.timestamp,
      this.isAdmin,
      this.email,
      this.isTeacher,
      this.photoUrl,
      this.rollNo,
      this.grades});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'lastName': lastName,
      'phoneNo': phoneNo,
      'password': password,
      'timestamp': timestamp,
      'isAdmin': isAdmin,
      'email': email,
      'isTeacher': isTeacher,
      'photoUrl': photoUrl,
      'rollNo': rollNo,
      'grades': grades,
    };
  }

  factory AppUserModel.fromMap(Map<String, dynamic> map) {
    return AppUserModel(
      id: map['id'],
      userName: map['userName'],
      lastName: map['lastName'],
      phoneNo: map['phoneNo'],
      password: map['password'],
      timestamp: map['timestamp'],
      isAdmin: map['isAdmin'],
      email: map['email'],
      isTeacher: map['isTeacher'],
      photoUrl: map['photoUrl'],
      rollNo: map['rollNo'],
      grades: map['grades'],
    );
  }

  factory AppUserModel.fromDocument(doc) {
    return AppUserModel(
      id: doc.data()["id"],
      password: doc.data()["password"],
      userName: doc.data()["userName"],
      timestamp: doc.data()["timestamp"],
      email: doc.data()["email"],
      isAdmin: doc.data()["isAdmin"],
      firstName: doc.data()["firstName"],
      lastName: doc.data()["lastName"],
      phoneNo: doc.data()["phoneNo"],
      isTeacher: doc.data()["isTeacher"],
      photoUrl: doc.data()["photoUrl"],
      rollNo: doc.data()["rollNo"],
      grades: doc.data()["grades"],
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUserModel.fromJson(String source) =>
      AppUserModel.fromMap(json.decode(source));

  AppUserModel copyWith({
    String? id,
    String? userName,
    String? lastName,
    String? phoneNo,
    String? password,
    String? timestamp,
    bool? isAdmin,
    String? email,
    bool? isTeacher,
    String? photoUrl,
    String? rollNo,
    String? grades,
  }) {
    return AppUserModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      lastName: lastName ?? this.lastName,
      phoneNo: phoneNo ?? this.phoneNo,
      password: password ?? this.password,
      timestamp: timestamp ?? this.timestamp,
      isAdmin: isAdmin ?? this.isAdmin,
      email: email ?? this.email,
      isTeacher: isTeacher ?? this.isTeacher,
      photoUrl: photoUrl ?? this.photoUrl,
      rollNo: rollNo ?? this.rollNo,
      grades: grades ?? this.grades,
    );
  }

  @override
  String toString() {
    return 'AppUserModel(id: $id, userName: $userName, lastName: $lastName, phoneNo: $phoneNo, password: $password, timestamp: $timestamp, isAdmin: $isAdmin, email: $email, isTeacher: $isTeacher, photoUrl: $photoUrl, rollNo: $rollNo, grades: $grades)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUserModel &&
        other.id == id &&
        other.userName == userName &&
        other.lastName == lastName &&
        other.phoneNo == phoneNo &&
        other.password == password &&
        other.timestamp == timestamp &&
        other.isAdmin == isAdmin &&
        other.email == email &&
        other.isTeacher == isTeacher &&
        other.photoUrl == photoUrl &&
        other.rollNo == rollNo &&
        other.grades == grades;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userName.hashCode ^
        lastName.hashCode ^
        phoneNo.hashCode ^
        password.hashCode ^
        timestamp.hashCode ^
        isAdmin.hashCode ^
        email.hashCode ^
        isTeacher.hashCode ^
        photoUrl.hashCode ^
        rollNo.hashCode ^
        grades.hashCode;
  }
}
