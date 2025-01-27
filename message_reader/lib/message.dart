import 'package:http/http.dart' as http;

class Message {
  final String name;
  final String phone;
  final String email;
  final String message;
  final String? debug;

  Message({
    required this.name,
    required this.phone,
    required this.email,
    required this.message,
    this.debug,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      message: Uri.decodeComponent(json['message']).replaceAll('+', " "),
      debug: json['robot'] as String?,
    );
  }
  @override
  String toString() {
    return '$name | $email | $phone';
  }

  Future<String> downloadJson(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception(
            'Failed to load JSON data from the internet. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error downloading JSON: $e');
    }
  }
}
