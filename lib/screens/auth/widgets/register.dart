// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:the_learning_castle_v2/config/palette.dart';
// import 'package:the_learning_castle_v2/screens/auth/widgets/decoration_functions.dart';
// import 'package:the_learning_castle_v2/screens/auth/widgets/title.dart';
// import 'package:the_learning_castle_v2/screens/homepage.dart';
// import 'package:the_learning_castle_v2/services/authentication_service.dart';
// import 'package:the_learning_castle_v2/tools/custom_toast.dart';
// import 'package:get/get.dart';

// class Register extends StatefulWidget {
//   Register(
//       {required Key key,
//       required this.onSignInPressed,
//       required this.onRegisterClicked})
//       : super(key: key);

//   final VoidCallback onSignInPressed;

//   final VoidCallback onRegisterClicked;

//   @override
//   _RegisterState createState() => _RegisterState();
// }

// class _RegisterState extends State<Register> {
//   TextEditingController _emailController = TextEditingController();

//   TextEditingController _passwordController = TextEditingController();

//   TextEditingController _confirmPasswordController = TextEditingController();

//   TextEditingController _userNameController = TextEditingController();
//   final _textFormKey = GlobalKey<FormState>();

//   bool _isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     // final isSubmitting = context.isSubmitting();
//     return
//         // SignInForm(
//         //   child:
//         Form(
//       key: _textFormKey,
//       child: Padding(
//         padding: const EdgeInsets.all(32.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Expanded(
//               flex: 1,
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: LoginTitle(
//                   title: 'Create\nAccount',
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 4,
//               child: ListView(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     child: TextFormField(
//                         controller: _userNameController,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           color: Colors.white,
//                         ),
//                         decoration:
//                             registerInputDecoration(hintText: 'UserName')),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     child: TextFormField(
//                         controller: _emailController,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           color: Colors.white,
//                         ),
//                         decoration: registerInputDecoration(hintText: 'Email')),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     child: TextFormField(
//                       controller: _passwordController,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         color: Colors.white,
//                       ),
//                       decoration: registerInputDecoration(hintText: 'Password'),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     child: TextFormField(
//                       controller: _confirmPasswordController,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         color: Colors.white,
//                       ),
//                       decoration:
//                           registerInputDecoration(hintText: 'Confirm Password'),
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Sign Up",
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w800,
//                           color: Palette.darkBlue,
//                           fontSize: 24,
//                         ),
//                       ),
//                       ConstrainedBox(
//                         constraints: const BoxConstraints(maxWidth: 100),
//                         child: Visibility(
//                           visible: _isLoading,
//                           child: const LinearProgressIndicator(
//                             backgroundColor: Palette.darkBlue,
//                           ),
//                         ),
//                       ),
//                       RawMaterialButton(
//                         onPressed: () => _handleSignUp(context),
//                         elevation: 0.0,
//                         fillColor: Palette.darkBlue,
//                         splashColor: Palette.darkOrange,
//                         padding: const EdgeInsets.all(22.0),
//                         shape: const CircleBorder(),
//                         child: const Icon(
//                           FontAwesomeIcons.longArrowAltRight,
//                           color: Colors.white,
//                           size: 24.0,
//                         ),
//                       )
//                     ],
//                   ),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: InkWell(
//                       splashColor: Colors.white,
//                       onTap: () {
//                         widget.onSignInPressed.call();
//                       },
//                       child: const Text(
//                         'Sign in',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         // ),
//       ),
//     );
//   }

//   void _handleSignUp(BuildContext context) async {
//     final _form = _textFormKey.currentState;
//     if (_form == null) {
//       return null;
//     }
//     if (_form.validate()) {
//       setState(() {
//         _isLoading = true;
//       });

//       UserCredential? _user = await AuthenticationService().signUp(
//           timestamp: DateTime.now().toString(),
//           email: _emailController.text,
//           isAdmin: false,
//           password: _passwordController.text,
//           userName: _userNameController.text);
//       //     .onError((error, stackTrace) async {
//       //   setState(() {
//       //     _isLoading = false;
//       //   });
//       //   errorToast(message: "$error");
//       //   return AuthenticationService().;
//       // });
//       print(_user);
//       // ignore: unnecessary_null_comparison
//       if (_user != null) {
//         successToast(message: 'Successfully Registered');
//         Get.off(() => HomePage());
//       }
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
// }
