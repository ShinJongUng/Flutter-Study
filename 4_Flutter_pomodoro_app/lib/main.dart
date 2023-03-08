//dart 기본 패키지
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//dart 편의 패키지
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'notification.dart';

//dart firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

//dart sub
import 'mainStyle.dart' as mainStyle;
//dart indexPage 폴더
import 'indexPage/first_page.dart';
import 'indexPage/second_page.dart';
import 'indexPage/third_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MaterialApp(
      theme: mainStyle.mainTheme,
      home: MyApp()
    ),
  );
}


class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  @override

  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  var pageIndex = 0;
  PageController pageController = PageController( initialPage: 1, keepPage: true );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initNotification();

    pageIndex = 1;
  }

  void pageChanged(int index) {
    setState(() {
      pageIndex = index;
    });
  }
  void bottomTapped(int index) {
    setState(() {
      pageIndex = index;
      pageController.animateToPage(index, duration: Duration(milliseconds: 1), curve: Curves.ease);
    });
  }
  @override
  Widget build(BuildContext context) {

    MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: mainAppBar(),
      body: mainBody(pageChanged:pageChanged, pageController:pageController),
      bottomNavigationBar: mainBottomBar(pageIndex:pageIndex, bottomTapped:bottomTapped),
    );
  }
}


class mainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const mainAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(50.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Focus it"),
    );
  }
}

class mainBody extends StatefulWidget {
  mainBody({Key? key, this.pageChanged, this.pageController}) : super(key: key);

  final pageChanged;
  final pageController;

  @override
  State<mainBody> createState() => _mainBodyState();
}

class _mainBodyState extends State<mainBody> {



  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: widget.pageController,
      onPageChanged: (value){
        setState(() {
          widget.pageChanged(value);
        });
      },
      children: const[
        analyzePage(),
        timerPage(),
        accountPage(),
      ],
    );
  }
}




class mainBottomBar extends StatefulWidget {
  const mainBottomBar({Key? key, this.pageIndex, this.bottomTapped}) : super(key: key);
  final pageIndex;
  final bottomTapped;

  @override
  State<mainBottomBar> createState() => _mainBottomBarState();
}

class _mainBottomBarState extends State<mainBottomBar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        showUnselectedLabels: false,
        items: [
      BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: '통계'),
      BottomNavigationBarItem(icon: Icon(Icons.schedule), label: '타이머'),
      BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: '계정'),
    ], currentIndex: widget.pageIndex,
      onTap: (index){
        widget.bottomTapped(index);
      });
  }
}




