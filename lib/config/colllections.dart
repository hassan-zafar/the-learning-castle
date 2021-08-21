import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:the_learning_castle_v2/models/users.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
// firebase_storage.FirebaseStorage storageRef =
//     firebase_storage.FirebaseStorage.instance;
final userRef = FirebaseFirestore.instance.collection('users');
final postsRef = FirebaseFirestore.instance.collection('posts');
final Reference storageRef = FirebaseStorage.instance.ref();
final calenderRef = FirebaseFirestore.instance.collection('calenderMeetings');
final appointmentsRef = FirebaseFirestore.instance.collection('appointments');
final codesRef = FirebaseFirestore.instance.collection('codes');
final commentsRef = FirebaseFirestore.instance.collection('comments');
final chatRoomRef = FirebaseFirestore.instance.collection('chatRoom');
final chatListRef = FirebaseFirestore.instance.collection('chatLists');
final studentJournelRef =
    FirebaseFirestore.instance.collection('studentJournel');
final attendanceRef = FirebaseFirestore.instance.collection('attendanceRef');

final feeRef = FirebaseFirestore.instance.collection('feeRef');

AppUserModel? currentUser;
bool? isAdmin;
String? userUid;

String dateTimeScript =
    "${DateTime.now().day} : ${DateTime.now().month} : ${DateTime.now().year}";
