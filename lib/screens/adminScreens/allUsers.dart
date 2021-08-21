import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:the_learning_castle_v2/config/colllections.dart';
import 'package:the_learning_castle_v2/constants.dart';
import 'package:the_learning_castle_v2/models/users.dart';
import 'package:the_learning_castle_v2/screens/adminScreens/addTeachersStudents.dart';
import 'package:the_learning_castle_v2/screens/adminScreens/userDetailsPage.dart';
import 'package:the_learning_castle_v2/screens/auth/auth.dart';
import 'package:the_learning_castle_v2/screens/loginRelated/login.dart';
import 'package:the_learning_castle_v2/screens/studentsJournel.dart';
import 'package:the_learning_castle_v2/services/authentication_service.dart';
import 'package:the_learning_castle_v2/tools/loading.dart';

class UserNSearch extends StatefulWidget {
  // final UserModel currentUser;
  // UserNSearch({this.currentUser});
  @override
  _UserNSearchState createState() => _UserNSearchState();
}

class _UserNSearchState extends State<UserNSearch>
    with AutomaticKeepAliveClientMixin<UserNSearch> {
  Future<QuerySnapshot>? searchResultsFuture;
  TextEditingController searchController = TextEditingController();

  String typeSelected = 'users';
  handleSearch(String query) {
    Future<QuerySnapshot> users =
        userRef.where("userName", isGreaterThanOrEqualTo: query).get();
    setState(() {
      searchResultsFuture = users;
    });
  }

  clearSearch() {
    searchController.clear();
  }

  AppBar buildSearchField(context) {
    return AppBar(
      backgroundColor: Theme.of(context).accentColor,
      title: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
            hintText: "Search",
            prefixIcon: Icon(Icons.search),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: clearSearch,
            )),
        onFieldSubmitted: handleSearch,
      ),
    );
  }

  buildSearchResult() {
    return FutureBuilder<QuerySnapshot>(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingIndicator();
        }
        List<UserResult> searchResults = [];
        snapshot.data!.docs.forEach((doc) {
          String completeName = doc["userName"].toString().toLowerCase().trim();
          if (completeName.contains(searchController.text)) {
            AppUserModel user = AppUserModel.fromDocument(doc);
            UserResult searchResult = UserResult(user);
            searchResults.add(searchResult);
          }
        });
        return ListView(
          children: searchResults,
        );
      },
    );
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Container(
        decoration: backgroundColorBoxDecorationLogo(),
        child: Scaffold(
          appBar: buildSearchField(context),
          body: searchResultsFuture == null
              ? buildAllUsers()
              : buildSearchResult(),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: "Add Students And Teachers",
            onPressed: () => Get.to(() => AddStudentTeacher(isEdit: false)),
          ),
        ),
      ),
    );
  }

  buildAllUsers() {
    return Stack(
      children: [
        StreamBuilder<QuerySnapshot>(
            stream: userRef.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return LoadingIndicator();
              }
              List<UserResult> userResults = [];
              List<UserResult> allAdmins = [];

              snapshot.data!.docs.forEach((doc) {
                AppUserModel user = AppUserModel.fromDocument(doc);

                //remove auth user from recommended list
                if (user.isAdmin!) {
                  UserResult adminResult = UserResult(user);
                  allAdmins.add(adminResult);
                } else {
                  UserResult userResult = UserResult(user);
                  userResults.add(userResult);
                }
              });
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GlassContainer(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            typeSelected = "users";
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: [
                              GlassContainer(
                                opacity: 0.7,
                                shadowStrength: 8,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "${userResults.length}",
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      Icon(
                                        Icons.person_outline,
                                        size: 20.0,
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Text(
                                        "Total Users",
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          typeSelected = "admin";
                                        });
                                      },
                                      child: GlassContainer(
                                          opacity: 0.7,
                                          shadowStrength: 8,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "All Admins ${allAdmins.length}",
                                              style: TextStyle(fontSize: 20.0),
                                            ),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      typeSelected == 'admin'
                          ? Column(
                              children: allAdmins,
                            )
                          : Text(""),
                      typeSelected == 'users'
                          ? Column(
                              children: userResults,
                            )
                          : Text(''),
                    ],
                  ),
                ),
              );
            }),
        Positioned(
            left: 20,
            bottom: 20,
            child: GestureDetector(
              onTap: () {
                AuthenticationService().signOut();
                Get.off(LoginPage());
              },
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.red,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("LogOut"),
                  )),
            ))
      ],
    );
  }
}

class UserResult extends StatelessWidget {
  final AppUserModel user;
  UserResult(this.user);
  @override
  Widget build(BuildContext context) {
    String? stuTeacher;
    user.isTeacher! ? stuTeacher = "Teacher" : stuTeacher = "Student";
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onLongPress: () => makeAdmin(context),
            onTap: () {
              currentUser!.isAdmin! && !currentUser!.isTeacher!
                  ? Get.to(() => UserDetailsPage(
                        userDetails: user,
                      ))
                  : Get.to(() => StudentJournel(
                        studentId: user.id,
                      ));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GlassContainer(
                opacity: 0.6,
                shadowStrength: 8,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person),
                  ),
                  title: Text(
                    user.userName.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    user.userName.toString(),
                  ),
                  trailing: Text(user.isAdmin != null && user.isAdmin == true
                      ? "Admin"
                      : stuTeacher),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  makeAdmin(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            children: <Widget>[
              user.isAdmin! && user.id != userUid
                  ? SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        makeAdminFunc("Rank changed to User");
                      },
                      child: Text(
                        'Make User',
                      ),
                    )
                  : SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        makeAdminFunc("Upgraded to Admin");
                      },
                      child: Text(
                        'Make Admin',
                      ),
                    ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  deleteUser();
                },
                child: Text(
                  'Delete User',
                  style: TextStyle(color: Colors.red),
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

  void makeAdminFunc(String msg) {
    userRef.doc(user.id).update({"isAdmin": !user.isAdmin!});
    addToFeed(msg);

    BotToast.showText(text: msg);
  }

  addToFeed(String msg) {
    // activityFeedRef.doc(user.id).collection('feedItems').add({
    //   "type": "mercReq",
    //   "commentData": msg,
    //   "userName": user.displayName,
    //   "userId": user.id,
    //   "userProfileImg": user.photoUrl,
    //   "ownerId": currentUser.id,
    //   "mediaUrl": currentUser.photoUrl,
    //   "timestamp": timestamp,
    //   "productId": "",
    // });
  }

  void deleteUser() {
    userRef.doc(user.id).delete();
    BotToast.showText(text: 'User Deleted Refresh');
  }
}
