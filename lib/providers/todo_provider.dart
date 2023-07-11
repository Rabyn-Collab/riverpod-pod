import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pod/model/todo.dart';



final todoProvider = StateNotifierProvider<TodoProvider, List<Todo>>((ref) => TodoProvider([]));




class TodoProvider extends StateNotifier<List<Todo>>{
  TodoProvider(super.state);



  void addTodo(Todo todo){
    state = [...state, todo];

  }

  void removeTodo(int index){
    state.removeAt(index);
    state = [...state];

  }


  void updateTodo(Todo todo){
   state = [
     for(final t in state) t.dateTime == todo.dateTime ? todo: t
   ];

  }





}