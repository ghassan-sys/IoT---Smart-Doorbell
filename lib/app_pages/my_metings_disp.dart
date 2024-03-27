import 'package:flutter/material.dart';
import 'pick_time.dart';
import '../design_tools/meetings_card.dart';
import '../design_tools/time/time.dart';

class MyMeeting extends StatefulWidget {
  final String uid;

  const MyMeeting({Key? key, required this.uid}) : super(key: key);

  @override
  State<MyMeeting> createState() => _MyMeetingState();
}

class _MyMeetingState extends State<MyMeeting> {
  List<MeetingModel> usersList = [];

  @override
  void initState() {
    super.initState();
    deleteThePastMeetingAndFetchOrderList(); // delete all passed meetings that are not for today
  }

  void fetchOrderedList() async {
    List<MeetingModel> data = await getAllMyMeetings(widget.uid);
    List<MeetingModel> orderedData = orderMeetingModelsByStart(data);
    setState(() {
      usersList = orderedData;
    });
  }

  void deleteThePastMeetingAndFetchOrderList() async {
    int dayOfYear = await getDayOfTheYear();
    await deletePastMeetings(dayOfYear);
    fetchOrderedList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Meetings'),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: usersList
              .map(
                (meet) => MeetingTemplate(
                  meetings: meet,
                  flag: true,
                  deleteIcon: true,
                  toDelete: () {
                    setState(() {
                      setTodelete(meet);
                      usersList.remove(meet);
                    });
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
