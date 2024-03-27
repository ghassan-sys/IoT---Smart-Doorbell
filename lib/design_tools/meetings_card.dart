import 'package:flutter/material.dart';
import 'time/time.dart';

class MeetingTemplate extends StatefulWidget { // meeting card page used to display the meetings
  final meetings; // specific meeting
  final flag; // is it belong to allmeetings or my meetings page - used for setting the needed color
  final deleteIcon; // should add delete icon ?
  final VoidCallback toDelete; // VoidCallBack function to delete a meeting

  MeetingTemplate({
    required this.meetings,
    required this.flag,
    required this.deleteIcon,
    required this.toDelete,
  });

  @override
  _MeetingTemplateState createState() => _MeetingTemplateState();
}

class _MeetingTemplateState extends State<MeetingTemplate> {
  bool greaterThanCurr = false;

  @override
  void initState() {
    super.initState();
    _checkTime();
  }

  Future<void> _checkTime() async {
    bool isGreaterThan = await isTimeGreaterThanCurrent( // checking if the current time bigger than specific meeting to not add the delete icon
        doubleToTimeString(widget.meetings.start / 60));
    setState(() {
      greaterThanCurr = isGreaterThan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                '${widget.meetings.name}  ${doubleToTimeString(widget.meetings.start / 60)} - ${doubleToTimeString(widget.meetings.end / 60)} ', // display the meeting
                style: TextStyle(
                  fontSize: 20.0,
                  color: widget.flag ? Colors.green : Colors.pink,
                ),
              ),
              const SizedBox(height: 8,),
              widget.deleteIcon && greaterThanCurr // if the meeting already passed shouldn't add delete Icon since it already passed
                  ? ElevatedButton.icon(
                      onPressed: widget.toDelete,
                      icon: Icon(Icons.delete),
                      label: Text('delete meeting !!'),
                    )
                  : const SizedBox(height: 8,),
            ],
          ),
        ));
  }
}
