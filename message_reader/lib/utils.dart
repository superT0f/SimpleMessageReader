import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'app_config.dart';




class Utils {
  static Future<String> downloadJson() async {
    try {
      var response = await http.get(AppConfig.apiUrl,
          headers: <String, String>{'authorization': AppConfig.basicAuth});
      if (kDebugMode) {
        debugPrint(" response : $response");
      }
      if (response.statusCode == 200) {
        if (kDebugMode) {
          debugPrint(response.body);
        }

        return response.body;
      } else {
        throw Exception(
            'Failed to load JSON data from the internet. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error downloading JSON: $e, $e.message');
    }
  }

}