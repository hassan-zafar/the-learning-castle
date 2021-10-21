import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ClassesModel {
  bool? isTeacher;
  String? classId;
  String? dateTime;
  String? className;
  String? branchName;

  ClassesModel({
    this.isTeacher,
    this.classId,
    this.dateTime,
    this.className,
    this.branchName,
  });

  ClassesModel copyWith({
    bool? isTeacher,
    String? classId,
    String? dateTime,
    String? className,
    String? branchName,
  }) {
    return ClassesModel(
      isTeacher: isTeacher ?? this.isTeacher,
      classId: classId ?? this.classId,
      dateTime: dateTime ?? this.dateTime,
      className: className ?? this.className,
      branchName: branchName ?? this.branchName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isTeacher': isTeacher,
      'classId': classId,
      'dateTime': dateTime,
      'className': className,
      'branchName': branchName,
    };
  }

  factory ClassesModel.fromMap(Map<String, dynamic> map) {
    return ClassesModel(
      isTeacher: map['isTeacher'],
      classId: map['classId'],
      dateTime: map['dateTime'],
      className: map['className'],
      branchName: map['branchName'],
    );
  }
  factory ClassesModel.fromDocument(DocumentSnapshot doc) {
    return ClassesModel(
      isTeacher: doc['isTeacher'],
      classId: doc['classId'],
      dateTime: doc['dateTime'],
      className: doc['className'],
      branchName: doc['branchName'],
    );
  }
  String toJson() => json.encode(toMap());

  factory ClassesModel.fromJson(String source) =>
      ClassesModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ClassesModel(isTeacher: $isTeacher, classId: $classId, dateTime: $dateTime, className: $className, branchName: $branchName)';
  }
}
