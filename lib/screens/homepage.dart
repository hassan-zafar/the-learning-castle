import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:the_learning_castle_v2/config/colllections.dart';
import 'package:the_learning_castle_v2/screens/adminScreens/allUsers.dart';
import 'package:the_learning_castle_v2/screens/adminScreens/chatLists.dart';
import 'package:the_learning_castle_v2/screens/adminScreens/commentsNChat.dart';
import 'package:the_learning_castle_v2/screens/adminScreens/manageCodes.dart';
import 'package:the_learning_castle_v2/screens/adminScreens/userDetailsPage.dart';
import 'package:the_learning_castle_v2/screens/appointments.dart';
import 'package:the_learning_castle_v2/screens/calender.dart';
import 'package:the_learning_castle_v2/screens/studentsJournel.dart';
import 'package:the_learning_castle_v2/screens/teacherScreens/addAttendance.dart';

import '../constants.dart';

String? email;
String? userName;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController? pageController;
  int pageIndex = 0;

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController!.jumpToPage(
      pageIndex,
    );
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    print(userUid);
    print(userName);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: backgroundColorBoxDecoration(),
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView(
                controller: pageController,
                onPageChanged: onPageChanged,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  currentUser!.isAdmin! || currentUser!.isTeacher!
                      ? UserNSearch()
                      : UserDetailsPage(userDetails: currentUser!),
                  if (!currentUser!.isTeacher! && !currentUser!.isAdmin!)
                    StudentJournel(
                      studentId: currentUser!.id,
                    ),
                  Calender(),
                  if (currentUser!.isAdmin!) ManageCodes(),
                  Appointments(),
                  if (currentUser!.isAdmin! || currentUser!.isTeacher!)
                    AttendancePage(),
                  if (currentUser!.isAdmin! || currentUser!.isTeacher!)
                    ChatLists()
                  else
                    CommentsNChat(),
                ],
              ),
            ],
          ),
          bottomNavigationBar: GlassContainer(
            opacity: 0.2,
            blur: 8,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: BottomNavigationBar(
              backgroundColor: Color(0x00ffffff),
              currentIndex: pageIndex,
              onTap: onTap,
              elevation: 0,
              showUnselectedLabels: false,
              unselectedItemColor: Colors.black,
              selectedItemColor: Colors.white,
              items: [
                currentUser!.isAdmin! || currentUser!.isTeacher!
                    ? BottomNavigationBarItem(
                        icon: Icon(
                          Icons.person,
                        ),
                        label: currentUser!.isAdmin!
                            ? "All Users"
                            : "All Students")
                    : BottomNavigationBarItem(
                        icon: Icon(Icons.dashboard), label: "Dash Board"),
                if (!currentUser!.isTeacher! && !currentUser!.isAdmin!)
                  BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.clipboard),
                      label: "Student journel"),
                BottomNavigationBarItem(
                    icon: FaIcon(
                      FontAwesomeIcons.calendar,
                      color: Colors.black,
                    ),
                    label: "Calender"),
                if (currentUser!.isAdmin!)
                  BottomNavigationBarItem(
                      icon: FaIcon(
                        FontAwesomeIcons.keycdn,
                        color: Colors.black,
                      ),
                      label: "Manage Codes"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.timelapse_rounded), label: "Appointments"),
                if (currentUser!.isAdmin! || currentUser!.isTeacher!)
                  BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.calendarCheck),
                      label: "Attendance"),
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.comment), label: "Messages"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
