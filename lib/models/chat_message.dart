
class ChatMessage {
  final String text;
  final bool isUser; // true nếu là tin nhắn của người dùng, false là của bot

  ChatMessage({required this.text, required this.isUser});
}