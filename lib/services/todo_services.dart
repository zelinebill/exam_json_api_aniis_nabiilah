import 'dart:convert';
import 'package:aniis_nabiilah_exam_json_api/models/todo.dart';
import 'package:http/http.dart' as http;

class TodoService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  static Future<List<Todo>> fetchTodos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/todos'));
      if (response.statusCode == 200) {
        final body = response.body;
        final result = jsonDecode(body);
        List<Todo> todos = List<Todo>.from(
          result.map(
            (todo) => Todo.fromJson(todo),
          ),
        );
        return todos;
      } else {
        throw Exception('Failed to load todos');
      }
    } catch (e) {
      throw Exception('Failed to load todos: $e');
    }
  }

  static Future<Todo> createTodo(Todo todo) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/todos'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(todo.toJson()),
      );
      if (response.statusCode == 201) {
        final result = jsonDecode(response.body);
        return Todo.fromJson(result);
      } else {
        throw Exception('Failed to create todo');
      }
    } catch (e) {
      throw Exception('Failed to create todo: $e');
    }
  }

  static Future<Todo> updateTodo(Todo todo) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/todos/${todo.id}'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(todo.toJson()),
      );
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return Todo.fromJson(result);
      } else {
        throw Exception('Failed to update todo');
      }
    } catch (e) {
      throw Exception('Failed to update todo: $e');
    }
  }

  static Future<void> deleteTodo(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/todos/$id'),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete todo');
      }
    } catch (e) {
      throw Exception('Failed to delete todo: $e');
    }
  }
}
