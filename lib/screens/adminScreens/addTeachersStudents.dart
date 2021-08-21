import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:the_learning_castle_v2/screens/homepage.dart';
import 'package:the_learning_castle_v2/services/authentication_service.dart';
import 'package:the_learning_castle_v2/tools/custom_toast.dart';
import 'package:the_learning_castle_v2/tools/loading.dart';
import 'package:uuid/uuid.dart';
import '../../commonUIFunctions.dart';
import '../../constants.dart';
import 'package:get/get.dart';

class AddStudentTeacher extends StatefulWidget {
  final bool isEdit;
  AddStudentTeacher({required this.isEdit});
  @override
  _EmailSignUpState createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<AddStudentTeacher> {
  final _textFormKey = GlobalKey<FormState>();

  final FixedExtentScrollController yesNoController1 =
      FixedExtentScrollController(initialItem: 0);

  bool isCanadianCitizen = false;
//naming Info
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();

  TextEditingController _phoneNoController = TextEditingController();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _sectionController = TextEditingController();

  bool _obscureText = true;
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText2 = true;
  TextEditingController _confirmPasswordController = TextEditingController();
  String registerId = Uuid().v4();
  String socialId = Uuid().v4();

  bool _isTeacher = true;
  bool _isLoading = false;

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
                            widget.isEdit
                                ? "Edit User's Information"
                                : "Add Teachers and Students",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
//Is Teacher or Student
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GlassContainer(
                            height: 100,
                            opacity: 0.7,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text("Teacher Or Student"),
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: teacherStudentPicker(
                                              controller: yesNoController1)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

//Name
                        TextInputCard(
                          controller: _firstNameController,
                          label: "First Name",
                          hintText: "Please Enter First Name",
                          validatorErrorText: "Name Too Short",
                          validationStringLength: 3,
                        ),

//Last Name
                        TextInputCard(
                          controller: _lastNameController,
                          label: "Last Name",
                          hintText: "Please Enter Last Name",
                          validatorErrorText: "Name Too Short",
                          validationStringLength: 3,
                        ),
//User Name
                        TextInputCard(
                          controller: _userNameController,
                          label: _isTeacher
                              ? "User Name To Be Appointed"
                              : "Student Roll No To Be Appointed",
                          hintText: _isTeacher
                              ? "Please Enter username to teacher"
                              : "Please Enter roll no to Student",
                          validatorErrorText: _isTeacher
                              ? "Name Too Short"
                              : "Roll No Too Short",
                          validationStringLength: 3,
                        ),
//Section
                        TextInputCard(
                          controller: _sectionController,
                          label: "Add Section to be appointed",
                          hintText: "Please add section to be appointed",
                          validatorErrorText: "Section Name Too Short",
                          validationStringLength: 2,
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
                                  hintText: "Please enter valid E-mail address",
                                ),
                              ),
                            ),
                          ),
                        ),

//Phone Number
                        TextInputCard(
                          controller: _phoneNoController,
                          label: "Contact Number",
                          hintText: "Please Enter Phone Number",
                          validatorErrorText: "Number Too Short",
                          validationStringLength: 7,
                        ),

//Password
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GlassContainer(
                            opacity: 0.7,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: TextFormField(
                                obscureText: _obscureText,
                                validator: (val) =>
                                    val != null && val.length < 6
                                        ? 'Password Too Short'
                                        : null,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    child: Icon(_obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                  border: InputBorder.none,
                                  labelText: "Password",
                                  hintText:
                                      "Enter a valid password, min length 6",
                                ),
                              ),
                            ),
                          ),
                        ),

//Confirm Password
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GlassContainer(
                            opacity: 0.7,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: TextFormField(
                                obscureText: _obscureText2,
                                validator: (val) =>
                                    val != null && val.length < 6
                                        ? 'Password Too Short'
                                        : null,
                                controller: _confirmPasswordController,
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscureText2 = !_obscureText2;
                                      });
                                    },
                                    child: Icon(_obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                  border: InputBorder.none,
                                  labelText: "Confirm Password",
                                  hintText: "Re-Enter Password",
                                ),
                              ),
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: _handleSignUp,
                          child: buildSignUpLoginButton(
                            context: context,
                            btnText: "Add User",
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

  Container teacherStudentPicker({
    final controller,
  }) {
    return Container(
      // width: 100,
      height: 80,
      child: CupertinoPicker(
        selectionOverlay: null,
        // squeeze: 1.5,
        onSelectedItemChanged: (int value) {
          setState(() {
            if (value == 0) {
              _isTeacher = true;
            } else {
              _isTeacher = false;
            }
          });
          print(_isTeacher);
        },
        itemExtent: 25,
        scrollController: controller,
        children: [
          Text(
            "Teacher",
            style: TextStyle(fontSize: 18),
          ),
          Text(
            "Student/Parent",
            style: TextStyle(fontSize: 18),
          )
        ],
        useMagnifier: true,
        magnification: 1.3,
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
      AuthenticationService()
          .addNewUser(
        isTeacher: _isTeacher,
        email: _emailController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        password: _passwordController.text,
        phoneNo: _phoneNoController.text,
        userName: _userNameController.text,
        timestamp: Timestamp.now().toString(),
        section: _sectionController.text,
        rollNo: _userNameController.text,
      )
          .then((value) {
        String? userAddedType;
        _isTeacher ? userAddedType = "Teacher" : userAddedType = "Student";
        showToast(message: "New $userAddedType has been Added");
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
