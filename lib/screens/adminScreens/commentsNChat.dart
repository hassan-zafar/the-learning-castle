import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_learning_castle_v2/config/colllections.dart';
import 'package:the_learning_castle_v2/models/users.dart';
import 'package:the_learning_castle_v2/tools/loading.dart';
// import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';

class CommentsNChat extends StatefulWidget {
  // final String? postId;
  // final String? postOwnerId;
  final String? chatId;
  // final String? postMediaUrl;
  final String? heroMsg;
  // final bool? isPostComment;
  // final bool? isProductComment;
  final String? chatNotificationToken;
//  final String userName;
  CommentsNChat({
    // this.postId,
    // this.postMediaUrl,
    // this.postOwnerId,
    this.chatId,
    this.heroMsg,
    // @required this.isPostComment,
    this.chatNotificationToken,
    // @required this.isProductComment
  });
  @override
  CommentsNChatState createState() => CommentsNChatState();
}

TextEditingController _commentNMessagesController = TextEditingController();

class CommentsNChatState extends State<CommentsNChat> {
  // final String? postId;
  // final String? postOwnerId;
  // final bool? isComment;
//  final String userName;
  // CommentsNChatState({
  // required this.postId,
  // required this.postOwnerId,
  // required this.isComment,

  // });
  List<AppUserModel> allAdmins = [];
  String? chatHeadId;
  List<CommentsNMessages> commentsListGlobal = [];

  getAdmins() async {
    QuerySnapshot snapshots =
        await userRef.where('type', isEqualTo: 'admin').get();
    snapshots.docs.forEach((e) {
      allAdmins.add(AppUserModel.fromDocument(e));
    });
  }

  @override
  initState() {
    super.initState();
    if (mounted) {
      setState(() {
        chatHeadId = (isAdmin != null && isAdmin == true
            ? widget.chatId
            : currentUser!.id)!;
      });
    }
    getAdmins();
  }

  buildChat() {
    print(widget.chatId);
    return StreamBuilder<QuerySnapshot>(
      stream: chatRoomRef
          .doc(isAdmin != null && isAdmin == true
              ? widget.chatId
              : currentUser!.id)
          .collection("chats")
          .orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingIndicator();
        }

        List<CommentsNMessages> chatMessages = [];
        snapshot.data!.docs.forEach((DocumentSnapshot doc) {
          chatMessages.add(CommentsNMessages.fromDocument(doc));
        });
        return ListView(
          children: chatMessages,
        );
      },
    );
  }

  addChatMessage() {
    String commentId = Uuid().v1();
    if (_commentNMessagesController.text.trim().length > 1) {
      chatRoomRef
          .doc(isAdmin != null && isAdmin == true
              ? widget.chatId
              : currentUser!.id)
          .collection("chats")
          .doc(commentId)
          .set({
        "userName": currentUser!.userName,
        "userId": currentUser!.id,
        // "androidNotificationToken": currentUser.androidNotificationToken,
        "comment": _commentNMessagesController.text,
        "timestamp": DateTime.now(),
        "avatarUrl": currentUser!.photoUrl,
        "commentId": commentId,
      });

      // sendNotificationToAdmin(
      //     type: "adminChats", title: "Admin Chats", isAdminChat: true);
      // if (isAdmin) {
      //   activityFeedRef.doc(widget.chatId).collection('feedItems').add({
      //     "type": "adminChats",
      //     "commentData": _commentNMessagesController.text,
      //     "userName": currentUser.userName,
      //     "userId": currentUser.id,
      //     "userProfileImg": currentUser.photoUrl,
      //     "postId": widget.chatId,
      //     "mediaUrl": postMediaUrl,
      //     "timestamp": timestamp,
      //   });
      //   sendAndRetrieveMessage(
      //       token: widget.chatNotificationToken,
      //       message: _commentNMessagesController.text,
      //       title: "Admin Chats");
      // }

    } else {
      BotToast.showText(text: "Message field shouldn't be left Empty");
    }
    _commentNMessagesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Contact Admin"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: buildChat(),
            ),
            Divider(),
            ListTile(
              title: TextFormField(
                controller: _commentNMessagesController,
                decoration: InputDecoration(
                  hintText: "Write admin a message...",
                ),
              ),
              trailing: IconButton(
                onPressed: addChatMessage,
                icon: Icon(
                  Icons.send,
                  size: 40.0,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class CommentsNMessages extends StatefulWidget {
  final String? userName;
  final String? userId;
  final String? avatarUrl;
  final String? comment;
  final Timestamp? timestamp;
  final String? commentId;
  // final String? androidNotificationToken;
  CommentsNMessages({
    this.userName,
    this.userId,
    this.avatarUrl,
    this.comment,
    this.timestamp,
    this.commentId,
    // this.androidNotificationToken,
  });
  factory CommentsNMessages.fromDocument(DocumentSnapshot doc) {
    return CommentsNMessages(
      avatarUrl: doc['avatarUrl'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
      userId: doc['userId'],
      userName: doc['userName'],
      commentId: doc["commentId"],
      // androidNotificationToken: doc["androidNotificationToken"],
    );
  }

  @override
  _CommentsNMessagesState createState() => _CommentsNMessagesState();
}

class _CommentsNMessagesState extends State<CommentsNMessages> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12, right: 12, left: 12),
      child: buildMessageBubble(context),
    );
  }

  buildMessageBubble(BuildContext context) {
    bool isMe = currentUser!.id == widget.userId;
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        color: isMe ? Colors.cyan : Colors.black26,
        borderRadius: isMe
            ? BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              )
            : BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CircleAvatar(
                    // backgroundImage:
                    // CachedNetworkImageProvider(widget.avatarUrl!),
                    ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text("${widget.userName} : ",
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.black)),
                          Flexible(
                            child: Text(
                              "${widget.comment}",
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      // Text(
                      //   timeago.format(widget.timestamp!.toDate()),
                      //   style: TextStyle(color: Colors.black54, fontSize: 12),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
