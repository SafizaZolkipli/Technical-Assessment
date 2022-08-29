import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:v_flutter/main.dart';

class addContact extends StatefulWidget {
  const addContact({super.key});

  @override
  State<addContact> createState() => _addContactState();
}

class _addContactState extends State<addContact> {

  String time1 = DateFormat('yyyy-MM-dd KK:mm:ss a').format(DateTime.now());
  DateTime time2 =  DateTime.now().toLocal();
  var name = new TextEditingController();
  var phone = new TextEditingController();
 
  final firestoreRef = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title:Text("Add Contact"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 SizedBox(height: 10),
                TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person), labelText: 'Name', hintText: 'Enter Name'
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: phone,
                  decoration: InputDecoration(
                    icon: Icon(Icons.phone), labelText: 'Phone No', hintText: 'Enter Phone No'
                  ),
                ),
              /*   SizedBox(height: 10),
                TextFormField(
                  controller: check,
                  decoration: InputDecoration(
                    icon: Icon(Icons.timelapse), labelText: 'Check In', hintText: 'Enter Check In Time'
                  ), 
                ), */
                 SizedBox(height: 30),
             
                 Center(
                   child: Center(
                     child: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                         children: [
                           TextButton(
                                  onPressed: (){
                                  Navigator.of(context).pop(); 
                                  },
                                  child: Text("Cancel"),
                                    ),
                           ElevatedButton(
                            onPressed: (){
                              if(name.text.isNotEmpty && phone.text.isNotEmpty){
                                    _addData(name.text, phone.text, time1);
                                  //  Navigator.of(context).pop();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Please enter all fields value"),));
                              }
                            },
                            child: Text("Add Contact"),
                            ),
                           
                         ],
                       ),
                     ),
                   ),
                 ),
              ],
              ),
          ),
        )
          ),
    );
  }


 void _addData(String name, String phone, String time1){
  var uniqueKey = firestoreRef.collection("contact").doc();
  firestoreRef.collection('contact').add({
   "id":uniqueKey.id,
      "name": name,
      "phone": phone,
      "time": time1, 
      "diff": convertToAgo(time1, DateTime.now())
      

  }).then((value){
    Navigator.of(context).pop();
    Fluttertoast.showToast(msg: "Contact successfully added");
   
    }); 
} 

String convertToAgo(String check, DateTime currentTime){
  DateTime check = DateFormat('yyyy-MM-dd KK:mm:ss a').parse(time1);
  currentTime = DateTime.now();
  Duration diff = DateTime.now().difference(DateFormat('yyyy-MM-dd KK:mm:ss a').parse(time1));
 // Duration diff = DateTime.now().difference(input);
  
  if(diff.inDays >= 1){
    return '${diff.inDays} day(s) ago';
  } else if(diff.inHours >= 1){
    return '${diff.inHours} hour(s) ago';
  } else if(diff.inMinutes >= 1){
    return '${diff.inMinutes} minute(s) ago';
  } else if (diff.inSeconds >= 1){
    return '${diff.inSeconds} second(s) ago';
  } else {
    return 'just now';
  }
}
}