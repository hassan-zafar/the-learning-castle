import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  bool? isPresent;
  String? id;
  String? dateTime;
  String? name;
  String? rollNo;
  Timestamp? timestamp;

  AttendanceModel(
      {this.isPresent,
      this.id,
      this.dateTime,
      this.name,
      this.rollNo,
      this.timestamp});

  // Map<String, dynamic> toMap() {
  //   return {
  //     'isPresent': isPresent,
  //     'id': id,
  //     'dateTime': dateTime,
  //     'name': name,
  //     'rollNo': rollNo,
  //   };
  // }

  // factory AttendanceModel.fromMap(Map<String, dynamic> map) {
  //   return AttendanceModel(
  //     isPresent: map['isPresent'],
  //     id: map['id'],
  //     dateTime: map['dateTime'],
  //     name: map['name'],
  //     rollNo: map['rollNo'],
  //   );
  // }
  factory AttendanceModel.fromDocument(DocumentSnapshot doc) {
    return AttendanceModel(
      isPresent: doc['isPresent'],
      id: doc['id'],
      dateTime: doc['dateTime'],
      name: doc['name'],
      timestamp: doc['timestamp'],
      rollNo: doc['rollNo'],
    );
  }

  @override
  String toString() {
    return 'AttendanceModel(isPresent: $isPresent, id: $id, dateTime: $dateTime, name: $name, rollNo: $rollNo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AttendanceModel &&
        other.isPresent == isPresent &&
        other.id == id &&
        other.dateTime == dateTime &&
        other.name == name &&
        other.rollNo == rollNo;
  }

  @override
  int get hashCode {
    return isPresent.hashCode ^
        id.hashCode ^
        dateTime.hashCode ^
        name.hashCode ^
        rollNo.hashCode;
  }
}
