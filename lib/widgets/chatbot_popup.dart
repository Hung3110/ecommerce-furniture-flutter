import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/chat_message.dart';
import '../services/chatbot_service.dart';

class ChatbotPopup extends StatefulWidget {
  const ChatbotPopup({super.key});

  @override
  State<ChatbotPopup> createState() => _ChatbotPopupState();
}

class _ChatbotPopupState extends State<ChatbotPopup> {
  final ChatbotService _chatbotService = ChatbotService();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // State quản lý file và lịch sử chat
  List<String> _uploadedFiles = [];
  String? _selectedFile;
  Map<String, List<ChatMessage>> _chatHistories = {};

  bool _isLoading = false; // Trạng thái chung
  bool _isUploading = false; // Trạng thái riêng cho việc upload

  @override
  void initState() {
    super.initState();
    // Khởi tạo lịch sử chat cho file mặc định (nếu có)
    // Hoặc bạn có thể tải danh sách file đã có từ server ở đây
  }

  // Hàm chọn và tải file lên
  void _pickAndUploadFile() async {
    setState(() => _isUploading = true);
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        final filename = await _chatbotService.uploadDocument(file);
        if (filename != null && mounted) {
          setState(() {
            if (!_uploadedFiles.contains(filename)) {
              _uploadedFiles.add(filename);
            }
            _selectedFile = filename;
            // Khởi tạo lịch sử chat nếu chưa có
            _chatHistories.putIfAbsent(_selectedFile!, () => [
              ChatMessage(text: "Sẵn sàng hỏi đáp về tài liệu '$filename'", isUser: false)
            ]);
          });
        }
      }
    } catch (e) {
      // Xử lý lỗi
      print("Lỗi chọn file: $e");
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  // Hàm gửi tin nhắn
  void _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _selectedFile == null) return;

    final userMessage = ChatMessage(text: text, isUser: true);

    setState(() {
      _chatHistories[_selectedFile!]!.add(userMessage);
      _isLoading = true;
    });
    _textController.clear();
    _scrollToBottom();

    try {
      final botResponseText = await _chatbotService.askQuestion(text, _selectedFile!);
      final botMessage = ChatMessage(text: botResponseText, isUser: false);
      if (mounted) {
        setState(() {
          _chatHistories[_selectedFile!]!.add(botMessage);
        });
      }
    } catch (e) {
      final errorMessage = ChatMessage(text: "Đã xảy ra lỗi, vui lòng thử lại.", isUser: false);
      if (mounted) {
        setState(() {
          _chatHistories[_selectedFile!]!.add(errorMessage);
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lấy danh sách tin nhắn hiện tại dựa trên file đã chọn
    final currentMessages = _chatHistories[_selectedFile] ?? [];

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA), // Màu nền sáng hơn
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          children: [
            // Header
            _buildHeader(),
            // Vùng hiển thị upload và chọn file
            _buildFileManagementArea(),
            // Vùng chat
            Expanded(
              child: _selectedFile == null
                  ? _buildWelcomeScreen()
                  : _buildChatList(currentMessages),
            ),
            // Vùng nhập liệu
            if (_selectedFile != null) _buildTextInputArea(),
          ],
        ),
      ),
    );
  }

  // --- CÁC WIDGET CON ĐỂ DỄ QUẢN LÝ ---

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Trợ lý FAQ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildFileManagementArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedFile,
              hint: const Text("Chọn tài liệu để hỏi đáp"),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFile = newValue;
                  if (_selectedFile != null && !_chatHistories.containsKey(_selectedFile)) {
                    _chatHistories[_selectedFile!] = [
                      ChatMessage(text: "Sẵn sàng hỏi đáp về tài liệu '$_selectedFile'", isUser: false)
                    ];
                  }
                });
              },
              items: _uploadedFiles.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 10),
          _isUploading
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 3))
              : IconButton(
            icon: const Icon(Icons.upload_file, color: Colors.blueAccent),
            tooltip: "Tải tài liệu mới",
            onPressed: _pickAndUploadFile,
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    // Bọc ngoài bằng SingleChildScrollView để có thể cuộn
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0), // Tăng padding dọc
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.file_present_rounded, size: 60, color: Colors.grey[400]),
              const SizedBox(height: 16),
              const Text(
                "Chưa có tài liệu nào được chọn",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Vui lòng tải lên hoặc chọn một tài liệu để bắt đầu cuộc trò chuyện.",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatList(List<ChatMessage> messages) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return Align(
          alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: message.isUser ? Colors.blue[100] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(message.text, style: const TextStyle(fontSize: 15)),
          ),
        );
      },
    );
  }

  Widget _buildTextInputArea() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  hintText: "Nhập câu hỏi...",
                  filled: true,
                  fillColor: const Color(0xFFF1F1F2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onSubmitted: (value) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            _isLoading
                ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator()),
            )
                : IconButton(
              icon: const Icon(Icons.send),
              onPressed: _sendMessage,
              style: IconButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}