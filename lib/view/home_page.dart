import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pod/model/todo.dart';
import 'package:pod/providers/todo_provider.dart';

import '../constants/gap.dart';



class HomePage extends StatelessWidget {


  final todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Consumer(
              builder: (context, ref, child) {
                final todoData = ref.watch(todoProvider);
                return Column(
                  children: [
                    TextFormField(
                      controller: todoController,
                      onFieldSubmitted: (val) {
                        final newTodo = Todo(
                            dateTime: DateTime.now().toString(),
                            todo: val.trim()
                        );
                        ref.read(todoProvider.notifier).addTodo(newTodo);
                        todoController.clear();
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          hintText: 'add some todo',
                          suffixIcon: Icon(Icons.mediation_rounded),
                          border: OutlineInputBorder()
                      ),
                    ),
                    Sizes.gapH20,
                    Expanded(
                        child:ListView.separated(
                          separatorBuilder: (c, i){
                            return Divider(
                              color: Colors.black,
                            );
                          },
                            itemCount: todoData.length,
                            itemBuilder:(context, index){
                              final todo = todoData[index];
                              return Card(
                                child: ListTile(
                                  leading: Icon(Icons.today),
                                  title: Text(todo.todo),
                                  subtitle: Text(todo.dateTime),
                                  trailing: Container(
                                    width: 100,
                                    child: Row(
                                      children: [

                                        IconButton(onPressed: (){
                                          Get.defaultDialog(
                                              title: 'Customize',
                                              content: TextFormField(
                                                initialValue: todo.todo,
                                                onFieldSubmitted: (val) {
                                                  Get.back();
                                                  final newTodo = Todo(
                                                      dateTime: todo.dateTime,
                                                      todo: val.trim()
                                                  );
                                                  ref.read(todoProvider.notifier).updateTodo(newTodo);

                                                },
                                                decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.symmetric(
                                                        vertical: 10, horizontal: 10),
                                                    suffixIcon: Icon(Icons.mediation_rounded),
                                                    border: OutlineInputBorder()
                                                ),
                                              ),

                                          );
                                        }, icon: Icon(Icons.edit, color: Colors.green,)),






                                        IconButton(onPressed: (){
                                          Get.defaultDialog(
                                            title: 'Hold on',
                                            content: Text('Are You Sure ?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: (){
                                                    Get.back();
                                                  ref.read(todoProvider.notifier).removeTodo(index);

                                              }, child: Text('yes')),
                                              TextButton(onPressed:
                                                  (){
                                                    Get.back();

                                                  }, child: Text('no')),
                                            ]
                                          );
                                        }, icon: Icon(Icons.delete, color: Colors.pink,)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                        )
                    )

                  ],
                );
              }
            ),
          ),
        )
    );
  }
}
