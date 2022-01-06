import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message){
  Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
      fontSize: 13.0,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      webShowClose: true,
      webBgColor: 'FF0000',
      webPosition: 'center'
  );
}

void main() {
  runApp(
      MaterialApp(
        theme: style.theme,
        home: MyApp(),
      ));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var underIndex = 0;
  var data = [];

  @override
  getData() async{
    var semiData = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    if(semiData.statusCode == 200){
      var serverData = (jsonDecode(semiData.body));
      setState(() {
        data = serverData;
      });
    }
    else{
      showToast('잘못 된 요청입니다.');
    }
  }
  void initState(){
    super.initState();
    getData();
    showToast('Data Access');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(
        icon: Image.asset('AppBarSvg.png'),
        onPressed: (){},
        ),
        leadingWidth: 160,
        toolbarHeight: 65,
        actions: [Row(
          children: [IconButton(icon:Icon(Icons.add_box_outlined), onPressed: (){}, iconSize: 32,),
            IconButton(icon:Icon(Icons.favorite_border), onPressed: (){},iconSize: 32,),
            IconButton(icon:Icon(Icons.label_important_outline_rounded), onPressed: (){},iconSize: 32,),],
        )],
      ),

      body: [HomeKey(data: data), Text('2'),Text('3'),Text('4'),Text('5')][underIndex],

      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i){
          setState(() {
            underIndex = i;
          });
        },
        items:[
          BottomNavigationBarItem(icon: underIndex == 0 ? Icon(Icons.home) : Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: underIndex == 1 ? Icon(Icons.search) : Icon(Icons.search_outlined), label: '검색'),
          BottomNavigationBarItem(icon: underIndex == 2 ? Icon(Icons.movie_creation) : Icon(Icons.movie_creation_outlined), label: '쇼츠'),
          BottomNavigationBarItem(icon: underIndex == 3 ? Icon(Icons.shopping_bag) : Icon(Icons.shopping_bag_outlined), label: '쇼핑'),
          BottomNavigationBarItem(icon: Icon(Icons.person_pin), label: '프로필'),
        ]
      )
    );
  }
}


class HomeKey extends StatelessWidget {
  const HomeKey({Key? key, this.data}) : super(key: key);

  final data;

  @override
  Widget build(BuildContext context) {
    if(data.isNotEmpty){
      return ListView.builder(itemCount: 3,itemBuilder: (c,i){
        return Column(
          children: [
            Image.network(data[i]['image']),
            Container(
              constraints: BoxConstraints(maxWidth: 600),
              padding: EdgeInsets.all(15),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text('좋아요 ${data[0]['likes']}개'),
                  Text.rich(TextSpan(
                      children: [
                        TextSpan(text: data[i]['user'], style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' ${data[i]['content']}', )
                      ]
                  ))
                ],
              ),
            )
          ],
        );
      });
    } else{
      return Center(child: CircularProgressIndicator());
    }
  }
}
