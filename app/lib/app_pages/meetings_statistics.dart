import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firebase_database/firebase_database.dart';

void main() => runApp(MeetingRoomApp());

class MeetingRoomApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meeting Room Usage',
      home: MeetingRoomStatistics(),
    );
  }
}

class MeetingRoomStatistics extends StatefulWidget {
  @override
  _MeetingRoomStatisticsState createState() => _MeetingRoomStatisticsState();
}

class _MeetingRoomStatisticsState extends State<MeetingRoomStatistics> {
  late List<Statistics> _chartData = [];

  @override
  void initState() {
    super.initState();
    getStats(); // fetching all global counters and calculate it
  }

   Future<int> _getStatisticsCounter(int i) async{
    DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    DataSnapshot snapshot = await dbRef.child("rooms").child("counter$i").get(); // fetching the needed counters ( specific hour)
    int counter = 0 ;
      if (snapshot.value is int) {
        
        counter = snapshot.value as int;
        return counter;
      }
      return counter;
  }

    Future<int> _getcntrall() async{ // fetching the global counter for all the hours
    DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    DataSnapshot snapshot = await dbRef.child("rooms").child("counterAll").get();
    int counter = 0 ;
      if (snapshot.value is int) {
        
        counter = snapshot.value as int;
        
        return counter;
      }
      return counter;
  }

  void getStats() async { // fetching all global counters and calculate it
  List<Statistics> stats = [];
  for (int i = 0; i < 24; i++) {
    int cntr_i = await _getStatisticsCounter(i);
    int cntr_all = await _getcntrall();
     final randomPercentage;
    if (cntr_all == 0)
    {
      randomPercentage=0;
    }
    else
    {
      randomPercentage = (cntr_i/cntr_all).toDouble() * 100;
    }


    stats.add(Statistics('$i:00', randomPercentage));
  }



  setState(() {
    _chartData = stats;
  });
}

  @override
  Widget build(BuildContext context) { // display statistics
    return Scaffold(
      appBar: AppBar(title: Text('Meeting Room Statistics')),
      body: SfCartesianChart(
        title: ChartTitle(text: 'Hourly Meeting Room Usage'),
        legend: Legend(isVisible: false),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(minimum: 0, maximum: 100),
        series: <CartesianSeries>[
          BarSeries<Statistics, String>(
            dataSource: _chartData,
            xValueMapper: (Statistics data, _) => data.hour,
            yValueMapper: (Statistics data, _) => data.percentage,
          )
        ],
      ),
    );
  }


}

class Statistics { // statistics class
  Statistics(this.hour, this.percentage);

  final String hour;
  final double percentage;
}
