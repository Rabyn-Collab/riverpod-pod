import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pod/model/cart_item.dart';
import 'package:pod/model/user.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pod/view/status_page.dart';

final box = Provider<User?>((ref) => null);
final boxA = Provider<List<CartItem>>((ref) => []);

void main () async{
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(Duration(milliseconds: 500));
await Hive.initFlutter();
Hive.registerAdapter(CartItemAdapter());

await Hive.openBox<String?>('user');
final cartBox = await Hive.openBox<CartItem>('carts');
final user = Hive.box<String?>('user');
final userData  = user.get('userInfo');
print(cartBox.values);

  runApp(
      ProviderScope(
        overrides: [
          box.overrideWithValue(userData == null ? null : User.fromJson(jsonDecode(userData))),
          boxA.overrideWithValue(cartBox.values.toList())
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
        home: StatusPage(),
    );
  }
}
