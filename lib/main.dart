import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qwestify_app/src/view/screens/todo_list_screen.dart';
import 'package:qwestify_app/src/viewmodel/MainViewModel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Add this

  runApp(
      ChangeNotifierProvider(
        create: (_) => MainViewModel(),
        child: const MyApp(),
      )

  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web Todo App',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TodoListScreen(),
    );
  }
}

