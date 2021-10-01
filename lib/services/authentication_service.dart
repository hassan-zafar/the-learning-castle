import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the_learning_castle_v2/config/colllections.dart';
import 'package:the_learning_castle_v2/database/database.dart';
import 'package:the_learning_castle_v2/database/local_database.dart';
import 'package:the_learning_castle_v2/models/users.dart';
import 'package:the_learning_castle_v2/screens/landingPage.dart';
import 'package:the_learning_castle_v2/tools/custom_toast.dart';
import 'package:get/get.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    UserLocalData().logOut();
  }

  Future logIn({
    required String email,
    required final String password,
  }) async {
    print("here");
    try {
      // final UserCredential result =
      await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        print(" auth service login: $value");
        print(" auth service login uid: ${value.user!.uid}");

        // return value.user!.uid;
        DatabaseMethods()
            .fetchUserInfoFromFirebase(uid: value.user!.uid)
            .then((value) => Get.off(() => LandingPage()));
      });
      // return result.user!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        errorToast(message: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future deleteUser(String email, String password) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      User user = _firebaseAuth.currentUser!;
      AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
      print(user);
      UserCredential result =
          await user.reauthenticateWithCredential(credentials);
      userRef.doc(user.uid).delete();

      await result.user!.delete();
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<UserCredential?> signUp({
    required final String password,
    required final String? userName,
    required final String? timestamp,
    required final String email,
    final bool? isAdmin,
  }) async {
    print("1st stop");

    try {
      final UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .catchError((Object obj) {
        errorToast(message: obj.toString());
      });
      final UserCredential user = result;
      assert(user != null);
      assert(await user.user!.getIdToken() != null);
      if (user != null) {
        currentUser = AppUserModel(
            id: user.user!.uid,
            email: email.trim(),
            password: password,
            userName: userName
            //  firebaseUuid: user.user!.uid,
            );
        await DatabaseMethods().addUserInfoToFirebase(
            userModel: currentUser!,
            userId: user.user!.uid,
            email: email,
            isStuTeacher: false);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      errorToast(message: "$e.message");
    }
  }

  Future addNewUser({
    String? password,
    final String? firstName,
    final String? userName,
    final String? lastName,
    final String? timestamp,
    final String? email,
    final String? rollNo,
    final String? section,
    final String? phoneNo,
    final bool? isTeacher,
    final String? branch,
    final String? className,
    final String? grades,
  }) async {
    try {
      final UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email!, password: password!)
          .catchError((Object obj) {
        errorToast(message: obj.toString());
      });
      final User user = result.user!;
      assert(user != null);
      assert(await user.getIdToken() != null);
      if (user != null) {
        final AppUserModel currentUser = AppUserModel(
          id: user.uid,
          userName: userName,
          phoneNo: phoneNo!.trim(),
          email: email.trim(),
          password: password,
          firstName: firstName,
          lastName: lastName,
          photoUrl: "",
          timestamp: Timestamp.now().toString(),
          isAdmin: false,
          isTeacher: isTeacher,
          branch: branch,
          className: className,
          grades: grades,
          rollNo: rollNo,
        );
        await DatabaseMethods().addUserInfoToFirebase(
          userModel: currentUser,
          userId: user.uid,
          email: email,
          isStuTeacher: true,
        );
      }
      DatabaseMethods().addFeeRef(
          feeId: user.uid,
          totalFee: "totalFee",
          pendingFee: "0",
          feePackage: "Premium",
          isPaid: true);
      return user;
    } on FirebaseAuthException catch (e) {
      errorToast(message: e.message!);
    }
  }
}
