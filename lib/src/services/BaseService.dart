abstract class BaseService {
  final String BaseUrl = "http://192.168.145.156:3577/";


  Future<dynamic> getAllTodoItems();

  Future<dynamic> deleteTodoItem(String todoId);


  Future<dynamic> updateTodoItem(Map <String, dynamic> rawJson,String todoId);

  Future<dynamic> createTodo(Map<String,dynamic> rawJson);




}