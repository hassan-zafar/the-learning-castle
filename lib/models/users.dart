import 'dart:convert';

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
  final String? branch;
  final String? className;
  final String? androidNotificationToken;

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
      this.branch,
      this.className,
      this.grades,
      this.androidNotificationToken});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'firstName': firstName,
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
      'androidNotificationToken': androidNotificationToken,
      'branch': branch,
      'className': className,
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
        androidNotificationToken: map['androidNotificationToken'],
        branch: map['branch'],
        className: map['className'],
        firstName: map['firstName']);
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
        androidNotificationToken: doc.data()["androidNotificationToken"],
        branch: doc.data()["branch"],
        className: doc.data()["className"]);
  }

  String toJson() => json.encode(toMap());

  factory AppUserModel.fromJson(String source) =>
      AppUserModel.fromMap(json.decode(source));
}
