import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:group_button/group_button.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:the_learning_castle_v2/config/collections.dart';
import 'package:the_learning_castle_v2/constants.dart';
import 'package:the_learning_castle_v2/database/database.dart';
import 'package:the_learning_castle_v2/models/studentJournelModel.dart';
import 'package:the_learning_castle_v2/screens/adminScreens/commentsNChat.dart';
import 'package:the_learning_castle_v2/tools/custom_toast.dart';
import 'package:the_learning_castle_v2/tools/loading.dart';
import 'package:get/get.dart';

class StudentJournel extends StatefulWidget {
  // HomePageWidget({Key key}) : super(key: key);
  final String? studentId;
  StudentJournel({required this.studentId});
  @override
  _StudentJournelState createState() => _StudentJournelState();
}

class _StudentJournelState extends State<StudentJournel> {
  double? happySlider;
  List<int>? iWas = [];
  int? iAte;
  int? diaperChange;
  int? iNeed;
  TextEditingController? _notesController;
  TextEditingController? textController1;
  final kgrpBtnRadius = BorderRadius.circular(16);
  final kSelectedColor = Colors.green;
  final kUnselectedColor = Colors.white60;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? _focusedDay;
  DateTime? _selectedDay;
  StudentJournelModel? studentJournelEntry;

  bool _isLoading = false;

  TimeOfDay? sleepingTime;

  List<String> iWasList = [
    "Circle Time",
    "Story Time",
    "Messy Play",
    "Sand Play",
    "Craft",
    "Sensory Activities"
  ];
  TextEditingController _sleepTimeController = TextEditingController();

