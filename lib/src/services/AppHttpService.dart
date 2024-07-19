import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../utils/app_exception.dart';
import 'BaseService.dart';
import 'package:http/http.dart' as http;

class AppHttpService extends BaseService {

  //PARSING METHOD
  @visibleForTesting
  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        print(responseJson);

        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
        throw FetchDataException(
            'Error occured while communication with server' +
                ' with status code : ${response.statusCode}');
      default:
        throw FetchDataException(
            'Error occured while communication with server' +
                ' with status code : ${response.statusCode}');
    }
  }


  @override
  Future getAllTodoItems() async {
    try {
      final response = await http.get(
        Uri.parse(BaseUrl + 'todos'), // Adjust the endpoint accordingly
        headers: {
          'Content-Type': 'application/json',
        },
      );


      return returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
  }

  @override
  Future deleteTodoItem(String todoId) async {
    try {
      final response = await http.delete(
        Uri.parse('${BaseUrl}todos/${todoId}'), // Adjust the endpoint accordingly
        headers: {
          'Content-Type': 'application/json',
        },
      );


      return returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
  }

  @override
  Future createTodo(Map<String, dynamic> rawJson) async {
    try {
      final response = await http.post(
        Uri.parse('${BaseUrl}todos'),
        body: jsonEncode(rawJson),// Adjust the endpoint accordingly
        headers: {
          'Content-Type': 'application/json',
        },
      );


      return returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
  }

  @override
  Future updateTodoItem(Map<String, dynamic> rawJson, String todoId) async {
    try {
      final response = await http.put(
        Uri.parse('${BaseUrl}todos/${todoId}'),
        body: jsonEncode(rawJson),// Adjust the endpoint accordingly
        headers: {
          'Content-Type': 'application/json',
        },
      );


      return returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
  }



}