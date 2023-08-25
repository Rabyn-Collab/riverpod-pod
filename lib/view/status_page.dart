import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pod/providers/auth_provider.dart';
import 'package:pod/service/auth_service.dart';
import 'package:pod/view/auth/auth_page.dart';
import 'package:pod/view/home_page.dart';


class StatusPage extends ConsumerWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return  Consumer(
        builder: (context, ref, child) {
          final userData = ref.watch(userStream);
          return Scaffold(
              body: userData.when(
                  data: (data){
                    if(data == null){
                      return AuthPage();
                    }else{
                      return HomePage();
                    }
                  },
                  error: (err, stack) => Center(child: Text('$err')),
                  loading: () => Center(child: CircularProgressIndicator())
              )
          );
        }
    );
  }
}