  bool _DoesntExist = false;
  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    textController1 = TextEditingController();
    _notesController = TextEditingController();
    if (!currentUser!.isTeacher! && !currentUser!.isAdmin!) {
      getJournelEntries(selectedDate: _selectedDay, id: currentUser!.id);
    }
  }

  getJournelEntries({String? id, DateTime? selectedDate}) async {
    setState(() {
      _isLoading = true;
    });

    await studentJournelRef
        .doc(id)
        .collection("journelEntries")
        .doc('2021-11-16T17:08:27.008837'
            // selectedDate!.toIso8601String()
            )
        .get()
        .then((value) {
      print(value.exists);
      print(value.data());
      if (value.exists) {
        DocumentSnapshot studentJournelDataSnapshot = value;
        StudentJournelModel studentJournelEntryTemp =
            StudentJournelModel.fromDocument(studentJournelDataSnapshot);
        setState(() {
          this.studentJournelEntry = studentJournelEntryTemp;
        });

        print(studentJournelEntry);
        print(studentJournelEntry!.iWas.runtimeType);
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _DoesntExist = true;
        });
      }

      // ignore: invalid_return_type_for_catch_error
    }).catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: backgroundColorBoxDecoration(),
        child: Scaffold(
          key: scaffoldKey,

          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: true,
            shadowColor: Colors.transparent,
            title: Text(
              'While I was here...',
              style: titleTextStyle(fontSize: 24, color: Colors.black),
            ),
            actions: [
              currentUser!.isTeacher!
                  ? GestureDetector(
                      onTap: () {
                        // if (diaperChange != null &&
                        //     happySlider != null &&
                        //     iAte != null &&
                        //     iNeed != null &&
                        //     iWas != null) {
                        setState(() {
                          _isLoading = true;
                        });
                        studentJournelEntry = StudentJournelModel(
                            diaperChange: diaperChange,
                            happySlider: happySlider,
                            iAte: iAte,
                            iNeed: iNeed,
                            sleepTIme: sleepingTime!.format(context),
                            sleepingTimeStr: _sleepTimeController.text,
                            iWas: iWas!,
                            journelNotes: _notesController!.text);
                        DatabaseMethods()
                            .addStudentJournelEntryToFirebase(
                                studentJournelModel: studentJournelEntry!,
                                studentId: widget.studentId!,
                                dateOfEntry: _selectedDay!)
                            .then((value) {
                          setState(() {
                            _isLoading = false;
                          });
                          showToast(message: "Journel Successfully Updated");
                          Get.back();
                        });
                        // } else {
                        //   setState(() {
                        //     _isLoading = false;
                        //   });
                        //   showToast(message: "Fields Should Not be Left Empty");
                        // }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.green),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                "Publish",
                                style: titleTextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
            centerTitle: true,
            elevation: 4,
          ),
          floatingActionButton: InkWell(
            onTap: () => Get.to(() => CommentsNChat(
                  chatId: widget.studentId,
                  isParent: !currentUser!.isAdmin! && !currentUser!.isTeacher!
                      ? true
                      : false,
                  chatNotificationToken: currentUser!.androidNotificationToken,
                )),
            child: GlassContainer(
              width: 120,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Send Msg"), Icon(Icons.chat_bubble)],
                ),
              ),
            ),
          ),
          // backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
                _isLoading
                    ? LoadingIndicator()
                    : ListView(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
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
                              if (!currentUser!.isTeacher! &&
                                  !currentUser!.isAdmin!) {
                                setState(() {
                                  _selectedDay = selectedDay;
                                  _focusedDay = focusedDay;
                                  _isLoading = true;
                                });
                                getJournelEntries(
                                    selectedDate: _selectedDay,
                                    id: currentUser!.id);
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                            onPageChanged: (focusedDay) {
                              setState(() {
                                _focusedDay = focusedDay;
                              });
                            },
                            calendarFormat: CalendarFormat.week,
                          ),
                          _DoesntExist
                              ? Center(
                                  child:
                                      Text("Entry Does not exist for this day"),
                                )
                              : journelWidget(context)
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column journelWidget(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: GlassContainer(
            shadowStrength: 6,
            opacity: 0.3,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Text(
                      'I was this much Happy',
                      style: titleTextStyle(fontSize: 20),
                    ),
                  ),
                  Slider(
                    activeColor: Colors.red,
                    inactiveColor: Color(0xFF9E9E9E),
                    min: 0,
                    max: 10,
                    // label: "😊",
                    value: happySlider ??= 0,
                    onChanged: (newValue) {
                      if (currentUser!.isTeacher!)
                        setState(() => happySlider = newValue);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: GlassContainer(
            shadowStrength: 6,
            opacity: 0.3,
            width: double.infinity,
            height: 180,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'I did ',
                    style: titleTextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GroupButton(
                    spacing: 12,
                    borderRadius: kgrpBtnRadius,
                    selectedColor: kSelectedColor,
                    unselectedColor: kUnselectedColor,
                    isRadio: false,
                    buttons: iWasList,
                    
                    selectedButtons: studentJournelEntry != null
                        ? studentJournelEntry!.iWas
                        : null,
                    onSelected: (index, isSelected) {
                      if (currentUser!.isTeacher!) {
                        print(index);
                        print(isSelected);
                        if (isSelected && !iWas!.contains(index)) {
                          iWas!.add(index);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: GlassContainer(
                shadowStrength: 6,
                opacity: 0.3,
                width: MediaQuery.of(context).size.width * 0.45,
                height: 200,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: AutoSizeText(
                        'I ate',
                        style: titleTextStyle(fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: GroupButton(
                          isRadio: true,
                          borderRadius: kgrpBtnRadius,
                          selectedColor: kSelectedColor,
                          unselectedColor: kUnselectedColor,
                          spacing: 12,
                          crossGroupAlignment: CrossGroupAlignment.start,
                          mainGroupAlignment: MainGroupAlignment.start,
                          buttons: [
                            "All My Food",
                            "Some of my food",
                            "None Of my Food"
                          ],
                          selectedButton: studentJournelEntry != null
                              ? studentJournelEntry!.iAte
                              : null,
                          onSelected: (index, isSelected) {
                            if (currentUser!.isTeacher!) iAte = index;
                          }),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: GlassContainer(
                shadowStrength: 6,
                opacity: 0.3,
                width: MediaQuery.of(context).size.width * 0.45,
                height: 200,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: AutoSizeText(
                        'Diaper Change',
                        style: titleTextStyle(fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: GroupButton(
                          isRadio: true,
                          borderRadius: kgrpBtnRadius,
                          selectedColor: kSelectedColor,
                          unselectedColor: kUnselectedColor,
                          direction: Axis.vertical,
                          crossGroupAlignment: CrossGroupAlignment.center,
                          mainGroupAlignment: MainGroupAlignment.spaceEvenly,
                          buttons: ['Once', 'Twice', 'Thrice'],
                          selectedButton: studentJournelEntry == null
                              ? null
                              : studentJournelEntry!.diaperChange,
                          onSelected: (index, isSelected) {
                            if (currentUser!.isTeacher!) diaperChange = index;
                          }),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: GlassContainer(
            shadowStrength: 6,
            opacity: 0.3,
            width: MediaQuery.of(context).size.width * 0.45,
            height: 200,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: AutoSizeText(
                    'I need',
                    style: titleTextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: GroupButton(
                      isRadio: true,
                      spacing: 12,
                      borderRadius: kgrpBtnRadius,
                      selectedColor: kSelectedColor,
                      unselectedColor: kUnselectedColor,
                      selectedButton: studentJournelEntry == null
                          ? null
                          : studentJournelEntry!.iNeed,
                      buttons: ['Diapers', 'Wipes', 'Formula'],
                      onSelected: (index, isSelected) {
                        if (currentUser!.isTeacher!) iNeed = index;
                      }),
                )

                // Expanded(
                //   child: Padding(
                //     padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                //     child: TextFormField(
                //       controller: textController1,
                //       obscureText: false,
                //       decoration: InputDecoration(
                //         hintText: 'type Here',
                //         hintStyle: FlutterFlowTheme.bodyText1.override(
                //           fontFamily: 'Poppins',
                //         ),
                //         enabledBorder: UnderlineInputBorder(
                //           borderSide: BorderSide(
                //             color: Color(0x00000000),
                //             width: 1,
                //           ),
                //           borderRadius: const BorderRadius.only(
                //             topLeft: Radius.circular(4.0),
                //             topRight: Radius.circular(4.0),
                //           ),
                //         ),
                //         focusedBorder: UnderlineInputBorder(
                //           borderSide: BorderSide(
                //             color: Color(0x00000000),
                //             width: 1,
                //           ),
                //           borderRadius: const BorderRadius.only(
                //             topLeft: Radius.circular(4.0),
                //             topRight: Radius.circular(4.0),
                //           ),
                //         ),
                //       ),
                //       style: FlutterFlowTheme.bodyText1.override(
                //         fontFamily: 'Poppins',
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: GlassContainer(
            shadowStrength: 6,
            opacity: 0.3,
            height: 150,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'I Slept',
                    style: titleTextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child:
                        // (currentUser!.isTeacher! ||
                        //         currentUser!.isAdmin!)
                        //     ?
                        Container(
                      // height: 200,
                      // width: 200,
                      child: Row(
                        children: [
                          Text("When:"),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black12)),
                            onPressed: () async {
                              if (currentUser!.isAdmin! ||
                                  currentUser!.isTeacher!) {
                                TimeOfDay? sleepingTimeTemp =
                                    await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                        helpText: "Sleeping Time");
                                setState(() {
                                  this.sleepingTime = sleepingTimeTemp!;
                                });
                                print(sleepingTime);
                              } else {
                                // setState(() {
                                //   this.sleepingTime =
                                //       studentJournelEntry!.sleepTIme;
                                // });
                              }
                            },
                            child:
                                currentUser!.isAdmin! || currentUser!.isTeacher!
                                    ? Text(sleepingTime == null
                                        ? "Sleeping Time"
                                        : sleepingTime!.format(context))
                                    : Text(studentJournelEntry!.sleepTIme!),
                          ),
                          Text("How Long:"),
                          currentUser!.isTeacher! ||
                                  currentUser!.isAdmin! ||
                                  studentJournelEntry == null
                              ? Expanded(
                                  child: TextField(
                                  controller: _sleepTimeController,
                                  decoration:
                                      InputDecoration(suffix: Text('min')),
                                  keyboardType: TextInputType.datetime,
                                ))
                              : Text(
                                  studentJournelEntry!.sleepingTimeStr! != null
                                      ? studentJournelEntry!.sleepingTimeStr!
                                      : ""),
                        ],
                      ),
                    )

                    // : Container(),
                    )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: GlassContainer(
            shadowStrength: 6,
            opacity: 0.3,
            height: 150,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Notes',
                    style: titleTextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: (currentUser!.isTeacher! || currentUser!.isAdmin!)
                      //      &&
                      // studentJournelEntry! != null
                      ? TextFormField(
                          controller: _notesController,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: 'Notes About the child',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.multiline,
                        )
                      : Text(studentJournelEntry!.journelNotes!.toString()),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
