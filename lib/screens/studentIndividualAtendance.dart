import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:the_learning_castle_v2/config/colllections.dart';
import 'package:the_learning_castle_v2/database/database.dart';
import 'package:the_learning_castle_v2/models/attendanceModel.dart';
import 'package:the_learning_castle_v2/tools/loading.dart';
import 'package:uuid/uuid.dart';
import '../constants.dart';

class StudentIndividualAttendance extends StatefulWidget {
  @override
  _StudentIndividualAttendanceState createState() =>
      _StudentIndividualAttendanceState();
}

class _StudentIndividualAttendanceState
    extends State<StudentIndividualAttendance>
    with AutomaticKeepAliveClientMixin<StudentIndividualAttendance> {
  CalendarController _controller = CalendarController();
  List<Attendance> attendanceList = [];
  TimeOfDay? startingTime;
  TimeOfDay? endingTime;
  DateTime dateTime = DateTime.now();
  TextEditingController _titleController = TextEditingController();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    getAttendances();
  }

  getAttendances() async {
    setState(() {
      _isLoading = true;
    });
    QuerySnapshot attendanceSnapShot =
        await DatabaseMethods().fetchIndividualAttendanceDataFromFirebase();
    List<AttendanceModel> allAttendances = [];
    if (!attendanceSnapShot.docs.isEmpty) {
      setState(() {
        _isLoading = false;
      });
    } else {
      attendanceSnapShot.docs.forEach((e) {
        allAttendances.add(AttendanceModel.fromDocument(e));
      });
      List<Attendance> asd = [];
      allAttendances.forEach((e) {
        asd.add(Attendance(
            eventName: e.isPresent! ? "Present" : "Absent",
            background: Colors.blue.shade900,
            from: e.timestamp!.toDate(),
            to: e.timestamp!.toDate(),
            isAllDay: true));
      });
      setState(() {
        this.attendanceList = asd;
        _isLoading = false;
      });
      print(attendanceList);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      child: Container(
        decoration: backgroundColorBoxDecoration(),
        child: Scaffold(
            body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: _isLoading
                ? LoadingIndicator()
                : SfCalendar(
                    backgroundColor: Colors.transparent,
                    allowedViews: [
                      CalendarView.day,
                      CalendarView.schedule,
                      CalendarView.month,
                      CalendarView.timelineDay,
                      CalendarView.week,
                      CalendarView.timelineMonth,
                      CalendarView.timelineWeek,
                      CalendarView.timelineWorkWeek,
                      CalendarView.workWeek
                    ],
                    view: CalendarView.month,
                    showDatePickerButton: true,
                    showNavigationArrow: true,
                    allowViewNavigation: true,
                    controller: _controller,
                    onTap: (CalendarTapDetails asd) async {
                      // DatePicker.showTime12hPicker(context,currentTime: DateTime.now(),);
                      print(asd.targetElement.index);
                    },
                    dataSource:
                        //  AppointmentDataSource(_getDataSourceAppointment()),
                        AttendanceDataSource(attendanceList),
                    monthViewSettings: MonthViewSettings(
                        appointmentDisplayMode:
                            MonthAppointmentDisplayMode.appointment,
                        showAgenda: true),
                  ),
          ),
        )),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class AttendanceDataSource extends CalendarDataSource {
  AttendanceDataSource(List<Attendance> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Attendance {
  Attendance(
      {this.eventName, this.from, this.to, this.background, this.isAllDay});

  String? eventName;
  DateTime? from;
  DateTime? to;
  Color? background = Colors.purple;
  bool? isAllDay;
}
