import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qwestify_app/src/model/all_todo_items_response.dart';
import 'package:qwestify_app/src/utils/api_response.dart';
import 'package:qwestify_app/src/view/widgets/LoadingDialog.dart';
import 'package:qwestify_app/src/viewmodel/MainViewModel.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initialApiCall();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Consumer<MainViewModel>( // Consumer rebuilds when ViewModel changes
        builder: (context, viewModel, _) {
          if (viewModel.allTodoResponse == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.allTodoResponse!.status == "fail") {
            // Handle error scenario
            return Center(child: Text(viewModel.allTodoResponse!.message!));
          } else {
            List<Data> todoItems = viewModel.allTodoResponse!.data!;
            return ListView.builder(
              itemCount: todoItems.length,
              itemBuilder: (context, index) {
                final todoItem = todoItems[index];
                return ListTile(
                  title: Text(todoItem.title.toString()),
                  subtitle: Text(todoItem.description ?? ''),
                  leading: Checkbox(
                    value: todoItem.completed,
                    onChanged: (value) {
                      // Handle checkbox changes here
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }


  Future<void> _initialApiCall() async {
    final viewModel = Provider.of<MainViewModel>(context, listen: false);


    // Consider disabling the button to prevent multiple login attempts
    print(viewModel.response.status.toString());

    try {
      showLoader(); // Show the loading dialog
      await viewModel.getAllTodoItems();
      hideLoader(); // Hide the dialog
      print(viewModel.response.status.toString());

      if (viewModel.response.status == Status.COMPLETED) {
        // Success! Navigate to appropriate screen

        //   viewModel.loginResponse!.data.password
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(viewModel.allTodoResponse!.message.toString())),
        );
        // Saving the response into session



      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(viewModel.response.message.toString())),
        );
      }
    } finally {
      print('Finally Code');
      // Re-enable the login button
    }
  }
  void showLoader() {
    // Example if using flutter_easyloading:
    LoadingDialog();

  }

  void hideLoader() {
    // Example if using flutter_easyloading:
    print('Hide Loading');
  }
}


void showAlertDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      // Changed context to dialogContext
      return AlertDialog(
        title: Text("Info",
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'PlayfairDisplay',
              fontWeight: FontWeight.w400,
              fontSize: 18,
            )),
        content: Text(message,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'PlayfairDisplay',
              fontWeight: FontWeight.w400,
              fontSize: 18,
            )),
        actions: [
          TextButton(
            child: Text(
              "OK",
              style: TextStyle(
                  color: Colors.redAccent,
                  fontFamily: 'PlayfairDisplay',
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Use the dialogContext here
            },
          ),
        ],
      );
    },
  );
}


