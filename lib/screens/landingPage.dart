import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:the_learning_castle_v2/config/colllections.dart';
import 'package:the_learning_castle_v2/database/local_database.dart';
import 'package:the_learning_castle_v2/models/users.dart';
import 'package:the_learning_castle_v2/screens/adminScreens/manageCodes.dart';
import 'package:the_learning_castle_v2/screens/adminScreens/userDetailsPage.dart';
import 'package:the_learning_castle_v2/screens/announcements/announcements.dart';
import 'package:the_learning_castle_v2/screens/myClassTeacher.dart';
import 'package:the_learning_castle_v2/screens/referStudents/referStudentPage.dart';
import 'package:the_learning_castle_v2/screens/studentIndividualAtendance.dart';
import 'package:the_learning_castle_v2/screens/teacherScreens/addAttendance.dart';
import 'package:the_learning_castle_v2/services/authentication_service.dart';
import 'package:the_learning_castle_v2/tools/loading.dart';
import 'package:the_learning_castle_v2/tools/neuomorphic.dart';
import '../constants.dart';
import '../main.dart';
import 'aboutUs.dart';
import 'adminScreens/allUsers.dart';
import 'adminScreens/chatLists.dart';
import 'appointements/appointments.dart';
import 'calender.dart';
import 'loginRelated/login.dart';

String? userUid;
String? email;
String? token;
List<AppUserModel> allUsersList = [];

