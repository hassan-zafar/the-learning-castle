import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:the_learning_castle_v2/config/collections.dart';
import 'package:the_learning_castle_v2/database/database.dart';
import 'package:the_learning_castle_v2/screens/auth/widgets/decoration_functions.dart';
import 'package:the_learning_castle_v2/screens/landingPage.dart';
import 'package:the_learning_castle_v2/services/authentication_service.dart';
import 'package:the_learning_castle_v2/tools/custom_toast.dart';
import '../../../config/palette.dart';
import 'title.dart';

class SignIn extends StatefulWidget {
  SignIn({
    required Key key,
    required this.onRegisterClicked,
  }) : super(key: key);

  final VoidCallback onRegisterClicked;

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();
  final _textFormKey = GlobalKey<FormState>();
  bool _isLoading = false;

  TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final isSubmitting = context.isSubmitting();
    return
        // SignInForm(
        //   child:
        Form(
      key: _textFormKey,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: LoginTitle(
                  title: 'Welcome\nBack',
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: signInInputDecoration(hintText: 'Email'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: signInInputDecoration(hintText: 'Password'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: TextFormField(
                      controller: _codeController,
                      decoration: signInInputDecoration(hintText: 'Code'),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sign In",
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Palette.darkBlue,
                          fontSize: 24,
                        ),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 100),
                        child: Visibility(
                          visible: _isLoading,
                          child: const LinearProgressIndicator(
                            backgroundColor: Palette.darkBlue,
                          ),
                        ),
                      ),
                      RawMaterialButton(
                        onPressed: () => _handleLogin(),
                        elevation: 0.0,
                        fillColor: Palette.darkBlue,
                        splashColor: Palette.darkOrange,
                        padding: const EdgeInsets.all(22.0),
                        shape: const CircleBorder(),
                        child: const Icon(
                          FontAwesomeIcons.longArrowAltRight,
                          color: Colors.white,
                          size: 24.0,
                        ),
                      )
                    ],
                  ),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: InkWell(
                  //     splashColor: Colors.white,
                  //     onTap: () {
                  //       widget.onRegisterClicked.call();
                  //     },
                  //     child: const Text(
                  //       'Sign up',
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         decoration: TextDecoration.underline,
                  //         color: Palette.darkBlue,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            // Expanded(
            //   flex: 1,
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: Column(
            //       children: [
            //         const Text(
            //           "Are you a Student/Parent or Teacher",
            //           style: TextStyle(
            //             color: Colors.black54,
            //           ),
            //         ),
            //         const SizedBox(
            //           height: 14.0,
            //         ),
            //         GroupButton(isRadio: true,
            //           buttons: ['Student/Parent', 'Teacher'],
            //           onSelected: (index, isSelected) {},
            //         ),
            //         const Spacer(),
            //         // InkWell(
            //         //   splashColor: Colors.white,
            //         //   onTap: () {
            //         //     onRegisterClicked?.call();
            //         //   },
            //         //   child: RichText(
            //         //     text: const TextSpan(
            //         //       text: "Don't have an account? ",
            //         //       style: TextStyle(color: Colors.black54),
            //         //       children: <TextSpan>[
            //         //         TextSpan(
            //         //           text: 'SIGN UP',
            //         //           style: TextStyle(
            //         //               fontWeight: FontWeight.bold,
            //         //               color: Colors.black),
            //         //         ),
            //         //       ],
            //         //     ),
            //         //   ),
            //         // ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
        // ),
      ),
    );
  }

  void _handleLogin() async {
    final _form = _textFormKey.currentState;
    if (_form == null) {
      return null;
    }
    if (_form.validate()) {
      setState(() {
        _isLoading = true;
      });
      print("in codes");

      final String email = _emailController.text;
      final String password = _passwordController.text;
      final String code = _codeController.text;

      List allCodes = [];
      List allExpiryDates = [];
      QuerySnapshot snapshot = await codesRef.get();
      snapshot.docs.forEach((e) {
        Timestamp exp = e['expiryDate'];
        if (exp.toDate().isBefore(DateTime.now())) {
          allCodes.add(e['code'].toString());
        }
      });
      for (int i = 0; i < allCodes.length; i++) {
        if (_codeController.text.toString() == allCodes[i]) {
          String userId = await AuthenticationService()
              .logIn(email: email, password: password)
              .onError((error, stackTrace) async {
            errorToast(message: "Please Try again");
            setState(() {
              _isLoading = false;
              _emailController.clear();
              _passwordController.clear();
            });
            return error.toString();
          });

          await DatabaseMethods()
              .fetchUserInfoFromFirebase(uid: userId)
              .then((value) => setState(() {
                    _isLoading = false;
                    Get.off(() => LandingPage());
                  }));

          break;
        } else {
          errorToast(message: "Couldn't match code");
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}
