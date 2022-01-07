import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:photofilters/photofilters.dart';



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
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  var underIndex = 0;
  var data = [];
  var userImage;
  var userContent;

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

  getNewData1() async{
    var semiData = await http.get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    if(semiData.statusCode == 200){
      var newData = (jsonDecode(semiData.body));
      setState(() {
        data.add(newData);
      });
    }
  }

  getNewData2() async{
    var semiData = await http.get(Uri.parse('https://codingapple1.github.io/app/more2.json'));
    if(semiData.statusCode == 200){
      var newData = (jsonDecode(semiData.body));
      setState(() {
        data.add(newData);
      });
    }
  }

  void initState(){
    super.initState();
    getData();
    showToast('Data Access');
  }

  bottomWidgetSetState(i){
    setState(() {
      underIndex = i;
    });
  }

  setUserContent(a){
    setState(() {
      userContent = a;
    });
  }

  addMyData(){
    var myData = {
      'id': data.length,
      'image': userImage,
      'likes': 5,
      'date': 'Today',
      'content': userContent,
      'liked': false,
      'user': 'JongungShin'
    };
    setState(() {
      data.insert(0, myData);
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(
        icon: Image.asset('assets/AppBarSvg.png'),
        onPressed: (){},
        ),
        leadingWidth: 160,
        toolbarHeight: 60,
        actions: [Row(
          children: [IconButton(icon:Icon(Icons.add_box_outlined), onPressed: () async{
            var picker = ImagePicker();
            var image = await picker.pickImage(source: ImageSource.gallery);
            if(image != null) {
              setState(() {
                userImage = File(image.path);
              });
            }
            Navigator.push(context,
              MaterialPageRoute(builder: (c) => UploadKey(userImage:userImage, setUserContent:setUserContent, addMyData:addMyData))
            );
          }, iconSize: 28,),
            IconButton(icon:Icon(Icons.favorite_border), onPressed: (){},iconSize: 28,),
            IconButton(icon:Icon(Icons.label_important_outline_rounded), onPressed: (){},iconSize: 28,),],
        )],
      ),

      body: [HomeKey(data: data, getNewData1 : getNewData1, getNewData2 : getNewData2), Text('2'), Text('3'), Text('4'), Text('5')][underIndex],

      bottomNavigationBar: BottomWidget(underIndex: underIndex, bottomWidgetSetState : bottomWidgetSetState)
    );
  }
}


class BottomWidget extends StatefulWidget {
  BottomWidget({Key? key, this.underIndex, this.bottomWidgetSetState}) : super(key: key);
  final bottomWidgetSetState;
  var underIndex;

  @override
  State<BottomWidget> createState() => _BottomWidgetState();
}

class _BottomWidgetState extends State<BottomWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,

        onTap: (i){
          widget.bottomWidgetSetState(i);
        },
        items:[
          BottomNavigationBarItem(icon: widget.underIndex == 0 ? Icon(Icons.home) : Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: widget.underIndex == 1 ? Icon(Icons.search) : Icon(Icons.search_outlined), label: '검색'),
          BottomNavigationBarItem(icon: widget.underIndex == 2 ? Icon(Icons.movie_creation) : Icon(Icons.movie_creation_outlined), label: '쇼츠'),
          BottomNavigationBarItem(icon: widget.underIndex == 3 ? Icon(Icons.shopping_bag) : Icon(Icons.shopping_bag_outlined), label: '쇼핑'),
          BottomNavigationBarItem(icon: Icon(Icons.person_pin), label: '프로필'),
        ]
    );
  }
}



class HomeKey extends StatefulWidget {
  const HomeKey({Key? key, this.data, this.getNewData1, this.getNewData2}) : super(key: key);

  final data;
  final getNewData1;
  final getNewData2;


  @override
  State<HomeKey> createState() => _HomeKeyState();
}

class _HomeKeyState extends State<HomeKey> {


  var datacounter = 0;
  var scroll = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scroll.addListener(() { //스크롤 할때마다 확인
      if(scroll.position.pixels == scroll.position.maxScrollExtent && datacounter == 0){ //max에 다 달았을 경우
        widget.getNewData1();
        datacounter = 1;
      }
      else if(scroll.position.pixels == scroll.position.maxScrollExtent && datacounter == 1){
        widget.getNewData2();
        datacounter = 2;
      }
    });
  }
  @override

  Widget build(BuildContext context) {
    if(widget.data.isNotEmpty){
      return ListView.builder(itemCount: widget.data.length, controller: scroll, itemBuilder: (c,i){
        return Column(
          children: [
            widget.data[i]['image'].runtimeType == String? Image.network(widget.data[i]['image']): Image.file(widget.data[i]['image']),
            Container(
              constraints: BoxConstraints(maxWidth: 600),
              padding: EdgeInsets.all(15),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton( padding: EdgeInsets.fromLTRB(0, 0, 10, 5), constraints: BoxConstraints(), onPressed: (){}, icon: Icon(Icons.favorite_border), iconSize: 20, ),
                      IconButton( padding: EdgeInsets.fromLTRB(0, 0, 10, 5), constraints: BoxConstraints(), onPressed: (){}, icon: Icon(Icons.chat_bubble_outline_outlined), iconSize: 20,),
                      IconButton( padding: EdgeInsets.fromLTRB(0, 0, 0, 5), constraints: BoxConstraints(), onPressed: (){}, icon: Icon(Icons.adjust_outlined), iconSize: 20,)
                    ],
                  ),
                  Container( margin: EdgeInsets.fromLTRB(0, 0, 0, 5), child: Text('좋아요 ${widget.data[0]['likes']}개',)),
                  Text.rich(TextSpan(
                      children: [
                        TextSpan(text: widget.data[i]['user'], style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' ${widget.data[i]['content']}', )
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


class UploadKey extends StatefulWidget {
  UploadKey({Key? key, this.userImage, this.setUserContent, this.addMyData}) : super(key: key);


  final userImage;
  final setUserContent;
  final addMyData;


  @override
  State<UploadKey> createState() => _UploadKeyState();
}

class _UploadKeyState extends State<UploadKey> {

  var uploadIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close, size: 33,), color: Colors.black,),
          title: Center(child: Text('새게시물', style: TextStyle(color: Colors.black))),
          actions: [TextButton(onPressed: (){
            if(widget.userImage != null){
              if(uploadIndex == 0){
                setState(() {
                  uploadIndex = 1;
                });
              }
              else if(uploadIndex == 1){
                setState(() {
                  widget.addMyData();
                  Navigator.pop(context);
                });
              }
            }
          }, child: Text('다음', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),))],
          ),
        body: [Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(widget.userImage),
          ],
        ), Container(
          margin: EdgeInsets.all(20),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[Image.file(widget.userImage, width: 40,), Container(margin: EdgeInsets.fromLTRB(10, 0, 0, 0), width: 300, height: 50, child: TextField(onChanged: (text){widget.setUserContent(text);}, decoration: InputDecoration(labelText: '문구 입력...'),))]
          ),
        ) ][uploadIndex]
    );
  }
}
