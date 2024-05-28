import 'package:flutter/material.dart';
import 'package:aniis_nabiilah_exam_json_api/home_page_stateful.dart';
import 'post_page.dart';
import 'get_page.dart';

void main() {
  runApp(const MyApp()); 
}   

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exam Aniis Nabiilah Json & Api',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainMenuPage(),
    );
  }
}

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Main Menu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildMenuButton(
                context,
                'Post',
                const PostPage(),
                Colors.blueGrey,
                Icons.post_add,
              ),
              const SizedBox(height: 16),
              _buildMenuButton(
                context,
                'Edit and Delete',
                const HomePageStateful(),
                Colors.greenAccent,
                Icons.edit,
              ),
              const SizedBox(height: 16),
              _buildMenuButton(
                context,
                'Get',
                const GetPage(),
                Colors.orangeAccent,
                Icons.get_app,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String text, Widget page,
      Color color, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      icon: Icon(icon, color: Colors.blueGrey),
      label: Text(text, style: const TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
