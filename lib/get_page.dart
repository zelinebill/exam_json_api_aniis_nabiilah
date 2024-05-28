import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Employee {
  final int id;
  final String employeeName;
  final int employeeSalary;
  final int employeeAge;
  final String profileImage;

  Employee({
    required this.id,
    required this.employeeName,
    required this.employeeSalary,
    required this.employeeAge,
    required this.profileImage,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      employeeName: json['employee_name'],
      employeeSalary: json['employee_salary'],
      employeeAge: json['employee_age'],
      profileImage: json['profile_image'],
    );
  }
}

class GetPage extends StatefulWidget {
  const GetPage({super.key});

  @override
  _GetPageState createState() => _GetPageState();
}

class _GetPageState extends State<GetPage> {
  late Future<List<Employee>> employees;

  @override
  void initState() {
    super.initState();
    employees = fetchEmployees();
  }

  Future<List<Employee>> fetchEmployees() async {
    final response = await http
        .get(Uri.parse('https://dummy.restapiexample.com/api/v1/employees'));

    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body)['data'];
      return parsed.map((json) => Employee.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
      ),
      body: FutureBuilder<List<Employee>>(
        future: employees,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final employee = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text(employee.employeeName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Age: ${employee.employeeAge}',
                            style: const TextStyle(fontSize: 16)),
                        Text('Salary: \$${employee.employeeSalary}',
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    leading: employee.profileImage.isNotEmpty
                        ? Image.network(employee.profileImage,
                            width: 50, height: 50)
                        : const Icon(Icons.person, size: 50),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
