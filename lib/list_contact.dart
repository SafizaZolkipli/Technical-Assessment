import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:v_flutter/add_contact.dart';
import 'package:v_flutter/toggle.dart';


class listContact extends StatefulWidget {
  const listContact({super.key});

  @override
  State<listContact> createState() => _listContactState();
}

class _listContactState extends State<listContact> {

  final firestoreRef = FirebaseFirestore.instance;
  String time1 = DateFormat('yyyy-MM-dd KK:mm:ss a').format(DateTime.now());
  
 final String _content =
      'Contact Details\n\nName : User\nPhone No : 012345678\nCheck In : 123456';
      

  void _shareContent() {
    Share.share(_content);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title:Text("List Contact Details"),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: firestoreRef.collection('contact').snapshots(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              final List<DocumentSnapshot> arrData = snapshot.data!.docs;
              return ListView(
                children: arrData.map((data){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                       onTap: (){
                      print(data.id);
                      _showUpdateDialog(data, context);
                      
                    },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(children: [
                                Expanded(flex:1, child: Text("Name")),
                                Expanded(flex:3, child: Text(data['name'])),
                                SizedBox(height:10),
                              ],),
                               Row(children: [
                                Expanded(flex:1, child: Text("Phone No")),
                                Expanded(flex:3, child: Text(data['phone'])),
                                SizedBox(height:10),
                              ],),
                               Row(children: [
                                Expanded(flex:1, child: Text("Check In")),
                                Expanded(flex:3, child: Text(data['time'])),
                                SizedBox(height:10),
                              ],),
                               Row(children: [
                                Expanded(flex:1, child: Text("Format")),
                                Expanded(flex:3, child: Text(data['diff'])),
                                SizedBox(height:10),
                              ],),
                               Row(children: [
                                ElevatedButton.icon(
                                  onPressed:_shareContent,
                                  icon: const Icon(Icons.share),
                                  label: const Text('Share This Contact')),
                                SizedBox(width:10),

                                toggleButton(),
                                SizedBox(width:10),

                                ElevatedButton.icon(
                                onPressed: (){
                                  deleteData(data.id);
                                },
                                icon: Icon(Icons.delete, color: Colors.red[700]),
                               label: Text("Delete")) 
                              ],
                              
                              ),
                            
                            ],),
                        )
                      ),
                    ),
                  );
                  
                }).toList(),
              );
            } else{
              return Text("No Data Found");
            }
          }),
      ),
       floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>addContact()));
        },
        child: const Icon(Icons.add),

      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat
    );
  }
  
  Future<void> _showUpdateDialog(DocumentSnapshot doc, BuildContext context){
    var name = new TextEditingController(text:doc['name']);
    var phone = new TextEditingController(text:doc['phone']);
    var time1 = DateFormat('yyyy-MM-dd KK:mm:ss a').format(DateTime.now());
  //  var time2 = 

     return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Update Contact : "+doc.id),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                 /*  SizedBox(height: 10),
                  TextFormField(
                    controller: time1,
                    decoration: InputDecoration(
                      icon: Icon(Icons.timelapse), labelText: 'Check In', hintText: 'Enter Check In Time' 
                    ),
                  ), */
            ],),
          ),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text("Cancel")),
             ElevatedButton(
              onPressed: (){
                if(name.text.isNotEmpty && phone.text.isNotEmpty){
                     updateData(doc.id,name.text, phone.text, time1);
                     Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Please enter all fields value"),));
                }
              },
              child: Text("Save"),
              ),
          ],
          );
      }
    );
  }

  void updateData(String id, String name, String phone, String time1){
    Map<String, dynamic>data={
      "name":name,
      "phone":phone, 
      "time":time1,
      "diff": convertToAgo(time1, DateTime.now())
  
    };

    firestoreRef.collection('contact').doc(id).update(data).then((value) {
       Fluttertoast.showToast(msg:"Update Contact Succesfully");
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

  void deleteData(String id) async{
   firestoreRef.collection("contact").doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data deleted"),));
      
  } 

  void showToast(){
    Fluttertoast.showToast(msg:"You have reached end of the list");
  }


  }

  