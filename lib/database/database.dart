import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_learning_castle_v2/config/colllections.dart';
import 'package:the_learning_castle_v2/database/local_database.dart';
import 'package:the_learning_castle_v2/models/attendanceModel.dart';
import 'package:the_learning_castle_v2/models/studentJournelModel.dart';
import 'package:the_learning_castle_v2/models/users.dart';
import 'package:the_learning_castle_v2/tools/custom_toast.dart';

class DatabaseMethods {
  // Future<Stream<QuerySnapshot>> getproductData() async {
  //   return FirebaseFirestore.instance.collection(productCollection).snapshots();
  // }

  Future addUserInfoToFirebase(
      {required AppUserModel userModel,
      required String userId,
      required bool isStuTeacher,
      required email}) async {
    print("addUserInfoToFirebase");
    final Map<String, dynamic> userInfoMap = json.decode(userModel.toJson());
    return userRef.doc(userId).set(userInfoMap).then((value) {
      if (!isStuTeacher) {
        currentUser = userModel;
        UserLocalData().setUserModel(userModel.toJson());
        UserLocalData().setUserEmail(userModel.email);
        UserLocalData().setUserName(userModel.userName);
        UserLocalData().setIsAdmin(userModel.isAdmin);
      }
    }).catchError(
      (Object obj) {
        errorToast(message: obj.toString());
      },
    );
  }

  Future addStudentJournelEntryToFirebase({
    required StudentJournelModel studentJournelModel,
    required String studentId,
    required DateTime dateOfEntry,
  }) async {
    print("addUserInfoToFirebase");
    final Map<String, dynamic> journelEntryInfoMap =
        json.decode(studentJournelModel.toJson());
    return studentJournelRef
        .doc(studentId)
        .collection("journelEntries")
        .doc(dateOfEntry.toIso8601String())
        .set(journelEntryInfoMap)
        .then((value) {})
        .catchError(
      (Object obj) {
        errorToast(message: obj.toString());
      },
    );
  }

  Future<AttendanceModel> setAttendance(
      {String? userId,
      String? name,
      String? userName,
      bool? isPresent,
      String? dateTime}) async {
    AttendanceModel attendanceModel = AttendanceModel(
        dateTime: dateTime,
        id: userId,
        isPresent: isPresent,
        name: name,
        rollNo: userName);
    attendanceRef
        .doc(userId)
        .collection("attendance")
        .doc(dateTime)
        .set(attendanceModel.toMap());
    DocumentSnapshot attendanceModelSnapshot = await attendanceRef
        .doc(userId)
        .collection("attendance")
        .doc(dateTime)
        .get();

    return AttendanceModel.fromDocument(attendanceModelSnapshot);
  }

  Future fetchUserInfoFromFirebase({
    required String uid,
  }) async {
    final DocumentSnapshot _user = await userRef.doc(uid).get();
    currentUser = AppUserModel.fromDocument(_user);

    UserLocalData().setIsAdmin(currentUser!.isAdmin);
    Map userData = json.decode(currentUser!.toJson());
    UserLocalData().setUserModel(json.encode(userData));
    var user = UserLocalData().getUserData();
    print(user);
    isAdmin = currentUser!.isAdmin;
    print(currentUser!.email);
  }

  Future fetchCalenderDataFromFirebase() async {
    final QuerySnapshot calenderMeetings = await calenderRef.get();

    return calenderMeetings;
  }

  Future fetchPostsDataFromFirebase() async {
    final QuerySnapshot allPostsSnapshots = await postsRef.get();

    return allPostsSnapshots;
  }

  Future fetchAppointmentDataFromFirebase({@required String? uid}) async {
    final QuerySnapshot allAppointmentsSnapshots =
        await appointmentsRef.doc(uid).collection("userAppointments").get();

    return allAppointmentsSnapshots;
  }

  Future fetchStudentJournelDataFromFirebase(
      {required String? uid, required DateTime dateofEntry}) async {
    await studentJournelRef
        .doc(uid)
        .collection("journelEntries")
        .doc(dateofEntry.toIso8601String())
        .get()
        .then((value) {
      print(value.exists);
      if (value.exists) {
        DocumentSnapshot studentJournelDataSnapshot = value;

        return StudentJournelModel.fromDocument(studentJournelDataSnapshot);
      }
    });
  }
}
