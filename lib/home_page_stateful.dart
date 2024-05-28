import 'package:flutter/material.dart';
import 'package:aniis_nabiilah_exam_json_api/models/todo.dart';
import 'package:aniis_nabiilah_exam_json_api/services/todo_services.dart';

import 'post_page.dart';

class HomePageStateful extends StatefulWidget {
  const HomePageStateful({super.key});

  @override
  State<HomePageStateful> createState() => _HomePageStatefulState();
}

class _HomePageStatefulState extends State<HomePageStateful> {
  List<Todo> todos = [];

  void fetchTodos() async {
    final result = await TodoService.fetchTodos();
    setState(() {
      todos = result;
    });
  }

  void createTodo() async {
    final newTodo = Todo(
      userId: 1,
      id: 0, // This field will be set by the server
      title: 'Haloo',
      completed: false,
    );
    final createdTodo = await TodoService.createTodo(newTodo);
    setState(() {
      todos.add(createdTodo);
    });
  }

  void updateTodo(Todo todo) async {
    final updatedTodo = await TodoService.updateTodo(todo);
    setState(() {
      final index = todos.indexWhere((element) => element.id == updatedTodo.id);
      if (index != -1) {
        todos[index] = updatedTodo;
      }
    });
  }

  void deleteTodo(int id) async {
    await TodoService.deleteTodo(id);
    setState(() {
      todos.removeWhere((todo) => todo.id == id);
    });
  }

  Future<void> _editTodoDialog(Todo todo) async {
    final titleController = TextEditingController(text: todo.title);
    bool completed = todo.completed;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              Row(
                children: [
                  const Text('Completed: '),
                  Switch(
                    value: completed,
                    onChanged: (value) {
                      setState(() {
                        completed = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                final updatedTodo = Todo(
                  userId: todo.userId,
                  id: todo.id,
                  title: titleController.text,
                  completed: completed,
                );
                updateTodo(updatedTodo);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aniis Nabiilah'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return Card(
            child: ListTile(
              title: Text(todo.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Completed: ${todo.completed}'),
                  TextButton(
                    onPressed: () {
                      _editTodoDialog(todo);
                    },
                    child: const Text('Edit'),
                  ),
                  TextButton(
                    onPressed: () {
                      deleteTodo(todo.id);
                    },
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PostPage()),
          );
          if (result == true) {
            fetchTodos();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
