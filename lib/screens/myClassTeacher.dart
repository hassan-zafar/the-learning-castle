import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_learning_castle_v2/screens/teacherScreens/addAttendance.dart';
class MyClassTeacher extends StatefulWidget {
  const MyClassTeacher({ Key? key }) : super(key: key);

  @override
  _MyClassTeacherState createState() => _MyClassTeacherState();
}

class _MyClassTeacherState extends State<MyClassTeacher> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(child: ElevatedButton(onPressed: ()=>Get.to(()=>AttendancePage()),
        child: Text("Go to attendance"),),),
    );
  }
}