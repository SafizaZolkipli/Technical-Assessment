import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class toggleButton extends StatefulWidget {
  const toggleButton({super.key});

  @override
  State<toggleButton> createState() => _toggleButtonState();
}

class _toggleButtonState extends State<toggleButton> {
  String time1 = DateFormat('yyyy-MM-dd KK:mm:ss a').format(DateTime.now());
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CustomSwitch(
          value: isSwitched,
          activeColor: Colors.blue,
          onChanged: (value){
            print("value: $value");
            setState((){
              if(isSwitched == true){
                var result = time1;
                print(result);
              }
              else{
                var result = convertToAgo(time1, DateTime.now());
                print(result);
              }
              isSwitched = value;
            });
          },
        ),
      /*   SizedBox(height:10),
         Text("Value: $isSwitched",
        style: TextStyle(
          color: Colors.red,
          fontSize: 10
        )) */
      ],
    );
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

void convert(bool isSwitched) {
   if(isSwitched == true){
    var result = time1;
    print (result);
    }
  else{
    var result = convertToAgo(time1, DateTime.now());
    print(result);
  }
              
  }
}
