import 'package:cloud_firestore/cloud_firestore.dart';

class ReferStudentModel {
  final String? userId;
  final String? referrsId;
  final String? studentName;
  final String? senderName;
  final Timestamp? timestamp;
  final String? parentName;
  final String? phoneNo;
  final String? className;

  ReferStudentModel({
    this.userId,
    this.referrsId,
    this.studentName,
    this.senderName,
    this.timestamp,
    this.parentName,
    this.className,
    this.phoneNo,
  });

  Map<String, dynamic> toMap() {
    return {};
  }

  factory ReferStudentModel.fromDocument(doc) {
    return ReferStudentModel(
      userId: doc.data()["userId"],
      referrsId: doc.data()["referrsId"],
      studentName: doc.data()["studentName"],
      senderName: doc.data()["senderName"],
      timestamp: doc.data()["timestamp"],
      parentName: doc.data()["parentName"],
      phoneNo: doc.data()["phoneNo"],
      className: doc.data()["className"],
    );
  }
}
