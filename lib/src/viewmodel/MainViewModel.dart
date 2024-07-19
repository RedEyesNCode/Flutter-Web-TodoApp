import 'package:flutter/cupertino.dart';
import 'package:qwestify_app/src/model/all_todo_items_response.dart';
import 'package:qwestify_app/src/model/common_response.dart';
import 'package:qwestify_app/src/repository/MainRepository.dart';
import 'package:qwestify_app/src/utils/api_response.dart';
import 'package:qwestify_app/src/utils/app_exception.dart';

class MainViewModel with ChangeNotifier {
  ApiResponse _apiResponse = ApiResponse.initial('Empty data');

  all_todo_items_response? _all_todo_items_response;

  common_response? _delete_todo_item_response;

  common_response? get deleteTodoItemResponse => _delete_todo_item_response;


  common_response? _create_todo_item_response;
  common_response? get createTodoItemResponse => _create_todo_item_response;

  common_response? _update_todo_item_response;
  common_response? get updateTodoItemResponse => _update_todo_item_response;



  ApiResponse get response => _apiResponse;
  all_todo_items_response? get allTodoResponse => _all_todo_items_response;
  bool _shouldNotifyListeners = false; // Flag to control listener notification

  Future<void> createTodoItem(Map<String,dynamic> maps) async {
    _apiResponse = ApiResponse.loading('Checking event type decoration');
    _shouldNotifyListeners = true; // Set flag to notify listeners
    _apiResponse.status = Status.LOADING;
    notifyListeners();

    try {

      common_response? response = await MainRepository().createTodoItem(maps);
      print(response);
      _apiResponse.status = Status.COMPLETED;
      notifyListeners();

      _apiResponse = ApiResponse.completed(response);
      _delete_todo_item_response = response;
    } on BadRequestException {
      _apiResponse = ApiResponse.error('User Not found !');
      _apiResponse.status = Status.ERROR;
      notifyListeners();

    } on FetchDataException {
      _apiResponse = ApiResponse.error('No Internet Connection');
      _apiResponse.status = Status.ERROR;
      notifyListeners();

    } catch (e) {
      _apiResponse = ApiResponse.error('Error : '+e.toString());
      _apiResponse.status = Status.ERROR;
      notifyListeners();
      print(e);
    }
    _notifyListenersIfNeeded(); // Notify listeners only once after all state changes
  }


  Future<void> updateTodoItem(Map<String,dynamic> maps,String todoId) async {
    _apiResponse = ApiResponse.loading('Checking event type decoration');
    _shouldNotifyListeners = true; // Set flag to notify listeners
    _apiResponse.status = Status.LOADING;
    notifyListeners();

    try {

      common_response? response = await MainRepository().updateTodoItem(maps,todoId);
      print(response);
      _apiResponse.status = Status.COMPLETED;
      notifyListeners();

      _apiResponse = ApiResponse.completed(response);
      _delete_todo_item_response = response;
    } on BadRequestException {
      _apiResponse = ApiResponse.error('User Not found !');
      _apiResponse.status = Status.ERROR;
      notifyListeners();

    } on FetchDataException {
      _apiResponse = ApiResponse.error('No Internet Connection');
      _apiResponse.status = Status.ERROR;
      notifyListeners();

    } catch (e) {
      _apiResponse = ApiResponse.error('Error : '+e.toString());
      _apiResponse.status = Status.ERROR;
      notifyListeners();
      print(e);
    }
    _notifyListenersIfNeeded(); // Notify listeners only once after all state changes
  }



  Future<void> deleteTodoItem(String todoId) async {
    _apiResponse = ApiResponse.loading('Checking event type decoration');
    _shouldNotifyListeners = true; // Set flag to notify listeners
    _apiResponse.status = Status.LOADING;
    notifyListeners();

    try {

      common_response? response = await MainRepository().deleteTodoItem(todoId);
      print(response);
      _apiResponse.status = Status.COMPLETED;
      notifyListeners();

      _apiResponse = ApiResponse.completed(response);
      _delete_todo_item_response = response;
    } on BadRequestException {
      _apiResponse = ApiResponse.error('User Not found !');
      _apiResponse.status = Status.ERROR;
      notifyListeners();

    } on FetchDataException {
      _apiResponse = ApiResponse.error('No Internet Connection');
      _apiResponse.status = Status.ERROR;
      notifyListeners();

    } catch (e) {
      _apiResponse = ApiResponse.error('Error : '+e.toString());
      _apiResponse.status = Status.ERROR;
      notifyListeners();
      print(e);
    }
    _notifyListenersIfNeeded(); // Notify listeners only once after all state changes
  }





  void _notifyListenersIfNeeded() {
    if (_shouldNotifyListeners) {
      notifyListeners();
      _shouldNotifyListeners = false; // Reset flag after notifying listeners
    }
  }

  Future<void> getAllTodoItems() async {
    _apiResponse = ApiResponse.loading('Checking event type decoration');
    _shouldNotifyListeners = true; // Set flag to notify listeners
    _apiResponse.status = Status.LOADING;
    _all_todo_items_response = null;

    notifyListeners();

    try {

      all_todo_items_response? response = await MainRepository().getAllTodoItems();
      print(response);
      _apiResponse.status = Status.COMPLETED;
      notifyListeners();

      _apiResponse = ApiResponse.completed(response);
      _all_todo_items_response = response;
    } on BadRequestException {
      _apiResponse = ApiResponse.error('User Not found !');
      _apiResponse.status = Status.ERROR;
      notifyListeners();

    } on FetchDataException {
      _apiResponse = ApiResponse.error('No Internet Connection');
      _apiResponse.status = Status.ERROR;
      notifyListeners();

    } catch (e) {
      _apiResponse = ApiResponse.error('Error : '+e.toString());
      _apiResponse.status = Status.ERROR;
      notifyListeners();
      print(e);
    }
    _notifyListenersIfNeeded(); // Notify listeners only once after all state changes
  }

}