import 'dart:convert';
import 'Todo.dart';
import 'package:http/http.dart' as http;

abstract class Repository{

  Future<List<Todo>> getTodoList();

  Future putCompleted(Todo todo);

  Future deleteCompleted(String id);

  Future<Todo> postCompleted(Todo todo);
}

class TodoRepository implements Repository {

  String Url = "https://jsonplaceholder.typicode.com/todos";

  @override
  Future deleteCompleted(String id) async {
    try {
      final response = await http.delete(Uri.parse('$Url/$id'));
      if (response.statusCode == 200) {
        print(response.body);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<List<Todo>> getTodoList() async {
    List<Todo> todoList = [];
    var url = Uri.parse("$Url");
    var response = await http.get(url);
    print(response.body);
    var body = json.decode(response.body);
    for (var i = 0; i < body.length; i++) {
      todoList.add(Todo.fromJson(body[i]));
    }
    return todoList;
  }

  @override
  Future<Todo> postCompleted(Todo todo) async {
    print("${todo.toJson()}");
    var url = Uri.parse("$Url");
    var result = '';
    var response = await http.post(url, body: todo.toJson());
    print(response.body);
    Todo newTodo = Todo.fromJson(json.decode(response.body));
    print(response.statusCode);
    return newTodo;
  }

  @override
  Future<Todo?> putCompleted(Todo todo) async {
    var url = Uri.parse('$Url/${todo.id}');
    String resData = '';
    var response = await http.put(url,
      body: {
        'title': todo.title,
        'completed': todo.completed.toString(),},
    );
    Todo result = Todo.fromJson(json.decode(response.body));
    return result;
  }

}

