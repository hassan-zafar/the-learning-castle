import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:the_learning_castle_v2/config/colllections.dart';
import 'package:the_learning_castle_v2/database/database.dart';
import 'package:the_learning_castle_v2/tools/custom_toast.dart';
import 'package:the_learning_castle_v2/tools/loading.dart';
import 'package:uuid/uuid.dart';
import '../../../commonUIFunctions.dart';
import '../../../constants.dart';
import 'package:get/get.dart';

class AddReferStudent extends StatefulWidget {
  @override
  _AddReferStudentState createState() => _AddReferStudentState();
}

class _AddReferStudentState extends State<AddReferStudent> {
  final _textFormKey = GlobalKey<FormState>();

  final FixedExtentScrollController yesNoController1 =
      FixedExtentScrollController(initialItem: 0);

  bool isCanadianCitizen = false;
//naming Info
  TextEditingController _studentNameController = TextEditingController();
  TextEditingController _parentNameController = TextEditingController();

  TextEditingController _phoneNoController = TextEditingController();

  TextEditingController _emailController = TextEditingController();

  String registerId = Uuid().v4();
  String socialId = Uuid().v4();

  bool _isLoading = false;
  var _className = '';
  String? _classValue;
  final TextEditingController _classNameController = TextEditingController();
  // getUserEditInfo() {
  //   _firstNameController.text = currentUser.fname;
  //   _emailController.text = currentUser.email;
  //   _addressController.text = currentUser.location;
  //   _phoneNoController.text = currentUser.contact;
  //   _passwordController.text = currentUser.password;
  // }

  @override
  void initState() {
    super.initState();
    // widget.isEdit ? getUserEditInfo() : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backgroundColorBoxDecoration(),
      child: Scaffold(
        body: SafeArea(
            child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Center(
                  child: Form(
                    key: _textFormKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Refer a Student",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 9),
                                child: Container(
                                  child: TextFormField(
                                    controller: _classNameController,

                                    key: ValueKey('Class'),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Class is missed';
                                      }
                                      return null;
                                    },
                                    //keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: 'Class',
                                    ),
                                    onSaved: (value) {
                                      _className = value!;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            DropdownButton<String>(
                              items: [
                                DropdownMenuItem<String>(
                                  child: Text('PlayGroup'),
                                  value: 'PlayGroup',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Preschool'),
                                  value: 'Preschool',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('pre-kg'),
                                  value: 'pre-kg',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('kg1'),
                                  value: 'kg1',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('kg2'),
                                  value: 'kg2',
                                ),
                              ],
                              onChanged: (String? value) {
                                setState(() {
                                  _classValue = value;
                                  _classNameController.text = value!;
                                  print(_className);
                                });
                              },
                              hint: Text('Select a class'),
                              value: _classValue,
                            ),
                          ],
                        ),
                        SizedBox(height: 15),

//Student Name
                        TextInputCard(
                          controller: _studentNameController,
                          label: "Student Name",
                          hintText: "Please Enter Student Name",
                          validatorErrorText: "Name Too Short",
                          validationStringLength: 3,
                        ),

//Parent Name
                        TextInputCard(
                          controller: _parentNameController,
                          label: "Parent name Name",
                          hintText: "Please Enter Parent Name",
                          validatorErrorText: "Name Too Short",
                          validationStringLength: 3,
                        ),

//Email
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GlassContainer(
                            opacity: 0.7,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.text,
                                validator: (val) {
                                  if (val == null) {
                                    return null;
                                  }
                                  if (val.isEmpty) {
                                    return "Field is Empty";
                                  } else if (!val.contains("@") ||
                                      val.trim().length < 7) {
                                    return "Invalid Email Address!";
                                  } else {
                                    return null;
                                  }
                                },
                                // onSaved: (val) => phoneNo = val,
                                autofocus: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "Email Address",
                                  //filled: true,
                                  labelStyle: TextStyle(fontSize: 15.0),
                                  hintText:
                                      "Please enter parent's E-mail address",
                                ),
                              ),
                            ),
                          ),
                        ),

//Phone Number
                        TextInputCard(
                          controller: _phoneNoController,
                          label: "Contact Number",
                          hintText: "Please Enter Parent's Phone Number",
                          validatorErrorText: "Number Too Short",
                          validationStringLength: 7,
                        ),

                        GestureDetector(
                          onTap: _handleSignUp,
                          child: buildSignUpLoginButton(
                            context: context,
                            btnText: "Add Referral",
                            hasIcon: false,
                            color: Colors.green,
                            textColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _isLoading ? Center(child: LoadingIndicator()) : Container(),
          ],
        )),
      ),
    );
  }

  void _handleSignUp() async {
    final _form = _textFormKey.currentState;
    if (_form == null) {
      return null;
    }
    if (_form.validate()) {
      setState(() {
        _isLoading = true;
      });
      DatabaseMethods()
          .addSudentReferrals(
              studentName: _studentNameController.text,
              parentName: _parentNameController.text,
              className: _classNameController.text,
              parentEmail: _emailController.text,
              phoneNo: _phoneNoController.text,
              userId: currentUser!.id!,
              referrsName: currentUser!.userName!)
          .then((value) {
        showToast(message: "Your Referral for student has been Added");
        Get.back();
      });

      setState(() {
        _isLoading = false;
      });
    }
  }
}

class TextInputCard extends StatelessWidget {
  const TextInputCard(
      {required this.controller,
      this.validatorEmptyText: "Field shouldn't be left empty",
      required this.label,
      required this.validatorErrorText,
      required this.validationStringLength,
      required this.hintText});

  final TextEditingController controller;
  final String hintText;
  final String label;
  final String validatorEmptyText;
  final String validatorErrorText;
  final int validationStringLength;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GlassContainer(
        opacity: 0.7,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.text,
            validator: (val) {
              if (val == null) {
                return null;
              }
              if (val.isEmpty) {
                return validatorEmptyText;
              } else if (val.trim().length < validationStringLength) {
                return validatorErrorText;
              } else {
                return null;
              }
            },
            // onSaved: (val) => phoneNo = val,
            autofocus: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              //enabledBorder: InputBorder.none,
              // filled: true,
              // fillColor: Colors.white,
              labelText: label,
              labelStyle: TextStyle(fontSize: 15.0),
              hintText: hintText,
            ),
          ),
        ),
      ),
    );
  }
}
