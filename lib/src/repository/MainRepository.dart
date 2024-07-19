import 'package:qwestify_app/src/model/all_todo_items_response.dart';
import 'package:qwestify_app/src/model/common_response.dart';
import 'package:qwestify_app/src/services/AppHttpService.dart';
import 'package:qwestify_app/src/services/BaseService.dart';

class MainRepository {
  BaseService _userService = AppHttpService();


  Future<all_todo_items_response> getAllTodoItems() async{

    try {
      // Assuming _userService handles the registration request
      dynamic response = await _userService.getAllTodoItems();
      // Assuming the response is in the format you provided earlier
      return all_todo_items_response.fromJson(response);
    } catch (error) {
      // Handle error
      throw error;
    }

  }

  Future<common_response> deleteTodoItem(String todoId) async{

    try {
      // Assuming _userService handles the registration request
      dynamic response = await _userService.deleteTodoItem(todoId);
      // Assuming the response is in the format you provided earlier
      return common_response.fromJson(response);
    } catch (error) {
      // Handle error
      throw error;
    }

  }
  Future<common_response> updateTodoItem(Map<String,dynamic> maps,String todoId) async{

    try {
      // Assuming _userService handles the registration request
      dynamic response = await _userService.updateTodoItem(maps,todoId);
      // Assuming the response is in the format you provided earlier
      return common_response.fromJson(response);
    } catch (error) {
      // Handle error
      throw error;
    }

  }

  Future<common_response> createTodoItem(Map<String,dynamic> maps) async{

    try {
      // Assuming _userService handles the registration request
      dynamic response = await _userService.createTodo(maps);
      // Assuming the response is in the format you provided earlier
      return common_response.fromJson(response);
    } catch (error) {
      // Handle error
      throw error;
    }

  }

}