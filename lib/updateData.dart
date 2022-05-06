import 'package:crud/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Todo.dart';

class updateData extends StatelessWidget {

  final titleController = TextEditingController();
  final completedController = TextEditingController();

  TodoRepository todorepository = TodoRepository();

  @override
  Widget build(BuildContext context) {

    final Todo todo = ModalRoute.of(context)?.settings.arguments as Todo;

    titleController.text = todo.title!;
    completedController.text = todo.completed.toString();

    return Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          leading: BackButton(
            onPressed: () {
              Get.toNamed('/main');
            },
          ),
          title: Text('Update Todo'),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                      hintText: 'Title',
                    hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: completedController,
                  decoration: InputDecoration(
                      hintText: 'Completed',
                      hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),

                ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                    onPressed: () async {
                      Todo updatedTodo = Todo(
                          userId: todo.userId,
                          id: todo.id,
                          title: titleController.text,
                          completed: completedController.text);
                      Todo? response = (await todorepository.putCompleted(
                        updatedTodo,
                      ));
                      if (response!=null) {
                        //Navigator.pop(context, updatedTodo);
                        Get.back(result: updatedTodo);
                      }
                      else{
                        throw Exception('Failed to update todo.');
                      }
                    },
                    child: Text('Update',
                      style: TextStyle(color: Colors.black,fontSize: 18, fontWeight: FontWeight.w600),
                    )
                )
              ],
            ),
          ),
        ));
  }
}
