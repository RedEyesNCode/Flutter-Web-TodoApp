import 'package:qwestify_app/src/model/all_todo_items_response.dart';
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

}