import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';



class NoConnection extends StatelessWidget {
  const NoConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Lottie.asset('assets/images/no_connection.json')
        )
    );
  }
}
