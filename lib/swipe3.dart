import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int count = 5;
  int index=0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pull-to-refresh & Generate Random Contact'),
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: RefreshIndicator(
          onRefresh: fetchData,
          child: ListView.builder
          (
              itemCount: count,
              itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Name: User ${index+ 1}'),
                    subtitle:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height:5),
                        Text('Phone No: 012345678${index + 1}'), 
                        SizedBox(height:5),
                        Text('Check In: 12:45:0${index + 1}'),
                        SizedBox(height:10),
                        ],
                        
                      ),
                    trailing:Text('${index + 1} sec ago'),
                  );
              },
          ),
        ),
      ),
    );
  }

  Future<void> fetchData()async {
    print('PULL TO REFRESH CALLBACK');
    count = Random().nextInt(10);
    setState((){
     
    });
  }

  void showToast(){
   for(int i=0;i<count;i++){
            if(context == count)
             Fluttertoast.showToast(msg:"You have reached end of the list");
             }
}
}