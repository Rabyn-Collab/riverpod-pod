import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pod/view/auth/auth_page.dart';
import 'package:pod/view/status_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';




void main () async{
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(Duration(milliseconds: 500));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(
      ProviderScope(

          child: Home()
      ));

}




class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(
        ).copyWith(
          textTheme: Typography().white.apply(fontFamily: 'RaleWay'),
        ),
        home: StatusPage(),
    );
  }
}


class CounterStream extends StatelessWidget {
   CounterStream({super.key});

  int number = 0;

  StreamController  numberStream = StreamController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
          initialData: number,
          stream: numberStream.stream,
          builder: (context, snapshot) {
              return  Center(child: Text(snapshot.data.toString(), style: TextStyle(fontSize: 50),));
          }
        ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        numberStream.sink.add(number++);
      }, child: Icon(Icons.add),),
    );
    
    
  }
}
