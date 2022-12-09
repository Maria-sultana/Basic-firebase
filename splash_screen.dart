import 'dart:async';

import 'package:flutter/material.dart';

import 'package:student_app/view_course.dart';



class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  void initState() {
    Timer(
        Duration(seconds: 5),
        (() => Navigator.of(context)
            .push(MaterialPageRoute(builder: ((context) => View_Course())))));
  }

  @override
  Widget build(BuildContext context) {
    var controller;
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      body:Container(
        
        child:Center(
          child: Column(
            
            children: [
             Container(
             
 child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTM-f2OqAenBJ0QI6by9E5XCOasR1IIDirS2g&usqp=CAU",fit: BoxFit.cover,)),
              SizedBox(height: 100,),
              CircularProgressIndicator(
               color: Colors.white,
              ),
              SizedBox(height: 100,),
               Text("Sorry!! take your time for buffering",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:16 ),),
              ]),
              
        )
      )
       );
      
  }
}
