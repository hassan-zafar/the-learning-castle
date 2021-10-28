import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:the_learning_castle_v2/config/colllections.dart';
import 'package:the_learning_castle_v2/database/local_database.dart';
import 'package:the_learning_castle_v2/models/announcementsModel.dart';
import 'package:the_learning_castle_v2/models/attendanceModel.dart';
import 'package:the_learning_castle_v2/models/referStudentModel.dart';
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

  Future addFeeRef({
    required String feeId,
    required String totalFee,
    required String pendingFee,
    required String feePackage,
    required bool isPaid,
  }) async {
    return feeRef.doc(feeId).set({
      "feeId": feeId,
      "feePackage": feePackage,
      "totalFee": totalFee,
      "isPaid": isPaid,
      "pendingFee": pendingFee,
      "lastDate": DateTime.now().add(Duration(days: 30)),
    }).catchError(
      (Object obj) {
        errorToast(message: obj.toString());
      },
    );
  }

  Future addBranch({
    required String branchName,
  }) async {
    return branchesRef
        .doc(branchName)
        .set({"branchName": branchName}).catchError(
      (Object obj) {
        errorToast(message: obj.toString());
      },
    );
  }

  addSudentReferrals({
    required final String studentName,
    required final String parentName,
    required final String className,
    required final String parentEmail,
    required final String phoneNo,
    required String userId,
    required String referrsName,
  }) async {
    FirebaseFirestore.instance.collection("referrals").doc(userId).set({
      "studentName": studentName,
      "parentName": parentName,
      "className": className,
      "timestamp": DateTime.now(),
      "parentEmail": parentEmail,
      "userId": userId,
      "senderName": referrsName,
      "phoneNo": phoneNo,
    });
  }

  Future getReferrStudents() async {
    List<ReferStudentModel> tempAllAnnouncements = [];
    QuerySnapshot tempReferralsSnapshot =
        await FirebaseFirestore.instance.collection('referrals').get();
    tempReferralsSnapshot.docs.forEach((element) {
      tempAllAnnouncements.add(ReferStudentModel.fromDocument(element));
    });
    return tempAllAnnouncements;
  }

  addAnnouncements(
      {required final String postId,
      required final String announcementTitle,
      required final String imageUrl,
      required final String eachUserId,
      required String eachUserToken,
      required final String description}) async {
    FirebaseFirestore.instance
        .collection("announcements")
        .doc(eachUserId)
        .collection("userAnnouncements")
        .doc(postId)
        .set({
      "announcementId": postId,
      "announcementTitle": announcementTitle,
      "description": description,
      "timestamp": DateTime.now(),
      "token": eachUserToken,
      "imageUrl": imageUrl,
      "userId": currentUser!.id
    });
  }

  Future getAnnouncements() async {
    List<AnnouncementsModel> tempAllAnnouncements = [];
    QuerySnapshot tempAnnouncementsSnapshot = await FirebaseFirestore.instance
        .collection('announcements')
        .doc(currentUser!.id)
        .collection("userAnnouncements")
        .get();
    tempAnnouncementsSnapshot.docs.forEach((element) {
      tempAllAnnouncements.add(AnnouncementsModel.fromDocument(element));
    });
    return tempAllAnnouncements;
  }

  Future<AttendanceModel> setAttendance(
      {String? userId,
      String? name,
      String? userName,
      bool? isPresent,
      String? dateTime}) async {
    AttendanceModel attendanceModel = AttendanceModel();
    attendanceRef.doc(userId).collection("attendance").doc(dateTime).set({
      "dateTime": dateTime,
      "id": userId,
      "isPresent": isPresent,
      "name": name,
      "rollNo": userName,
      "timestamp": Timestamp.now()
    });
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
    createToken(uid);
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

  Future fetchIndividualAttendanceDataFromFirebase() async {
    final QuerySnapshot calenderMeetings =
        await attendanceRef.doc(currentUser!.id).collection("attendance").get();

    return calenderMeetings;
  }

  Future fetchPostsDataFromFirebase() async {
    final QuerySnapshot allPostsSnapshots = await postsRef.get();

    return allPostsSnapshots;
  }

  createToken(String uid) {
    FirebaseMessaging.instance.getToken().then((token) {
      userRef.doc(uid).update({"androidNotificationToken": token});
      UserLocalData().setToken(token!);
    });
  }

  Future fetchAppointmentDataFromFirebase({@required String? uid}) async {
    final QuerySnapshot allAppointmentsSnapshots =
        await appointmentsRef.doc(uid).collection("userAppointments").get();

    return allAppointmentsSnapshots;
  }

  Future<QuerySnapshot> fetchBranchesFromFirebase() async {
    final QuerySnapshot allBranchesSnapshots = await branchesRef.get();

    return allBranchesSnapshots;
  }

  // Future fetchStudentJournelDataFromFirebase(
  //     {required String? uid, required DateTime dateofEntry}) async {

  //   });
  // }
}
