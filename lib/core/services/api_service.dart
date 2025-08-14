import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Map<String, String> getHeaders({bool includeAuth = true}) {
    final headers = <String, String>{'Content-Type': 'application/json'};

    return headers;
  }

  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getAuthToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> get(String url) async {
    final headers = await getAuthHeaders();
    return await http.get(Uri.parse(url), headers: headers);
  }

  static Future<http.Response> post(
    String url,
    Map<String, dynamic> body,
  ) async {
    final headers = await getAuthHeaders();
    return await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );
  }

  static Future<http.Response> put(
    String url,
    Map<String, dynamic> body,
  ) async {
    final headers = await getAuthHeaders();
    return await http.put(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );
  }

  static Future<http.Response> delete(String url) async {
    final headers = await getAuthHeaders();
    return await http.delete(Uri.parse(url), headers: headers);
  }
}
