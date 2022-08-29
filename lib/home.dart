import 'package:flutter/material.dart';
import 'package:v_flutter/list_contact.dart';
import 'package:v_flutter/swipe3.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
 
class _HomeScreenState extends State<HomeScreen>{

  int _currentIndex = 0;
  final List<Widget> _children =[
    listContact(),
    HomePage(),
  ];

  void onTappedBar(int index){
    setState((){
      _currentIndex = index;
    });
  }
  
  @override 
  Widget build(BuildContext context){
    return Scaffold(
       
          body: _children[_currentIndex],
  bottomNavigationBar: BottomNavigationBar(
   
    onTap : onTappedBar,
    currentIndex: _currentIndex,
    items: [
    BottomNavigationBarItem(
      backgroundColor: Colors.blueAccent,
      icon: Icon(Icons.list),
      label: 'List Contact',
          ),
          BottomNavigationBarItem(
      icon: Icon(Icons.refresh),
      label: 'Refresh Contact',
          ),
        
    ],),
 );
 
 }}