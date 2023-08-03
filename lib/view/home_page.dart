import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pod/providers/auth_provider.dart';
import 'package:pod/service/product_service.dart';








class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final productData = ref.watch(productProvider);
        return Scaffold(
            appBar: AppBar(),
            drawer: Drawer(
              child: ListView(
                children: [
                  ListTile(
                    onTap: () {
                       ref.read(authProvider.notifier).userLogOut();
                    },
                    leading: Icon(Icons.exit_to_app, color: Colors.white,),
                    title: Text('User Log Out'),
                  )
                ],
              ),
            ),
            body:  Container()
            // productData.when(
            //           data: (data) {
            //             return Container();
            //           },
            //           error: (err, stack) => Center(child: Text('$err')),
            //           loading: () => Center(child: CircularProgressIndicator())
            //       )

        );
      }
    );
  }
}
