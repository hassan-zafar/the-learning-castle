import 'package:flutter/material.dart';
import 'package:the_learning_castle_v2/tools/loading.dart';

import '../../commonUIFunctions.dart';
import '../../constants.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  TextEditingController _emailController = TextEditingController();
  final _textFormKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: backgroundColorBoxDecoration(),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Hero(
                          tag: "logo",
                          child: Image.asset(
                            logo,
                            height: 90,
                          )),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          forgetPassPageIcon,
                          height: 60,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Hero(
                        tag: "passFor",
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Form(
                      key: _textFormKey,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Card(
                          elevation: 4,
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.text,
                            validator: (String? val) {
                              if (val == null) {
                                return null;
                              }
                              if (val.isEmpty) {
                                return "Field is Empty";
                              } else if (!val.contains("@") ||
                                  val.trim().length < 4) {
                                return "Invalid E-mail!";
                              } else {
                                return null;
                              }
                            },
                            // onSaved: (val) => phoneNo = val,
                            autofocus: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "E-mail",
                              labelStyle: TextStyle(fontSize: 15.0),
                              hintText: "Please enter your valid E-mail",
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () => handleForgetPass(),
                      child: buildSignUpLoginButton(
                          context: context,
                          btnText: "Continue",
                          hasIcon: false,
                          textColor: Colors.white,
                          color: Colors.green),
                    ),
                  ],
                ),
                _isLoading ? LoadingIndicator() : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getPass({
    required String email,
  }) async {}

  handleForgetPass() async {
    final FormState? _form = _textFormKey.currentState;

    if (_form == null) {
      return null;
    }
    if (_form.validate()) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
