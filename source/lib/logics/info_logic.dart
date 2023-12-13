import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class InfoDataLogic {
  Future<Map> loadData(String fetchUrl);
}

class InfoDataException implements Exception{}

class SimpleInfoDataLogic extends InfoDataLogic{
  @override
  Future<Map> loadData(String fetchUrl) async {
    Map? data;
    try {
      var response = await http.get(
        Uri.parse(fetchUrl),
        headers: {
          "Accept": "application/json"
        }
      );  
      data = json.decode(response.body);
    } catch (e) {
      throw InfoDataException();
    }
    return data!;
  }
}