void showNotification() {
  flutterLocalNotificationsPlugin.show(
      0,
      "Testing ",
      "How you doin ?",
      NotificationDetails(
          android: AndroidNotificationDetails(
              channel.id, channel.name, channel.description,
              importance: Importance.high,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher')));
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _isLoading = false;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging;
  getAllUsers() async {
    setState(() {
      _isLoading = true;
    });
    QuerySnapshot snapshots = await userRef.get();
    snapshots.docs.forEach((e) {
      allUsersList.add(AppUserModel.fromDocument(e));
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    isAdmin! ? getAllUsers() : null;
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: backgroundColorBoxDecoration(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08,
                      ),
                      Image.asset(
                        logo,
                        height: 200,
                        colorBlendMode: BlendMode.exclusion,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08,
                      ),
                      if (isAdmin!)
                        adminPages()
                      else if (currentUser!.isTeacher!)
                        teacherPages()
                      else
                        studentPages(),
                    ],
                  ),
                ),
              ),
              _isLoading ? LoadingIndicator() : Container()
            ],
          ),
        ),
      ),
    );
  }

  Column studentPages() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Get.to(() => Announcements()),
              child: EditedNeuomprphicContainer(
                text: "Announcements",
                icon: Icons.announcement_outlined,
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(() => AboutUsPage()),
              child: EditedNeuomprphicContainer(
                icon: Icons.info_outline,
                isIcon: true,
                text: "About Us",
                isLanding: true,
              ),
            ),
            GestureDetector(
              onTap: () =>
                  Get.to(() => UserDetailsPage(userDetails: currentUser!)),
              child: EditedNeuomprphicContainer(
                text: "My Details",
                icon: Icons.person_outline_rounded,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(() => Calender());
              },
              child: EditedNeuomprphicContainer(
                text: "Calender",
                isLanding: true,
                icon: Icons.calendar_today_outlined,
                isIcon: true,
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(() => Appointments()),
              child: EditedNeuomprphicContainer(
                text: "Appointments",
                icon: Icons.calendar_view_month_rounded,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => currentUser!.isTeacher!
                    ? AttendancePage()
                    : StudentIndividualAttendance());
              },
              child: EditedNeuomprphicContainer(
                  text: "View Attendance", icon: Icons.person_add_alt_outlined),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Get.to(() => ChatLists()),
              child: EditedNeuomprphicContainer(
                text: "Chat Lists",
                isIcon: true,
                icon: Icons.chat_bubble_outline_outlined,
                isLanding: true,
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(() => ReferStudentPage()),
              child: EditedNeuomprphicContainer(
                text: "Refer Student",
                isIcon: true,
                icon: Icons.stacked_bar_chart_rounded,
                isLanding: true,
              ),
            ),
            GestureDetector(
              onTap: () {
                AuthenticationService().signOut();
                UserLocalData().logOut();
                Get.off(() => LoginPage());
              },
              child: EditedNeuomprphicContainer(
                icon: Icons.logout,
                text: "Log Out",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column teacherPages() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Get.to(() => Announcements()),
              child: EditedNeuomprphicContainer(
                text: "Announcements",
                icon: Icons.announcement_outlined,
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(() => AboutUsPage()),
              child: EditedNeuomprphicContainer(
                icon: Icons.info_outline,
                isIcon: true,
                text: "About Us",
                isLanding: true,
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(() => UserNSearch()),
              child: EditedNeuomprphicContainer(
                text: "All Students",
                icon: Icons.person_outline_rounded,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(() => Calender());
              },
              child: EditedNeuomprphicContainer(
                text: "Calender",
                isLanding: true,
                icon: Icons.calendar_today_outlined,
                isIcon: true,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => MyClassTeacher());
              },
              child: EditedNeuomprphicContainer(
                  text: "My Classes", icon: Icons.school),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Get.to(() => ChatLists()),
              child: EditedNeuomprphicContainer(
                text: "Chat Lists",
                isIcon: true,
                icon: Icons.chat_bubble_outline_outlined,
                isLanding: true,
              ),
            ),
            // GestureDetector(
            //   onTap: () => Get.to(() => ReferStudentPage()),
            //   child: EditedNeuomprphicContainer(
            //     text: "Refer Student",
            //     isIcon: true,
            //     icon: Icons.stacked_bar_chart_rounded,
            //     isLanding: true,
            //   ),
            // ),
            GestureDetector(
              onTap: () {
                AuthenticationService().signOut();
                UserLocalData().logOut();
                Get.off(() => LoginPage());
              },
              child: EditedNeuomprphicContainer(
                icon: Icons.logout,
                text: "Log Out",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column adminPages() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Get.to(() => Announcements()),
              child: EditedNeuomprphicContainer(
                text: "Announcements",
                icon: Icons.announcement_outlined,
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(() => ManageCodes()),
              child: EditedNeuomprphicContainer(
                icon: Icons.qr_code_2_rounded,
                isIcon: true,
                text: "Manage Codes",
                isLanding: true,
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(() => UserNSearch()),
              child: EditedNeuomprphicContainer(
                text: "All Users",
                icon: Icons.person_outline_rounded,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(() => Calender());
              },
              child: EditedNeuomprphicContainer(
                text: "Calender",
                isLanding: true,
                icon: Icons.calendar_today_outlined,
                isIcon: true,
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(() => Appointments()),
              child: EditedNeuomprphicContainer(
                text: "Appointments",
                icon: Icons.calendar_view_month_rounded,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => AttendancePage());
              },
              child: EditedNeuomprphicContainer(
                  text: "Attendance Page", icon: Icons.person_add_alt_outlined),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Get.to(() => ChatLists()),
              child: EditedNeuomprphicContainer(
                text: "Chat Lists",
                isIcon: true,
                icon: Icons.chat_bubble_outline_outlined,
                isLanding: true,
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(() => ReferStudentPage()),
              child: EditedNeuomprphicContainer(
                text: "Refer Student",
                isIcon: true,
                icon: Icons.stacked_bar_chart_rounded,
                isLanding: true,
              ),
            ),
            GestureDetector(
              onTap: () {
                AuthenticationService().signOut();
                UserLocalData().logOut();
                Get.off(() => LoginPage());
              },
              child: EditedNeuomprphicContainer(
                icon: Icons.logout,
                text: "Log Out",
              ),
            ),
          ],
        ),
      ],
    );
  }
}
