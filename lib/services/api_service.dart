import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<Map<String, dynamic>> fetchGiftCards() async {
    final response = await http.get(Uri.parse('https://api.example.com/giftcards'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load gift cards');
    }
  }
}
