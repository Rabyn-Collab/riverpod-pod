import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pod/view/home_page.dart';




void main(){



  runApp(ProviderScope(child: Home()));

}


class Home extends StatelessWidget {
   Home({super.key});



  @override
  Widget build(BuildContext context) {
    final oldColors = ['k', 'b'];

    final c = [
      'q',
      for(final o in oldColors) o
    ];

    List data = [
      {'id': 1,
        'label': "lio"},
      {'id': 2,
        'label': "sio"}
    ];

    final newData = [
      for(final n in data) n['id'] == 1 ? {'label': 'mio', 'id': 1}: n
    ];

    print(newData);


    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
        home: HomePage()
    );
  }
}
