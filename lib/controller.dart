import 'package:crud/repository.dart';
import 'package:get/get.dart';

import 'Todo.dart';

class TodoController extends GetxController {

  // @override
  // void initState() {
  //   super.initState();
  // }

  final Repository _repository;
  TodoController(this._repository);

  Future<List<Todo>> fetchTodoList() async {
    return _repository.getTodoList();
  }

  Future updatePutCompleted(Todo todo) async {
    return _repository.putCompleted(todo);
  }

  Future deleteTodo(String id) async{
    return _repository.deleteCompleted(id);
  }

  Future<Todo> postTodo(Todo todo) async {
    return _repository.postCompleted(todo);
  }
}