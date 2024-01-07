import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<http.Response> fetchData(String query) async {
  if (kDebugMode) {
    print("Searching for $query...");
  }
  var ret = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  if (kDebugMode) {
    print(ret.toString());
  }
  return ret;
}
