import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class LoadDataLogic {
  Future<List> loadData(String fetchUrl);
}

class LoadDataException implements Exception{}

class SimpleLoadDataLogic extends LoadDataLogic{
  @override
  Future<List> loadData(String fetchUrl) async {
    List? data;
    try {
      var response = await http.get(
        Uri.parse(fetchUrl),
        headers: {
          "Accept": "application/json"
        }
      );  
      data = json.decode(response.body)["results"];
    } catch (e) {
      throw LoadDataException();
    }
    return data!;
  }
}