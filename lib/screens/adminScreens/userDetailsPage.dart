import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:the_learning_castle_v2/config/colllections.dart';
import 'package:the_learning_castle_v2/constants.dart';
import 'package:the_learning_castle_v2/models/feeModel.dart';
import 'package:the_learning_castle_v2/models/users.dart';
import 'package:the_learning_castle_v2/screens/loginRelated/login.dart';
import 'package:the_learning_castle_v2/services/authentication_service.dart';
import 'package:the_learning_castle_v2/tools/loading.dart';

class UserDetailsPage extends StatefulWidget {
  final AppUserModel userDetails;
  UserDetailsPage({required this.userDetails});
  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  DateTime? lastDate;

  TextEditingController? _titleController;
  TextEditingController? _pendingFeeController;
  TextEditingController? _totalFeeController;
  FeeModel? feeDetails;
  bool? isPaid = false;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _pendingFeeController = TextEditingController();
    _totalFeeController = TextEditingController();
    if (!widget.userDetails.isTeacher! && !widget.userDetails.isAdmin!)
      getFeeDetails();
  }

  getFeeDetails() async {
    setState(() {
      _isLoading = true;
    });
    DocumentSnapshot feeDetailsSnapshot =
        await feeRef.doc(widget.userDetails.id).get();
    FeeModel feeDetails = FeeModel.fromDocument(feeDetailsSnapshot);
    setState(() {
      this.feeDetails = feeDetails;
    });

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backgroundColorBoxDecorationLogo(),
      child: Scaffold(
        floatingActionButton: currentUser!.isAdmin!
            ? FloatingActionButton(
                onPressed: () => feeStatus(context),
                child: Icon(Icons.add),
              )
            : FloatingActionButton(
                onPressed: () {
                  AuthenticationService().signOut();
                  Get.off(() => LoginPage());
                },
                child: Text("Logout"),
              ),
        body: _isLoading
            ? LoadingIndicator()
            : ListView(
                shrinkWrap: true,
                children: [
                  Lottie.asset(userDetailsLottie, height: 150, repeat: false),
                  wrappingContainer(buildUserDetails()),
                  widget.userDetails.isTeacher! || widget.userDetails.isAdmin!
                      ? Container()
                      : wrappingContainer(buildFeeInfo()),
                ],
              ),
      ),
    );
  }

  feeStatus(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: StatefulBuilder(builder: (context, setState) {
              return Dialog(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Change Fee Status",
                        style: titleTextStyle(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        DateTime? lastDateTemp = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2021, 7, 20),
                            lastDate: DateTime(2025, 7, 20));
                        setState(() {
                          this.lastDate = lastDateTemp;
                        });
                      },
                      child: Text(lastDate == null
                          ? "Select Last Payment Date"
                          : "${lastDate!.day} / ${lastDate!.month} / ${lastDate!.year}"),
                    ),
                    CheckboxListTile(
                      title: Text("Fee Paid"),
                      value: isPaid,
                      onChanged: (newValue) {
                        setState(() {
                          isPaid = newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                          labelText: "Fee Package",
                          hintText: "Enter Package Name"),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: _pendingFeeController,
                      decoration: InputDecoration(
                          labelText: "Pending Fee",
                          hintText: "Enter Pending Fee"),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: _totalFeeController,
                      decoration: InputDecoration(
                          labelText: "Total Fee", hintText: "Enter Total Fee"),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            feeRef.doc(widget.userDetails.id).set({
                              'feeId': widget.userDetails.id,
                              'pendingFee': _pendingFeeController!.text,
                              'lastDate': lastDate,
                              'feePackage': _titleController!.text,
                              'isPaid': isPaid,
                              'totalFee': _totalFeeController!.text,
                            });
                          });

                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today_outlined),
                            Text("Add Event"),
                          ],
                        ))
                  ],
                ),
              );
            }),
          );
        });
  }

  Padding wrappingContainer(Widget buildWidget) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GlassContainer(
        opacity: 0.4,
        child: buildWidget,
      ),
    );
  }

  Row rowText({required final String fieldName, required final String result}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            fieldName,
            style: customTextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Expanded(
          child: Text(
            result,
            style: customTextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget buildFeeInfo() {
    print(widget.userDetails.isAdmin);
    print(feeDetails);

    DateTime? lastDate = feeDetails!.lastDate!.toDate();
    return _isLoading
        ? Text(
            "Fee Info",
            style: titleTextStyle(),
          )
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Fee Info",
                  style: titleTextStyle(),
                ),
                Divider(
                  thickness: 1,
                ),
                rowText(
                    fieldName: "Fee Package", result: feeDetails!.feePackage!),
                SizedBox(
                  height: 8,
                ),
                rowText(
                    fieldName: "Last Date",
                    result:
                        "${lastDate.day} / ${lastDate.month} / ${lastDate.year}"),
                SizedBox(
                  height: 8,
                ),
                rowText(
                    fieldName: "Fee Status",
                    result: feeDetails!.isPaid! ? "Is Paid" : "Is Due"),
                SizedBox(
                  height: 8,
                ),
                rowText(
                    fieldName: "Pending Fee", result: feeDetails!.pendingFee!),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          );
  }

  Widget buildUserDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Details',
            style: titleTextStyle(fontSize: 25),
          ),
          Divider(
            thickness: 1,
          ),
          rowText(
              fieldName: "Is Admin",
              result: widget.userDetails.isAdmin! ? "YES" : "NO"),
          SizedBox(
            height: 8.0,
          ),
          rowText(
              fieldName: widget.userDetails.isTeacher! ? "UserName" : "Roll NO",
              result:
                  "${widget.userDetails.firstName} ${widget.userDetails.lastName}"),
          SizedBox(
            height: 8.0,
          ),
          // rowText(
          //     fieldName: "First Name", result: widget.userDetails.firstName!),
          SizedBox(
            height: 8.0,
          ),
          rowText(fieldName: "Last Name", result: widget.userDetails.lastName!),
          SizedBox(
            height: 8.0,
          ),
          // widget.userDetails.isTeacher!
          //     ? Container()
          //     : rowText(
          //         fieldName: "Grade", result: "${widget.userDetails.grades!}"),
          widget.userDetails.isTeacher!
              ? Container()
              : SizedBox(
                  height: 8.0,
                ),
          rowText(fieldName: "Email", result: widget.userDetails.email!),
          SizedBox(
            height: 8.0,
          ),
          rowText(
              fieldName: "Phone No", result: "${widget.userDetails.phoneNo!}"),
          SizedBox(
            height: 8.0,
          ),
        ],
      ),
    );
  }
}
