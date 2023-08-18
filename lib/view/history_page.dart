import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pod/constants/gap.dart';
import 'package:pod/providers/auth_provider.dart';
import 'package:pod/service/order_service.dart';



class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Consumer(
              builder: (context, ref, child) {
                final auth = ref.watch(authProvider);
                final orderData = ref.watch(orderDataProvider(auth.user!.token));
                return orderData.when(data: (data){
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Date;-  ${data[index].createdAt.substring(0 , 10)}'),
                              Sizes.gapH10,
                              Text(data[index].totalPrice.toString()),
                            ],
                          );
                        }
                    ),
                  );
                },
                    error: (err, st) => Text('$err'),
                    loading: () => Center(child: CircularProgressIndicator())
                );
              }
            ))
    );
  }
}
