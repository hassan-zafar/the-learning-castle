import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_learning_castle_v2/config/collections.dart';
import 'package:the_learning_castle_v2/database/database.dart';
import 'package:the_learning_castle_v2/screens/auth/widgets/decoration_functions.dart';
import 'package:the_learning_castle_v2/screens/landingPage.dart';
import 'package:the_learning_castle_v2/services/authentication_service.dart';
import 'package:the_learning_castle_v2/tools/custom_toast.dart';
import 'package:the_learning_castle_v2/tools/loading.dart';
import '../../commonUIFunctions.dart';
import '../../constants.dart';
import 'forgetPasswordPage.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _codeController = TextEditingController();

  final _textFormKey = GlobalKey<FormState>();

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: backgroundColorBoxDecoration(),
        child: Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Form(
                    key: _textFormKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Hero(
                                tag: "logo",
                                child: Image.asset(
                                  logo,
                                  height: 100,
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.text,
                              validator: (val) {
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
                              decoration:
                                  signInInputDecoration(hintText: "E-mail")),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              obscureText: _obscureText,
                              validator: (val) {
                                if (val == null) {
                                  return null;
                                }
                                if (val.length < 6) {
                                  return 'Password Too Short';
                                } else {
                                  return null;
                                }
                              },
                              controller: _passwordController,
                              decoration:
                                  signInInputDecoration(hintText: "Password")
                              // InputDecoration(
                              //   suffixIcon: GestureDetector(
                              //     onTap: () {
                              //       setState(() {
                              //         _obscureText = !_obscureText;
                              //       });
                              //     },
                              //     child: Icon(_obscureText
                              //         ? Icons.visibility
                              //         : Icons.visibility_off),
                              //   ),
                              //   border: InputBorder.none,
                              //   filled: true,
                              //   labelText: "Password",
                              //   hintText: "Enter a valid password, min length 6",
                              // ),
                              ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              controller: _codeController,
                              keyboardType: TextInputType.text,
                              validator: (val) {
                                if (val == null) {
                                  return null;
                                }
                                if (val.isEmpty) {
                                  return "Field is Empty";
                                } else if (val.trim().length < 3) {
                                  return "Invalid format!";
                                } else {
                                  return null;
                                }
                              },
                              // onSaved: (val) => phoneNo = val,
                              autofocus: true,
                              decoration:
                                  signInInputDecoration(hintText: "Code")),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgetPasswordPage())),
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
                          ),
                          GestureDetector(
                            onTap: () => _handleLogin(),
                            child: buildSignUpLoginButton(
                                context: context,
                                btnText: "Log In",
                                textColor: Colors.black,
                                hasIcon: false,
                                color: Colors.green),
                          ),

                          SizedBox(
                            height: 20,
                          ),
// Move to Sign Up Page
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _isLoading ? LoadingIndicator() : Container(),
            ],
          ),
        ),
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

      final String email = _emailController.text;
      final String password = _passwordController.text;
      final String code = _codeController.text;

      List allCodes = [];
      List allExpiryDates = [];
      QuerySnapshot snapshot = await codesRef.get();
      print(snapshot);
      snapshot.docs.forEach((e) {
        Timestamp exp = e['expiryDate'];
        print(exp);
        if (exp.toDate().isAfter(DateTime.now())) {
          allCodes.add(e['code'].toString());
        }
      });
      // snapshot.docs.map((e) {
      //   print("in codes");
      //   Timestamp exp = e['expiryDate'];
      //   if (exp.toDate().isBefore(DateTime.now())) {
      //     allCodes.add(e['code'].toString());
      //   }
      // });
      for (int i = 0; i < allCodes.length; i++) {
        print(allCodes.length);
        print(allCodes[i]);
        if (_codeController.text == allCodes[i]) {
          // final userId = await
          AuthenticationService()
              .logIn(email: email, password: password)
              .then((value) {
            setState(() {
              _isLoading = false;
            });
          }).onError((error, stackTrace) async {
            setState(() {
              _isLoading = false;
              _emailController.clear();
              _passwordController.clear();
            });
            // errorToast(message: error.toString());
            return null;
          });

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

// blaBla() async {
//   var data = {
//     "id": "2",
//     "register_id": "sdfdsbjfvbdsakbskbfrrrwe",
//     "date_time": "dfsdfsdf",
//     "ios_register_id": ""
//   };
//
//   var res = await CallApi().postData(data, 'login');
//   var body = json.decode(res.body);
//   print(body.toString());
//   if (body['status'] == 200) {
//     print("success");
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     localStorage.setString('token', body['token']);
//     localStorage.setString('user', json.encode(body['user']));
//   } else {
//     print("failed");
//   }
// }

}
