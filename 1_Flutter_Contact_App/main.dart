import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';


void main() {
  runApp(MaterialApp(
      home: MyApp())
  );
}


class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  getPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      print('허락됨');
      var contacts = await ContactsService.getContacts();
      var newPerson = Contact();
      setState(() {
        name = contacts;
      });

    } else if (status.isDenied) {
      print('거절됨');
      Permission.contacts.request();
      openAppSettings();
    }
  }


  var total = 3;
  var number = ['01012345667', '01012312312', '01012311234'];

  List<Contact> name = [];

  addName(a){
    setState(() {
      name.add(a);
    });
  }

  addOne(str, str2){

    setState((){
      total++;
      name.add(str);
      number.add(str2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (){
              showDialog(context: context, builder: (context){
                return DialogUI(addOne: addOne, name: name, total:total, addName:addName);
              });
            },
          ),
          appBar: AppBar(title: Text('웅이의 연락처'), actions: [
            IconButton(onPressed: (){getPermission();}, icon: Icon(Icons.contacts))]
          ),
          bottomNavigationBar: BottomItem(),
          body: ListView.builder(
              itemCount: name.length,
              itemBuilder: (c , i){
                return ListTile(
                  leading: Icon(Icons.person_pin_rounded, size: 40,),
                  title: Text((name[i].givenName).toString()),
                  subtitle: Text(number[i]),
                  trailing: IconButton(onPressed: (){
                    setState(() {
                      name.remove(name[i]);
                    });
                  }, icon: Icon(Icons.delete)),
                );
              }
          )
    );
  }
}


class BottomItem extends StatelessWidget {
  const BottomItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(onPressed: (){}, icon: Icon(Icons.call)),
          IconButton(onPressed: (){}, icon: Icon(Icons.message)),
          IconButton(onPressed: (){}, icon: Icon(Icons.book)),
        ],
      ),
    );
  }
}

class DialogUI extends StatelessWidget {
  DialogUI({Key? key, this.addOne, this.name, this.total, this.addName}) : super(key: key);
  final addOne, name, total, addName;
  var inputName = '';
  var inputNumber = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(title: Text('New Contact'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(decoration: InputDecoration(hintText: '이름'), onChanged: (text){inputName = text;}),
          TextFormField(decoration: InputDecoration(hintText: '전화번호'), onChanged: (number){inputNumber = number;})
        ],
      ),
      actions: [
        TextButton(onPressed: (){ Navigator.pop(context);}, child: Text('Cancel')),
        TextButton(onPressed: (){
          if(inputName.length==0){

          }
          else {
            var newContact = Contact();
            newContact.givenName = inputName;
            ContactsService.addContact(newContact);
            addName(newContact);
            addOne(inputName, inputNumber);
            Navigator.pop(context);
          }
        }, child: Text('OK'))

      ],);
  }
}
