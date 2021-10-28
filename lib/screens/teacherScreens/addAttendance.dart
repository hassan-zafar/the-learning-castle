import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:the_learning_castle_v2/config/colllections.dart';
import 'package:the_learning_castle_v2/config/enums/studentAttendence.dart';
import 'package:the_learning_castle_v2/constants.dart';
import 'package:the_learning_castle_v2/database/database.dart';
import 'package:the_learning_castle_v2/models/attendanceModel.dart';
import 'package:the_learning_castle_v2/models/classModel.dart';
import 'package:the_learning_castle_v2/models/users.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? _focusedDay;
  DateTime? _selectedDay;
  StudentAttendence _studentAttendence = StudentAttendence.Remaining;

  List<ClassesModel> allClassesData = [];
  List<AppUserModel> allStudentsData = [];
  List<AttendanceModel> allPresentStudents = [];
  List<AttendanceModel> allAbsentStudents = [];
  List<AttendanceModel> allAttendanceData = [];
  List<AttendanceModel> selectedStudentAttendance = [];

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    getAllStudents();
  }

  getAttendance(AppUserModel user) async {
    allAttendanceData = [];
    allAbsentStudents = [];
    allPresentStudents = [];
    bool dontExist = false;
    attendanceRef
        .doc(user.id)
        .collection("attendance")
        .doc(dateTimeScript)
        .get()
        .then((value) async {
      if (value.exists) {
        print(value.data());
        AttendanceModel attendanceDatatemp =
            AttendanceModel.fromDocument(value);
        if (attendanceDatatemp.isPresent!) {
          setState(() {
            allPresentStudents.add(attendanceDatatemp);
          });
        } else {
          setState(() {
            allAbsentStudents.add(attendanceDatatemp);
          });
        }

        allAttendanceData.add(attendanceDatatemp);
        return attendanceDatatemp;
      } else {
        DatabaseMethods()
            .setAttendance(
                dateTime: dateTimeScript,
                isPresent: false,
                name: "${user.firstName} ${user.lastName}",
                userId: user.id,
                userName: user.userName)
            .then((value) {
          print(value);
          AttendanceModel absStudnt = value;
          setState(() {
            allAbsentStudents.add(absStudnt);
          });
        });
      }
    });
  }

  getClasses() async {
    setState(() {
      _isLoading = true;
    });
    QuerySnapshot? classesSnapshot = await classesRef
        .where("isTeacher", isEqualTo: true)
        // .where("isAdmin", isEqualTo: false)
        .get();
    allClassesData = [];
    classesSnapshot.docs.forEach((element) async {
      ClassesModel classModel = ClassesModel.fromDocument(element);
      allClassesData.add(classModel);
      // if (attendanceResultTemp.dateTime == dateTimeScript &&
      //     attendanceResultTemp.isPresent != null) {
      // } else {
      //   allStudentsData.add(studentUserModel);
      // }
    });
    setState(() {
      this.allClassesData = allClassesData;
      _isLoading = false;
    });
  }

  getAllStudents() async {
    setState(() {
      _isLoading = true;
    });
    QuerySnapshot? allStudentsSnapshot = await userRef
        .where("isTeacher", isEqualTo: false)
        .where("isAdmin", isEqualTo: false)
        .where("className", isEqualTo: currentUser!.className)
        .get();
    allStudentsData = [];
    allStudentsSnapshot.docs.forEach((element) async {
      AppUserModel studentUserModel = AppUserModel.fromDocument(element);
      getAttendance(studentUserModel);
      getClasses();
      // if (attendanceResultTemp.dateTime == dateTimeScript &&
      //     attendanceResultTemp.isPresent != null) {
      // } else {
      //   allStudentsData.add(studentUserModel);
      // }
    });
    setState(() {
      selectedStudentAttendance = allAbsentStudents;
      print(allAbsentStudents);

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backgroundColorBoxDecoration(),
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: true,
          title: Text(
            'Attendance',
          ),
          actions: [],
          centerTitle: true,
          elevation: 4,
        ),
        body: SafeArea(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay!,
              currentDay: DateTime.now(),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _isLoading = true;
                });

                setState(() {
                  _isLoading = false;
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              calendarFormat: CalendarFormat.week,
            ),
            Align(
              alignment: Alignment(0, 0),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Class: ",
                            style: titleTextStyle(),
                          ),
                          Text(
                            currentUser!.className!,
                            style: titleTextStyle(),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _studentAttendence = StudentAttendence.Present;
                              selectedStudentAttendance = allPresentStudents;
                            });
                          },
                          child: Text("${allPresentStudents.length} Present"),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _studentAttendence = StudentAttendence.Absent;
                              selectedStudentAttendance = allAbsentStudents;
                            });
                          },
                          child: Text("${allAbsentStudents.length} Absent"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  // if (_studentAttendence == StudentAttendence.Absent) {
                  //   allAttendanceData = allAbsentStudents;
                  // } else {
                  //   allAttendanceData = allPresentStudents;
                  // }
                  return studentField(
                      index: index,
                      isPresent: selectedStudentAttendance[index].isPresent!,
                      rollNo: selectedStudentAttendance[index].rollNo!,
                      studentName: selectedStudentAttendance[index].name!,
                      userId: selectedStudentAttendance[index].id!);
                },
                itemCount: selectedStudentAttendance.length,
              ),
            )
          ],
          // );
          //   }
          // ),
          // ],
        )),
      ),
    );
  }

  Padding studentField(
      {required String rollNo,
      required bool isPresent,
      required String studentName,
      required String userId,
      required int index}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: GlassContainer(
        width: double.infinity,
        height: 100,
        opacity: isPresent ? 1 : 0.2,
        shadowStrength: 6,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 20, 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                rollNo.toString(),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Text(
                  studentName.toString(),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  isPresent
                      ? Container()
                      : IconButton(
                          onPressed: () {
                            AttendanceModel studentAttendance = AttendanceModel(
                                name: studentName,
                                isPresent: true,
                                dateTime:
                                    "${DateTime.now().day} : ${DateTime.now().month} : ${DateTime.now().year}",
                                id: userId);
                            DatabaseMethods()
                                .setAttendance(
                                    dateTime: dateTimeScript,
                                    isPresent: true,
                                    name: studentName,
                                    userId: userId,
                                    userName: rollNo)
                                .then((value) {
                              // if (!widget.isPresent!) {
                              setState(() {
                                getAllStudents();

                                // allPresentStudents.add(studentAttendance);
                                // allAbsentStudents.remove(index);
                                // selectedStudentAttendance.remove(index);
                                // isPresent = true;
                              });
                              // }
                            });
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.check,
                            color: Colors.black,
                            size: 30,
                          ),
                          iconSize: 30,
                        ),
                  isPresent
                      ? IconButton(
                          onPressed: () {
                            AttendanceModel studentAttendance = AttendanceModel(
                                name: studentName,
                                isPresent: false,
                                rollNo: rollNo,
                                dateTime:
                                    "${DateTime.now().day} : ${DateTime.now().month} : ${DateTime.now().year}",
                                id: userId);
                            DatabaseMethods()
                                .setAttendance(
                                    dateTime: dateTimeScript,
                                    isPresent: false,
                                    name: studentName,
                                    userId: userId,
                                    userName: rollNo)
                                .then((value) {
                              // if (widget.isPresent!) {
                              setState(() {
                                getAllStudents();
                                // allAbsentStudents.add(value);
                                // allPresentStudents.remove(index);
                                // isPresent = false;

                                selectedStudentAttendance.remove(index);
                              });
                              // }
                            });
                          },
                          icon: Icon(
                            Icons.cancel_rounded,
                            color: Colors.black,
                            size: 30,
                          ),
                          iconSize: 30,
                        )
                      : Container(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
