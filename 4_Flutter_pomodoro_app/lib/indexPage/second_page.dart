//dart 기본 패키지
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

//dart 편의 패키지
import 'package:google_fonts/google_fonts.dart';
import 'package:pomodoro_timer/notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class timerPage extends StatefulWidget {
  const timerPage({Key? key}) : super(key: key);

  @override
  _timerPageState createState() => _timerPageState();
}

class _timerPageState extends State<timerPage> {
  Timer timer = Timer(Duration(milliseconds: 1), () {});
  int countTime = 150001;
  bool isRunning = false;
  bool isRest = false;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        color: Color(isRest?0xff2E3C7E:0xffffff),
        child: _buildBody()
      )

    );
  }
  Widget _buildBody() {
    int minuteCount = countTime ~/ 6000;
    int secondCount = countTime ~/ 100;
    while(secondCount >= 60)
      secondCount -= 60;

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '$minuteCount:${secondCount >= 0 && secondCount < 10 ? '0$secondCount' : secondCount}',
                      style: GoogleFonts.nanumGothic(textStyle: TextStyle(fontSize: 100.0, fontWeight: FontWeight.w500, color: Color(isRest?0xffffffff:0xff2E3C7E))),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              left: 10,
              bottom: 20,
              child: FloatingActionButton(
                backgroundColor: Color(isRest?0xffffffff:0xff2E3C7E),
                onPressed: _clickResetButton,
                child: Icon(Icons.rotate_left, color: Color(isRest?0xff2E3C7E:0xffffffff)),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 20,
              child: FloatingActionButton(
                backgroundColor: Color(isRest?0xffffffff:0xff2E3C7E),
                onPressed: _clickPlayButton,
                child: Icon(isRunning? Icons.pause:Icons.play_arrow, color: Color(isRest?0xff2E3C7E:0xffffffff)),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _start() {
    timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        if(countTime == 100){
          print('finish');
          _pause();
          _changeTimerTheme();
        }
        countTime--;
      });
    });
  }

  void _pause() {
    timer.cancel();
  }
  void _clickPlayButton() {
    if(countTime >= 0){
      isRunning = !isRunning;
      if (isRunning) {
        _start();
      }
      else {
        _pause();
      }
    }
  }
  void _clickResetButton() {
    setState(() {
      if(isRest){
        isRunning = false;
        timer.cancel();
        countTime = 300;
      }
      else{
        isRest = false;
        isRunning = false;
        timer.cancel();
        countTime = 300;
      }
    });
  }

  void _changeTimerTheme(){
    if(!isRest){
      isRunning = false;
      isRest = true;
      countTime = 30001;
      showNotification1();
    }
    else{
      isRunning = false;
      isRest = false;
      countTime = 150001;
      showNotification2();
    }
  }

  showNotification1() async {

    var androidDetails = AndroidNotificationDetails(
      '유니크한 알림 채널 ID',
      '알림종류 설명',
      priority: Priority.high,
      importance: Importance.max,
      color: Color.fromARGB(255, 255, 0, 0),
    );

    var iosDetails = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // 알림 id, 제목, 내용 맘대로 채우기
    notifications.show(
        1,
        '멋진 집중 시간이였어요!',
        '조금 쉬는 시간을 가져 볼까요?',
        NotificationDetails(android: androidDetails, iOS: iosDetails)
    );
  }

  showNotification2() async {

    var androidDetails = AndroidNotificationDetails(
      '유니크한 알림 채널 ID',
      '알림종류 설명',
      priority: Priority.high,
      importance: Importance.max,
      color: Color.fromARGB(255, 255, 0, 0),
    );

    var iosDetails = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // 알림 id, 제목, 내용 맘대로 채우기
    notifications.show(
        1,
        '다시 한번 집중 해볼까요?',
        '충분히 쉬었어요. 타이머를 다시 실행 할 수 있어요!',
        NotificationDetails(android: androidDetails, iOS: iosDetails)
    );
  }
}



