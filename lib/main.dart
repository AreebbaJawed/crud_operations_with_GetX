import 'package:crud/repository.dart';
import 'package:crud/updateData.dart';
import 'package:flutter/material.dart';
import 'Todo.dart';
import 'package:get/get.dart';
import 'controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        appBarTheme:
            AppBarTheme(backgroundColor: Color(0xFF344FA1), elevation: 0),
        scaffoldBackgroundColor: Color(0xFF344FA1),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/main',
      getPages: [
        GetPage(name: '/main', page: () => CRUDAPP()),
        GetPage(name: '/update', page: () => updateData()),
      ],
    );
  }
}

class Controller extends GetxController {
  @override
  void onInit() {
    onit();
    super.onInit();
  }

  var todoController = TodoController(TodoRepository());
  TodoRepository todorepository = TodoRepository();
  RxList<Todo>? list = <Todo>[].obs;
  var isLoading = true.obs;

  Future<List<Todo>?> onit() async {
    try {
      isLoading(true);
      if (list!.value.isEmpty) {
        list!.value = await todoController.fetchTodoList();
      }
      return list!.value;
    } finally {
      isLoading(false);
    }
  }
}

class CRUDAPP extends StatelessWidget {
  final Controller controller = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('T O D O  A P P'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.separated(
            padding: EdgeInsets.all(12.0),
            itemCount: controller.list!.value.length,
            itemBuilder: (context, index) {
              Todo todo = controller.list!.value[index];
              return Card(
                color: Color(0xFF031956),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  child: Dismissible(
                    key: Key(todo.userId.toString()),
                    background: Container(
                      color: Colors.redAccent,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Icon(Icons.delete),
                    ),
                    confirmDismiss: (direction) {
                      return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Delete Todo'),
                              content: Text('Are you sure to delete todo?'),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      bool response = await controller
                                          .todorepository
                                          .deleteCompleted(todo.id.toString());
                                      if (response) {
                                        Navigator.pop(context, true);
                                      } else {
                                        Navigator.pop(context, false);
                                      }
                                    },
                                    child: Text('Yes')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: Text('No'))
                              ],
                            );
                          });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 150,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text(
                                "${todo.id}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              )),
                          Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${todo.title}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text('${todo.completed}',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))
                                ],
                              )),
                          Container(width: 2, color: Color(0xFF344FA1)),
                          Expanded(
                              flex: 2,
                              child: InkWell(
                                  onTap: () async {
                                    Todo updatedTodo = await Get.toNamed(
                                        '/update',
                                        arguments: todo) as Todo;
                                    controller.list!.value.replaceRange(
                                        index, index + 1, {updatedTodo});
                                    this.controller.list!.refresh();
                                    print('Added');
                                  },
                                  child: Container(
                                      width: 90,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Color(0xFF344FA1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'Update',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Icon(Icons.update)
                                        ],
                                      )))))
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          );
        }
      }),
      floatingActionButton: Align(
        alignment: FractionalOffset.bottomCenter,
        child: FloatingActionButton(
          backgroundColor: Colors.grey.shade700,
          onPressed: () async {
            Todo todo = Todo(userId: 3, title: 'sample post', completed: false);
            Todo newTodo = await controller.todoController.postTodo(todo);
            controller.list!.value.add(newTodo);
            this.controller.list!.refresh();
            print("Added");
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
