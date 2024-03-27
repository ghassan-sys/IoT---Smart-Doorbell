import 'package:firebase_database/firebase_database.dart';
import '../design_tools/form_container_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../design_tools/time/time.dart';
import '../design_tools/toast.dart';
import '../auth_notification/firebase_api.dart';

class HomePage extends StatefulWidget {
  final User userhome;
  const HomePage({Key? key, required this.userhome}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _comment = TextEditingController();

  TimeOfDay _startmeeting = TimeOfDay(hour: 8, minute: 30);
  TimeOfDay _endtmeeting = TimeOfDay(hour: 10, minute: 30);
  bool pickedTimestart = false;
  bool pickedTimeennd = false;

  // show time picker method
  void _showTimePickerstart() { // pickup time and display it
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      setState(() {
        pickedTimestart = true;
        _startmeeting = value!;
      });
    });
  }


  void _showTimePickerend() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      setState(() {
        pickedTimeennd = true;
        _endtmeeting = value!;
      });
    });
  }

  String timeOfDayToString(TimeOfDay time) { // casting from TimeofDAy to string
  final hour = time.hour;
  final minute = time.minute.toString().padLeft(2, '0');
  return "${hour.toString().padLeft(2, '0')}:${minute}";
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Room 1 - Add your meetings"),
          titleTextStyle : const TextStyle(
          fontSize: 20.0 ,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
          color: Colors.pink,
          fontFamily: 'ProtestRiot',
      )

        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
            MaterialButton(
              onPressed: _showTimePickerstart,
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('PICK MEETING START TIME',
                    style: TextStyle(color: Colors.white, fontSize: 15)),
              ),
              color: Colors.pink,
            ),
            Text(
              pickedTimestart ? 
              timeOfDayToString(_startmeeting) : "HH:MM",
              style: TextStyle(fontSize: 50),
            ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
            MaterialButton(
              onPressed: _showTimePickerend,
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('PICK MEETING END  TIME',
                    style: TextStyle(color: Colors.white, fontSize: 15)),
              ),
              color: Colors.pink,
            ),
            Text(
              pickedTimeennd ? 
              timeOfDayToString(_endtmeeting) : "HH:MM",
              style: TextStyle(fontSize: 50),
            ),
              const SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _comment,
                hintText: "put your comment (optional)",
                isPasswordField: false,
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: () {
                  String ret_name;
                  if(checkTimeInputValid(timeOfDayToString(_startmeeting),timeOfDayToString(_endtmeeting)) == false)
                  {
                      showToast(message: "Failed to add meeting , pick a valid time!!");
                  }
                  else
                  {
                    
                  
                  getUserData(widget.userhome.uid).then((value) {
                  ret_name = value;
                  bool GreaterThanCurrent = false;
                  isTimeGreaterThanCurrent(timeOfDayToString(_startmeeting)).then((value) { // check if the choosen start meeting isn't passed
                  GreaterThanCurrent = value;
                  MeetingModel newmeeting;
                  if (GreaterThanCurrent)
                  {
                    
                    initNotifications().then((value) { // getting token and that to pop notification for the same device ( user )added the meeting
                    newmeeting = MeetingModel(
                    name: ret_name,
                    start: timeStringToDouble(timeOfDayToString(_startmeeting))*60,
                    end: timeStringToDouble(timeOfDayToString(_endtmeeting))*60,
                    comment: _comment.text,
                    uid: widget.userhome.uid,
                    todelete: false,
                    key: 0,
                    deviceToken: value 
                  );
                  bool flag;
                 checkAvailability(newmeeting).then((result) { // check if the room is available in the chosen time
                  flag=result;

                  if(flag)
                  {
                    _createMeeting(newmeeting); // add new meeting
                    showToast(message: "Successfully meeting added");
                  }
                else
                {
                  showToast(message: "Failed to add meeting , choose another time!!");
                }

                });


                });

                }
                else
                {
                  showToast(message: "Failed to add meeting the the time you choose already passed");
                }

                  });

                  });
                }
                },
                child: Container(
                  height: 60,
                  width: 400,
                  decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "insert meeting",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
  }

  Future<void> updateStatistics(double start , double end, bool add)async { //updating statistics if added or removed meeting
    DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    int counterall = await _getcntrall();
    for(int i=0 ; i < 24 ; i++)
    {
      if(i >= start.toInt() &&  i.toDouble() < end.toDouble())
      {
        int cntr = await _getStatisticsCounter(i);
        if(add)
        {
          cntr+=1;
          counterall+=1;
        }
        else{
          cntr-=1;
          counterall-=1;
        }
        await dbRef.child("rooms").child("counter$i").set(cntr).then((value) => null);
      }
      await dbRef.child("rooms").child("counterAll").set(counterall).then((value) => null);
    }

  }


  void _createMeeting(MeetingModel meetingModel)async { // build new meeting and storing it in FB RT
    DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    int cntr = await _getcntr();
    String? deviceToken = await initNotifications();
    int key=cntr+1;
    Map<String,dynamic> data = {
      "name": meetingModel.name.toString(),
      "start": meetingModel.start.toDouble(),
      "end":   meetingModel.end.toDouble(),
      "comment": meetingModel.comment.toString(),
      "uid": meetingModel.uid.toString(),
      "todelete": meetingModel.todelete,
      "key": key.toInt(),
      "deviceToken" : deviceToken.toString(),
    };
    String id_cntr=(cntr+1).toString();
    dbRef.child("rooms").child("meetings").child(id_cntr).set(data).then((value) => null);
    dbRef.child("rooms").child("cntr").set(cntr+1).then((value) => null);
    await updateStatistics(meetingModel.start / 60 , meetingModel.end/ 60,true);
  }
  




  Future<int> _getcntr() async{ // fetching counter that means how many meetings have been added today
    DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    DataSnapshot snapshot = await dbRef.child("rooms").child("cntr").get();
    int counter = 0 ;
      if (snapshot.value is int) {
        counter = snapshot.value as int;

        return counter;
      }
      return counter;
  }


    Future<int> _getcntrall() async{ // fetching counterall that means how many meeting occured from the begining of the app
    DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    DataSnapshot snapshot = await dbRef.child("rooms").child("counterAll").get();
    int counter = 0 ;
      if (snapshot.value is int) {
        
        counter = snapshot.value as int;
        return counter;
      }
      return counter;
  }


    Future<int> _getStatisticsCounter(int i) async{ // fetching counterX that means how many meeting occured from the begining of the app in this X hour
    DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    DataSnapshot snapshot = await dbRef.child("rooms").child("counter$i").get();
    int counter = 0 ;
      if (snapshot.value is int) {
        counter = snapshot.value as int;
        return counter;
      }
      return counter;
  }

