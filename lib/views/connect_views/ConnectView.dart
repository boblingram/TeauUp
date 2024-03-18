import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';
import 'package:sizer/sizer.dart';
import 'package:teamup/utils/app_Images.dart';
import 'package:teamup/views/connect_views/DetailedConnectView.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../utils/GoalIconandColorStatic.dart';
import '../../widgets/ErrorListWidget.dart';

class ChannelListView extends StatefulWidget {
  const ChannelListView({Key? key}) : super(key: key);

  @override
  ChannelListViewState createState() => ChannelListViewState();
}

class ChannelListViewState extends State<ChannelListView>
    with ChannelEventHandler {
  Future<List<GroupChannel>> getGroupChannels() async {
    try {
      final query = GroupChannelListQuery()
        ..includeEmptyChannel = true
        ..order = GroupChannelListOrder.latestLastMessage
        ..limit = 15;
      return await query.loadNext();
    } catch (e) {
      print('getGroupChannels: ERROR: $e');
      return [];
    }
  }
  @override
  void initState() {
    super.initState();
    SendbirdSdk().addChannelEventHandler('channel_list_view', this);
  }

  @override
  void dispose() {
    SendbirdSdk().removeChannelEventHandler("channel_list_view");
    super.dispose();
  }

  @override
  void onChannelChanged(BaseChannel channel) {
    setState(() {
      // Force the list future builder to rebuild.
    });
  }

  @override
  void onChannelDeleted(String channelUrl, ChannelType channelType) {
    setState(() {
      // Force the list future builder to rebuild.
    });
  }

  @override
  void onUserJoined(GroupChannel channel, User user) {
    setState(() {
      // Force the list future builder to rebuild.
    });
  }

  @override
  void onUserLeaved(GroupChannel channel, User user) {
    setState(() {
      // Force the list future builder to rebuild.
    });
    super.onUserLeaved(channel, user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: navigationBar(),
      body: body(context),
    );
  }
  PreferredSizeWidget navigationBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: BackButton(color: Theme.of(context).primaryColor),
      title: const Text(
        'Channels',
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        Container(
          width: 60,
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create_channel');
              },
              child: Image.asset("assets/iconCreate.png")),
        ),
      ],
    );
  }

  Widget body(BuildContext context) {
    return FutureBuilder(
      future: getGroupChannels(),
      builder: (context, snapshot) {
        if (snapshot.hasData == false || snapshot.data == null) {
          // Nothing to display yet - good place for a loading indicator
          return Container(
            width: 100.w,
              color: Colors.white,
              height: 100.h,
              child: ListLoadingWidget());
        }

        if(snapshot.data!.isEmpty){
          return Container(
            color:Colors.white,
            width: 100.w,
            padding: EdgeInsets.fromLTRB(0, 10.h, 0, 0),
            child: Column(
              children: [
                Image.asset(AppImages.noConversationImage,width: 50.w,height: 50.w,),
                Text("You do not have any conversation yet.")
              ],
            ),
          );
        }
        print("Channel Length is ${snapshot.data?.length}");
        List<GroupChannel> channels = snapshot.data as List<GroupChannel>;

        return Container(
          color: Colors.white,
          child: ListView.builder(
              itemCount: channels.length,
              itemBuilder: (context, index) {
                GroupChannel channel = channels[index];
                print("Time is ${channel.lastMessage?.createdAt}");
                String timeAgoText = "";
                if(channel.lastMessage?.createdAt != null){
                  var tempDate = DateTime.fromMillisecondsSinceEpoch(channel.lastMessage?.createdAt ?? 0);
                  timeAgoText = timeago.format(tempDate);
                }

                //channel.getMetaData(keys)
                var channelGoalType = channel.getMetaData(['goaltype']);
                if (channelGoalType.runtimeType != String || channelGoalType.toString().isEmpty){
                }

                print("Channel Goal Type is ${channelGoalType} and Channel name is ${channel.name}");
                return InkWell(
                  onTap: (){
                    gotoChannel(channel.channelUrl);
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(2.w, 5, 2.w, 5),
                    child: Column(
                      children: [
                        Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 12.w,
                              width: 12.w,
                              child: Image.asset(GoalIconandColorStatic.getImageName("Teamup")),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 2.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    //channel.getMetaData(keys) - goaltype is key name
                                    Expanded(
                                      flex: 2,
                                      child: Text(channel.name ?? ([for (final member in channel.members) member.nickname]
                                          .join(", ")),maxLines: 1,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14.sp),),
                                    ),
                                    Expanded(flex: 1,child: Text(timeAgoText,textAlign: TextAlign.right,))
                                  ],
                                ),
                                SizedBox(height: 1.h,),
                                Text(channel.lastMessage?.message ?? ''),
                              ],
                            ),
                          ),
                        ],
                  ),
                        Container(height: 1,color: Colors.grey.shade300,margin: EdgeInsets.fromLTRB(17.w, 1.h, 0, 3),)
                      ],
                    ),),
                );

                return ListTile(
                  // Display all channel members as the title
                  title: Text(
                    [for (final member in channel.members) member.nickname]
                        .join(", "),
                  ),
                  // Display the last message presented
                  subtitle: Text(channel.lastMessage?.message ?? ''),
                  onTap: () {
                    gotoChannel(channel.channelUrl);
                  },
                );
              }),
        );
      },
    );
  }

  void gotoChannel(String channelUrl) {

    print("Channel URL is $channelUrl");
    //Navigate to Chat View
    GroupChannel.getChannel(channelUrl).then((channel) {
      Get.to(()=>GroupChannelView(groupChannel: channel));
      /*Navigator.pushNamed(context, '/channel_list');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GroupChannelView(groupChannel: channel),
        ),
      );*/
    }).catchError((e) {
      //handle error
      print('channel_list_view: gotoChannel: ERROR: $e');
    });
  }


}