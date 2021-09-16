import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:the_learning_castle_v2/config/colllections.dart';
import 'package:the_learning_castle_v2/database/database.dart';
import 'package:the_learning_castle_v2/models/referStudentModel.dart';
import 'package:the_learning_castle_v2/screens/referStudents/addReferStudent.dart';
import 'package:the_learning_castle_v2/tools/loading.dart';

import '../../constants.dart';
import '../landingPage.dart';

class ReferStudentPage extends StatefulWidget {
  @override
  _ReferStudentPageState createState() => _ReferStudentPageState();
}

class _ReferStudentPageState extends State<ReferStudentPage> {
  List<ReferStudentModel> allReferStudentPage = [];
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    getReferStudentPage();
  }

  getReferStudentPage() async {
    setState(() {
      _isLoading = true;
      this.allReferStudentPage = [];
    });
    List<ReferStudentModel> allReferStudentPage =
        await DatabaseMethods().getReferrStudents();
    setState(() {
      this.allReferStudentPage = allReferStudentPage;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backgroundColorBoxDecoration(),
      child: Scaffold(
        floatingActionButton: isAdmin!
            ? FloatingActionButton(
                onPressed: () => Get.to(() => AddReferStudent())!
                    .then((value) => getReferStudentPage()),
                child: Icon(Icons.add),
                tooltip: "Add New Referrence",
              )
            : Container(),
        body: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            Center(
              child: Text(
                "Student Referrances",
                style: titleTextStyle(),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GestureDetector(
                    onLongPress: () {
                      return isAdmin!
                          ? deleteNotification(
                              context, allReferStudentPage[index].referrsId!)
                          : null;
                    },
                    child: _isLoading
                        ? LoadingIndicator()
                        : GlassContainer(
                            opacity: 0.6,
                            shadowStrength: 16,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Student's Name: ${allReferStudentPage[index].studentName!}",
                                    style: customTextStyle(),
                                  ),
                                  Text(
                                    "Sender's Name: ${allReferStudentPage[index].senderName!}",
                                    style: customTextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                );
              },
              itemCount: allReferStudentPage.length,
            ),
          ],
        ),
      ),
    );
  }

  deleteNotification(BuildContext parentContext, String id) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  allUsersList.forEach((e) {
                    FirebaseFirestore.instance
                        .collection('referrals')
                        .doc(e.id)
                        .collection("referrals")
                        .doc(id)
                        .delete();
                  });
                  getReferStudentPage();
                  Navigator.pop(context);
                },
                child: Text(
                  'Delete Announcement',
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              )
            ],
          );
        });
  }
}
