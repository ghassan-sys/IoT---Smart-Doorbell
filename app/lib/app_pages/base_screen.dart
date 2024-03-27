import 'package:first_flutter_proj/app_pages/pick_time.dart';
import 'package:first_flutter_proj/app_pages/meetings_display.dart';
import 'package:first_flutter_proj/app_pages/meetings_statistics.dart';
import 'package:first_flutter_proj/app_pages/my_metings_disp.dart';
import 'profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../design_tools/icons.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../design_tools/time/time.dart';
import '../design_tools/toast.dart';
class BaseScreen extends StatefulWidget { // display and control the bar panel , when choosing to navigate to other page modify icons
  final User userBase;
  const BaseScreen({Key? key, required this.userBase}) : super(key: key);
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;
  late User user;
  late List<Widget> _widgetOptions;
  @override
  void initState() {
    super.initState();
    user = widget.userBase;
    _widgetOptions = [
    HomePage(userhome: user),
    MyMeeting(uid: user.uid),
    Meeting(uid: user.uid),
    MeetingRoomStatistics(),
    ProfileScreen(user : user),
    ];
    deletePastMeeting(); // delete all past meeting ( it should display only today meetings)

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  if (notification != null && notification.body != null) {
    showToast(message: notification.body!); // getting notification inside the app
  }
  });


  }

    void deletePastMeeting() async
  {
    int dayOfYear = await getDayOfTheYear(); // checking which day of the year we are , to decide if should delete the meeting
    await deletePastMeetings(dayOfYear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.pink,
          backgroundColor: Colors.white,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              activeIcon: Image.asset(
                addmeeting,
                height: 20,
              ),
              icon: Image.asset(
                addmeetingOutlined,
                height: 20,
              ),
              label: "Add meeting",
            ),
            BottomNavigationBarItem(
              activeIcon: Image.asset(
                myownmeeting,
                height: 20,
              ),
              icon: Image.asset(
                mymeetin_outline,
                height: 20,
              ),
              label: "My meetings",
            ),
            BottomNavigationBarItem(
              activeIcon: Image.asset(
                room,
                height: 40,
              ),
              icon: Image.asset(
                room_outline,
                height: 40,
              ),
              label: " all meetings",
            ),
            BottomNavigationBarItem(
              activeIcon: Image.asset(
                stats,
                height: 40,
              ),
              icon: Image.asset(
                stats_outline,
                height: 40,
              ),
              label: " Statistics",
            ),
            BottomNavigationBarItem(
              activeIcon: Image.asset(
                profile,
                height: 40,
              ),
              icon: Image.asset(
                profile_outline,
                height: 40,
              ),
              label: "profile",
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index; // change the pressed button to not outline icon
            });
          }),
    );
  }
}