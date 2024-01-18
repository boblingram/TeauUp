import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:get/get.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';
import 'dart:async';

import 'package:teamup/controllers/ConnectController.dart';

class GroupChannelView extends StatefulWidget {
  final GroupChannel groupChannel;

  const GroupChannelView({Key? key, required this.groupChannel})
      : super(key: key);

  @override
  GroupChannelViewState createState() => GroupChannelViewState();
}

class GroupChannelViewState extends State<GroupChannelView>
    with ChannelEventHandler {
  ConnectController connectController = Get.find();

  @override
  void initState() {
    super.initState();
    connectController.groupChannel = widget.groupChannel;
    getMessages(widget.groupChannel);
    SendbirdSdk().addChannelEventHandler(widget.groupChannel.channelUrl, this);
  }

  @override
  void dispose() {
    connectController.messages.clear();
    SendbirdSdk().removeChannelEventHandler(widget.groupChannel.channelUrl);
    super.dispose();
  }

  @override
  onMessageReceived(channel, message) {
    setState(() {
      connectController.messages.add(message);
      connectController.messages.sort(((a, b) => b.createdAt.compareTo(a.createdAt)));
    });
  }

  Future<void> getMessages(GroupChannel channel) async {
    try {
      List<BaseMessage> messages = await channel.getMessagesByTimestamp(
          DateTime.now().millisecondsSinceEpoch * 1000, MessageListParams());
      setState(() {
        messages.sort(((a, b) => b.createdAt.compareTo(a.createdAt)));
        connectController.messages = messages;
      });
    } catch (e) {
      print('group_channel_view.dart: getMessages: ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: navigationBar(widget.groupChannel),
      body: body(context),
    );
  }

  PreferredSizeWidget navigationBar(GroupChannel channel) {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Colors.white,
      centerTitle: false,
      leading: BackButton(color: Colors.grey.shade700),
      title: Container(
        width: 250,
        child: Text(
          [for (final member in channel.members) member.nickname].join(", "),
          style: TextStyle(color: Colors.grey.shade900),
        ),
      ),
      actions: [
        InkWell(
          onTap: () {
            connectController.startVideoCall();
            /*connectController
                .sendVideoCallMessage(connectController.testingRoomId);*/
          },
          child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.grey.shade300),
              padding: EdgeInsets.fromLTRB(2, 3, 2, 2),
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.videocam_rounded,
                color: Colors.black,
              )),
        )
      ],
    );
  }

  Widget body(BuildContext context) {
    ChatUser user = asDashChatUser(SendbirdSdk().currentUser!);
    return Padding(
      // A little breathing room for devices with no home button.
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 40),
      child: GetBuilder<ConnectController>(
        builder: (connectController){
          return DashChat(
            key: Key(widget.groupChannel.channelUrl),
            onSend: (ChatMessage message) async {
              var sentMessage =
              widget.groupChannel.sendUserMessageWithText(message.text);
              setState(() {
                connectController.messages.add(sentMessage);
                connectController.messages.sort(((a, b) => b.createdAt.compareTo(a.createdAt)));
              });
            },
            inputOptions: InputOptions(
              sendOnEnter: true,
              alwaysShowSend: true,
              sendButtonBuilder: defaultSendButton(color: Colors.red),
              textInputAction: TextInputAction.send,
              inputDecoration: InputDecoration(
                isDense: true,
                filled: true,
                hintText: "Type your message",
                fillColor: Colors.white,
                contentPadding: EdgeInsets.only(
                  left: 18,
                  top: 10,
                  bottom: 10,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
            messageOptions: MessageOptions(
                showCurrentUserAvatar: false,
                showOtherUsersAvatar: true,
                currentUserContainerColor: Colors.red,
                onPressMessage: (message) {
                  var roomId = message.customProperties?["roomId"];
                  if(roomId != null && message.text.toLowerCase().contains("click to join the video room")){
                    connectController.joinTheVideoCall(roomId);
                  }
                },
                messageTextBuilder: (chatMessage, previousMessage, nextMessage) {
                  var isOwnMessage = chatMessage.user.id == user.id;
                  if (chatMessage.text.toLowerCase().contains("click to join the video room")) {
                    return Container(
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.videocam_rounded,
                                color: isOwnMessage ? Colors.white: Colors.black,
                              )),
                          Expanded(
                              flex: 5,
                              child: Text(
                                "Click to join the video room",
                                style: TextStyle(color: isOwnMessage ? Colors.white: Colors.black),
                              ))
                        ],
                      ),
                    );
                  }
                  return DefaultMessageText(
                      message: chatMessage, isOwnMessage: isOwnMessage);
                }),
            currentUser: user,
            messages: asDashChatMessages(connectController.messages),
          );
        },
      )
    );
  }

  List<ChatMessage> asDashChatMessages(List<BaseMessage> messages) {
    // BaseMessage is a Sendbird class
    // ChatMessage is a DashChat class
    List<ChatMessage> result = [];
    if (messages != null) {
      messages.forEach((message) {
        if(message.sender == null){
          print("Message Sender is not available for ${message.message}");
          return;
      }
        User user = message.sender as User;
        log("User is ${user}");
        /*if (user == null) {
          return;
        }*/
        result.add(
          ChatMessage(
              createdAt: DateTime.fromMillisecondsSinceEpoch(message.createdAt),
              text: message.message,
              user: asDashChatUser(user),
              customProperties: {"roomId": message.data ?? ""}),
        );
      });
    }
    return result;
  }

  ChatUser asDashChatUser(User user) {
    return ChatUser(
      firstName: user.nickname,
      id: user.userId,
      profileImage: user.profileUrl,
    );
  }
}
