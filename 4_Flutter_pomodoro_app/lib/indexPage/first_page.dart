//dart 기본 패키지
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//dart chart 패키지
import 'package:syncfusion_flutter_charts/charts.dart';

//dart firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';



class analyzePage extends StatefulWidget {
  const analyzePage({Key? key}) : super(key: key);

  @override
  State<analyzePage> createState() => _analyzePageState();
}


class _analyzePageState extends State<analyzePage> {
  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  ChartSeriesController? _chartSeriesController;
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  List<ChartData> chartData = [];
  getTimeData() async{
    try{
      var result = await firestore.collection('analyzeData').get();
      for(var doc in result.docs){
        print(doc['result']);
        setState(() {
          chartData.add(ChartData(doc['result'][0], doc['result'][1]));
        });
      }
    }
    catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      // Enables pinch zooming
        enableMouseWheelZooming : true,
        enablePinching: true,
    );
    _tooltipBehavior =  TooltipBehavior(enable: true);
    getTimeData();
    // TODO: implement initState
    super.initState();
  }
  @override

  Widget build(BuildContext context) {
    if(auth.currentUser?.uid == null){
      return SizedBox.expand(
        child: Center(
            child: Text('로그인이 필요한 페이지입니다.'),
        ),
      );
    }
    else{
      return SizedBox.expand(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(onPressed: (){}, child: Text('dd')),
                  TextButton(onPressed: (){
                    setState(() {
                      chartData.add(ChartData(322,23));
                      _chartSeriesController?.updateDataSource(
                        addedDataIndexes: <int>[chartData.length - 1],
                        removedDataIndexes: <int>[0],
                      );
                    });

                  }, child: Text('dd'))
                ],
              ),
              SfCartesianChart(
                // Initialize category axis
                  title: ChartTitle(text: '지난 집중 시간 기록'),
                  zoomPanBehavior: _zoomPanBehavior,
                  tooltipBehavior: _tooltipBehavior,
                  primaryXAxis: CategoryAxis(),
                  series: <ChartSeries>[
                    // Initialize line series
                    LineSeries<ChartData, num>(
                        name:'날짜',
                        enableTooltip: true,
                        dataSource: chartData,
                        xValueMapper: (ChartData days, _) => days.day,
                        yValueMapper: (ChartData days, _) => days.sales,
                        dataLabelSettings:DataLabelSettings(isVisible : true)
                    )
                  ]
              )
            ],
          )
      );
    }
  }
}

class ChartData {
  ChartData(this.day, this.sales);
  final num day;
  final int? sales;
}