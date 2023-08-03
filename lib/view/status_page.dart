import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pod/providers/auth_provider.dart';
import 'package:pod/view/auth/login_page.dart';
import 'package:pod/view/home_page.dart';




class StatusPage extends ConsumerWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final authData = ref.watch(authProvider);
    print(authData.user);
    return  authData.user == null ? LoginPage(): HomePage();
  }
}
