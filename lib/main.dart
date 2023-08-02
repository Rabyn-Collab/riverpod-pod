import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pod/model/user.dart';
import 'package:pod/view/auth/login_page.dart';
import 'package:pod/view/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

final box = Provider<User?>((ref) => null);

void main () async{
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(Duration(milliseconds: 500));
await Hive.initFlutter();
await Hive.openBox<String?>('user');

final user = Hive.box<String?>('user');
final userData  = user.get('userInfo');

  runApp(
      ProviderScope(
        overrides: [
          box.overrideWithValue(userData == null ? null : User.fromJson(jsonDecode(userData)))
        ],
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
        home: LoginPage(),
    );
  }
}
