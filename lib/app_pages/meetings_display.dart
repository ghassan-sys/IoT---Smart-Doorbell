import 'package:flutter/material.dart';
import 'pick_time.dart';
import '../design_tools/meetings_card.dart';
import '../design_tools/time/time.dart';

class Meeting extends StatefulWidget {
  final String uid;
  const Meeting({Key? key, required this.uid}) : super(key: key);
  @override
  State<Meeting> createState() => _MeetingState();
}

class _MeetingState extends State<Meeting> {
  List<MeetingModel> usersList = [];

  @override
  void initState() {
    super.initState();
    deletePastMeetingAndFetchOrderedList(); // delete the passed meeting that aren't for today
  }

  void fetchOrderedList() async { // fetch all meeting and order it based on start time
    List<MeetingModel> data = await getAllMeetings();
    List<MeetingModel> orderedData = orderMeetingModelsByStart(data);
    setState(() {
      usersList = orderedData;
    });
  }

  void deletePastMeetingAndFetchOrderedList() async // delete passed meeting
  {
    int dayOfYear = await getDayOfTheYear();
    await deletePastMeetings(dayOfYear);
    fetchOrderedList();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text('Meetings'),
      centerTitle: true,
      backgroundColor: Colors.pink,
    ),
    body: SingleChildScrollView(
        child: Column(
          children: usersList
              .map(
                (ppl) => MeetingTemplate(
                  meetings: ppl,
                  flag: ppl.uid == widget.uid,
                  deleteIcon: false,
                  toDelete: () {
                    setState(() {
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
