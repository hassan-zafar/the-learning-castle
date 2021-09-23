import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:the_learning_castle_v2/config/colllections.dart';
import 'package:the_learning_castle_v2/constants.dart';
import 'package:the_learning_castle_v2/tools/loading.dart';

class ManageCodes extends StatefulWidget {
  @override
  _ManageCodesState createState() => _ManageCodesState();
}

class _ManageCodesState extends State<ManageCodes> {
  TextEditingController _createCodeController = TextEditingController();

  DateTime? expiryDate;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: backgroundColorBoxDecoration(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: Center(
                child: FaIcon(
              FontAwesomeIcons.keycdn,
              color: Colors.black,
            )),
            elevation: 10,
            title: TextFormField(
              controller: _createCodeController,
              decoration: InputDecoration(
                  hintText: "Create Code",
                  filled: false,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () =>
                        createCode(_createCodeController.text, context),
                  )),
            ),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: codesRef.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return LoadingIndicator();
              }
              if (snapshot.data == null) {
                return Center(
                  child: Text(
                    "Warning Currently No Active codes!!",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                );
              }
              List allCodes = [];
              List allExpiryDates = [];
              snapshot.data!.docs.forEach((e) {
                allCodes.add(e['code'].toString());
                allExpiryDates.add(e['expiryDate'].toDate());
              });
              return ListView.separated(
                itemBuilder: (context, index) {
                  return Dismissible(
                    background: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: Text('DELETE'),
                    ),
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      setState(() {
                        deleteCode(allCodes[index]);
                      });
                      BotToast.showText(text: "Deleted From Database");
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 12.0, left: 8, right: 8),
                      child: ListTile(
                        leading: FaIcon(
                          FontAwesomeIcons.key,
                          color: Colors.black,
                        ),
                        title: Text("Code : ${allCodes[index]}"),
                        subtitle: Text(allExpiryDates[index]
                                .isBefore(DateTime.now())
                            ? "Code has been Expired"
                            : "Expiry Date : ${allExpiryDates[index].toString()}"),
                        // onLongPress: () => deleteCode(allCodes[index]),
                      ),
                    ),
                  );
                },
                itemCount: allCodes.length,
                separatorBuilder: (context, index) {
                  return Divider();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  createCode(String code, BuildContext parentContext) async {
    await showDatePicker(
            context: parentContext,
            helpText: "Select Code Expiration Date",
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2024))
        .then((value) {
      setState(() {
        expiryDate = value;
      });
      if (expiryDate != null) {
        handleCode(code, expiryDate!);
        _createCodeController.clear();
      } else {
        BotToast.showText(text: "Please re-Enter Expiry Date ");
      }
    });
  }

  handleCode(String code, DateTime expiryDate) async {
    await codesRef.doc(code).set({"code": code, "expiryDate": expiryDate}).then(
        (value) => BotToast.showText(text: "Code Added Successfully"));
  }

  void deleteCode(String code) {
    codesRef.doc(code).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }
}
