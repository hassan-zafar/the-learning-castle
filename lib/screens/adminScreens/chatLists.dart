import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:the_learning_castle_v2/config/colllections.dart';
import 'package:the_learning_castle_v2/constants.dart';
import 'package:the_learning_castle_v2/screens/adminScreens/commentsNChat.dart';
import 'package:the_learning_castle_v2/tools/loading.dart';

class ChatLists extends StatefulWidget {
  bool? isTeacher;
  ChatLists({required this.isTeacher});
  @override
  _ChatListsState createState() => _ChatListsState();
}

class _ChatListsState extends State<ChatLists> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backgroundColorBoxDecoration(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          // backgroundColor: Colors.transparent,
          title: Text("All Chats"),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: widget.isTeacher!
                ? chatListRef
                    .where("isTeacherParent", isEqualTo: true)
                    // .orderBy("timestamp", descending: true)
                    .snapshots()
                : chatListRef
                    // .doc(currentUser!.id)
                    // .collection('chats')
                    .orderBy("timestamp", descending: true)
                    .snapshots(),
            builder: (context, snapshots) {
              if (!snapshots.hasData) {
                return LoadingIndicator();
              }
              List<CommentsNMessages> chatHeads = [];
              print(snapshots.data!.docs.length);
              snapshots.data!.docs.forEach((e) {
                print("in snapshot");
                print(e["userId"]);
                chatHeads.add(CommentsNMessages.fromDocument(e));
                print(chatHeads);
              });
              if (snapshots.data == null || chatHeads.isEmpty) {
                return Center(
                  child: Text(
                    "No Active Chat Heads!!",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                );
              }

              return ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: chatHeads.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CommentsNChat(
                                    chatId: chatHeads[index].userId,
                                    isParent: !currentUser!.isAdmin! &&
                                            currentUser!.isTeacher!
                                        ? true
                                        : false,
                                    chatNotificationToken: chatHeads[index]
                                        .androidNotificationToken,
                                    heroMsg: chatHeads[index].comment,
                                  ))),
                      child: GlassContainer(
                        opacity: 0.5,
                        child: ListTile(
                          title: Text(chatHeads[index].userName!),
                          subtitle: Text(
                            chatHeads[index].comment!,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
