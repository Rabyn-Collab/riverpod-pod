import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pod/view/home_page.dart';



void main () async{
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(Duration(milliseconds: 500));

// final numbers = ['l', 'io','lio', null, 'op'];
//
// numbers.forEach((element) {
//     print(element?.toUpperCase());
// });


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
        theme: ThemeData.dark(),
        home: HomePage(),
    );
  }
}