Future<bool> checkAvailability(MeetingModel newmeeting) async { // checking if there is no meet in giving time and the room is avaialble 
  bool flag = true;

  try {
    List<MeetingModel> currentList = await getAllMeetings();

    currentList.forEach((element) {
      if (newmeeting.start >= element.start && newmeeting.start < element.end ||
          newmeeting.end > element.start && newmeeting.end <= element.end) {
        flag = false;
      }
    });
    return flag;
  } catch (e) {
    // Handle errors if any
    print("Error checking availability: $e");
    return false;
  }
}


Future<List<MeetingModel>> getAllMyMeetings(String uid) async // fetching all the meetings that belong to given user ( with specific uid)
{
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  
  try {
    DataSnapshot datasnap = await dbRef.child("rooms").child("meetings").get();
    List<dynamic> dataList = [] ;
    List<MeetingModel> users = [];
      if (datasnap.value is List) {
        dataList = datasnap.value as List<dynamic>;
      }
        for (dynamic item in dataList) {
          if (item is Map<dynamic, dynamic>) {
            MeetingModel meetingModel = MeetingModel.fromSnapshot(item);
            if (meetingModel.uid == uid && meetingModel.todelete == false) // to check if its deleted
            {
              users.add(meetingModel);
            }
          }
        }
      return users;
  } catch (error) {
    print('Error retrieving documents: $error');
    // Return an empty list or handle the error accordingly
    return [];
  }
}

List<MeetingModel> orderMeetingModelsByStart(List<MeetingModel> meetingModels) { // order the meeings basic in start time
  meetingModels.sort((a, b) => a.start.compareTo(b.start));
  return meetingModels;
}

  Future<List<MeetingModel>> getAllMeetings() async { // fetching all meetings
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  
  try {
    DataSnapshot datasnap = await dbRef.child("rooms").child("meetings").get();
    List<dynamic> dataList = [] ;
    List<MeetingModel> users = [];
      if (datasnap.value is List) {
        dataList = datasnap.value as List<dynamic>;
      }
        for (dynamic item in dataList) {
          if (item is Map<dynamic, dynamic>) {
            MeetingModel meetingModel = MeetingModel.fromSnapshot(item);
            if(meetingModel.todelete == false)
            {
              users.add(meetingModel);
            }
          }
        }
      return users;
  } catch (error) {
    print('Error retrieving documents: $error');
    // Return an empty list or handle the error accordingly
    return [];
  }
}


  Future<void> deletePastMeetings(int todayDayOfYear) async{ // if the meeting already passed and don't belong to today meetings , should delete them
    DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    DataSnapshot snapshot = await dbRef.child("rooms").child("day_of_year").get();
    int dayOfyear = 0 ;
    if (snapshot.value is int) {

        
      dayOfyear = snapshot.value as int;
    }
    if(dayOfyear !=todayDayOfYear)
    {
      await dbRef.child("rooms").child("meetings").remove();
      await dbRef.child("rooms").child("day_of_year").set(todayDayOfYear).then((value) => null);
      await dbRef.child("rooms").child("cntr").set(0).then((value) => null);

    }
    
  }


  Future<String> getUserData(String uid) async { // fetch user
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  DataSnapshot snapshot = await dbRef.child("Users").child(uid).child("name").get();
   String name = "";
      if (snapshot.value is String) {
        name = snapshot.value as String;
      
        return name;
      }
      return name;
}

  void setTodelete(MeetingModel user) async{ // delete meetings
    DatabaseReference dbRef = FirebaseDatabase.instance.ref();

    await dbRef.child("rooms").child("meetings").child(user.key.toString()).child("todelete").set(true).then((value) => null);
    await updateStatistics(user.start /60, user.end / 60,false);

  }

class MeetingModel {
  final String name;
  final double start;
  final double end;
  final String? comment;
  final String uid;
  final bool todelete;
  final int key;
  final String? deviceToken;

  MeetingModel({
    // required this.id,
    required this.name,
    required this.start,
    required this.end,
    this.comment,
    required this.uid,
    required this.todelete,
    required this.key,
    this.deviceToken,
  });

  factory MeetingModel.fromSnapshot(Map<dynamic, dynamic> data) { // fetching meeting
    return MeetingModel(
      // id: snapshot.key as String,
      name: data['name'] as String,
      start: data['start'].toDouble() as double,
      end: data['end'].toDouble() as double,
      comment: data['comment'] as String,
      uid: data['uid'] as String,
      todelete:  data['todelete'],
      key: data['key'] as int,
      deviceToken :  data['deviceToken'] as String,
    );
  }
}





