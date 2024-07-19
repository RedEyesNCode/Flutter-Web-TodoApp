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

    // _initialApiCall();

  }


  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MainViewModel>(context, listen: true); // Get ViewModel without listening for changes

    // --- Data Fetching ---
    if (viewModel.allTodoResponse == null) {
      viewModel.getAllTodoItems(); // Trigger data fetching if not already loaded
      return const Center(child: CircularProgressIndicator());
    }

    // --- Error Handling ---
    if (viewModel.allTodoResponse!.status == "fail") {
      return Center(child: Text(viewModel.allTodoResponse!.message!));
    }

    // --- List Building ---
    List<Data> todoItems = viewModel.allTodoResponse!.data!;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Flutter Web Todo App'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: () => {showCreateTodoDialog(context, viewModel)}, child: Text('Create Todo Item')),
            )
          ],
        ),
      ),
      body:
        ListView.builder(
        itemCount: todoItems.length,
        itemBuilder: (context, index) {
          final todoItem = todoItems[index];
          return ListTile(
            title: Text(todoItem.title.toString()),
            subtitle: Text(todoItem.description ?? ''),
            leading: Checkbox(
              value: todoItem.completed,

              onChanged: (value) {
                showAlertDialog(context, 'is_Completed : ${todoItem.completed}');


              },
            ),
            trailing: Row( // Add buttons in a Row to keep them together
              mainAxisSize: MainAxisSize.min, // Keep the Row as small as possible
              children: [
                IconButton( // Update Button
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showUpdateTodoDialog(context, todoItem, viewModel); // Open an editing dialog or screen (you'll need to implement this in your ViewModel)
                  },
                ),
                IconButton( // Delete Button
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDeleteConfirmationDialog(context, todoItem,viewModel); // Implement delete functionality in your ViewModel
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }



  void showDeleteConfirmationDialog(BuildContext context, Data todoItem,MainViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this todo?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Cancel - do nothing
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(true); // Confirm - delete
                viewModel.deleteTodoItem(todoItem.id.toString()); // Call the actual delete method

                await _initialApiCall(viewModel);

              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _initialApiCall(MainViewModel viewModel) async {


    // Consider disabling the button to prevent multiple login attempts
    print(viewModel.response.status.toString());

    try {
      showLoader(); // Show the loading dialog
      setState(() {

      });

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


  void showUpdateTodoDialog(BuildContext context, Data todoItem, MainViewModel viewModel) {
    TextEditingController titleController = TextEditingController(text: todoItem.title);
    TextEditingController descriptionController = TextEditingController(text: todoItem.description ?? "");
    bool isCompleted = todoItem.completed!; // Initialize with existing value

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder( // Use StatefulBuilder to manage checkbox state
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Update Todo"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: "Title"),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: "Description"),
                  ),
                  CheckboxListTile( // The checkbox widget
                    title: const Text("Completed"),
                    value: isCompleted,
                    onChanged: (value) {
                      setState(() { // Update the isCompleted state variable
                        isCompleted = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(), // Close
                  child: const Text("Close"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();

                    // Call your ViewModel to update the todo item with new values
                    viewModel.updateTodoItem({
                      "id": todoItem.id.toString(),
                      "title": titleController.text,
                      "description": descriptionController.text,
                      "completed": isCompleted,
                    }, todoItem.id.toString());
                  },
                  child: const Text("Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showCreateTodoDialog(BuildContext context,MainViewModel viewModel) {

    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    bool isCompleted = false;
    titleController.clear(); // Clear fields for new todo
    descriptionController.clear();
    isCompleted = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context,setState){
          return AlertDialog(
            title: const Text("Create New Todo"),
            content: Column( // Same content as the update dialog
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                CheckboxListTile(
                  title: const Text("Completed"),
                  value: isCompleted,
                  onChanged: (value) {
                    setState(() {
                      isCompleted = value!;

                    });
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(), // Close
                child: const Text("Close"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  viewModel.createTodoItem({
                    "title" : titleController.text.toString(),
                    "description" : descriptionController.text.toString(),
                    "completed" : isCompleted
                  }); // Call the actual creation method
                  _initialApiCall(viewModel);

                },
                child: const Text("Create"),
              ),
            ],
          );
        })


        ;
      },
    );
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


