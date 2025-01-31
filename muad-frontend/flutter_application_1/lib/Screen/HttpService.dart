import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  // دالة لإرسال طلب GET
  static Future<Map<String, dynamic>> get(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // تم بنجاح قراءة البيانات
      } else {
        return {'error': 'فشل في تحميل البيانات'}; // التعامل مع الأكواد الأخرى
      }
    } catch (error) {
      return {'error': 'حدث خطأ: $error'};
    }
  }

  // دالة لإرسال طلب POST
  static Future<Map<String, dynamic>> post(
      String url, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body); // تم بنجاح قراءة البيانات
      } else {
        return {'error': 'فشل في إرسال البيانات'}; // التعامل مع الأكواد الأخرى
      }
    } catch (error) {
      return {'error': 'حدث خطأ: $error'};
    }
  }
}
