import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ChatbotService {
  static const String _baseUrl = "http://192.168.24.103:8000/api/v1/chatbot";
  Future<String?> uploadDocument(File file) async {
    final url = Uri.parse('$_baseUrl/upload');
    try {
      var request = http.MultipartRequest('POST', url);
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
        ),
      );
      var response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final decodedData = jsonDecode(responseData);
        return decodedData['filename'];
      } else {
        print("Lỗi upload file: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Lỗi kết nối khi upload: $e");
      return null;
    }
  }

  Future<String> askQuestion(String question, String documentName) async {
    final url = Uri.parse('$_baseUrl/ask');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        // Gửi kèm cả câu hỏi và tên tài liệu
        body: jsonEncode({
          'question': question,
          'document_name': documentName,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['answer'] ?? "Không nhận được câu trả lời hợp lệ.";
      } else {
        final errorData = jsonDecode(utf8.decode(response.bodyBytes));
        return "Lỗi từ server: ${errorData['detail'] ?? response.reasonPhrase}";
      }
    } catch (e) {
      print("Lỗi kết nối: $e");
      return "Lỗi: Không thể kết nối tới server. Hãy chắc chắn bạn đang ở cùng mạng Wi-Fi với server.";
    }
  }
}


