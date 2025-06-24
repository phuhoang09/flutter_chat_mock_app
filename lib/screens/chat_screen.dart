import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final Random _random = Random();

  List<String> _generateSampleImages() {
    final count = _random.nextInt(7) + 4; // từ 4 đến 10
    return List.generate(
      count,
      (index) =>
          'https://picsum.photos/seed/image${_random.nextInt(1000)}/200/200',
    );
  }

  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(); // 📌 Thêm dòng này

  final List<String> _botResponses = [
    'Chào bạn!',
    'Bạn đang làm gì đó?',
    'Trời hôm nay đẹp quá!',
    'Bạn ăn cơm chưa?',
    'Tôi là chatbot giả lập.',
    'Hãy thử nhắn thêm gì đó nữa.',
    'Flutter rất tuyệt!',
    'Tôi có thể giúp gì cho bạn?',
    'Bạn thích lập trình chứ?',
    'Hôm nay bạn thấy thế nào?',
    'Tôi thích học máy.',
    'Bạn đang dùng Flutter phiên bản mấy?',
    'Bạn có thích AI không?',
    'Chúng ta đang chat!',
    'Bạn đã từng thử React Native chưa?',
    'Bạn có đang học code không?',
    'Cảm ơn vì đã nhắn cho tôi.',
    'Bạn có câu hỏi gì không?',
    'Tôi không có cảm xúc...',
    'Thử gửi thêm tin nữa xem!',
    'Này bạn!',
    'Haha, vui quá!',
    'Tôi là robot.',
    'Bạn cần nghỉ ngơi đó.',
    'Thử lại xem sao!',
    'Bạn làm tôi thấy thú vị.',
    'Cố gắng lên!',
    'Chúng ta đang mô phỏng thôi mà!',
    'Bảo trọng nha!',
    'Gặp lại sau nhé!',
  ];

  void _showImageFullscreen(String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => GestureDetector(
        onTap: () => Navigator.pop(context), // 👈 Tap để thoát
        child: Container(
          color: Colors.black,
          child: Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 1,
              maxScale: 4,
              child: Image.network(imageUrl),
            ),
          ),
        ),
      ),
    );
  }

  void _scrollToBottom() {
    // Delay nhẹ để đảm bảo build xong mới scroll
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

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(Message(text: text, isSentByUser: true));
    });
    _scrollToBottom();
    _controller.clear();

    // Nếu người dùng gõ "pics"
    if (text.toLowerCase() == 'pics') {
      Future.delayed(const Duration(milliseconds: 500), () {
        final images =
            _generateSampleImages(); // 👈 tạo số lượng ảnh ngẫu nhiên
        setState(() {
          _messages.add(
            Message(text: 'Đây là những hình ảnh mẫu:', isSentByUser: false),
          );
          _messages.add(
            Message(text: '__IMAGES__', isSentByUser: false, imageUrls: images),
          );
        });
        _scrollToBottom();
      });
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        final random = Random();
        final response = _botResponses[random.nextInt(_botResponses.length)];
        setState(() {
          _messages.add(Message(text: response, isSentByUser: false));
        });
        _scrollToBottom();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat (Mock AI)')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // 👈 Gắn controller
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];

                // Nếu là phần đánh dấu để hiển thị ảnh
                if (msg.text == '__IMAGES__' && msg.imageUrls != null) {
                  final displayedImages = msg.imageUrls!.take(9).toList();
                  final screenWidth = MediaQuery.of(context).size.width;
                  final imageWidth = (screenWidth - 48) / 3;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: displayedImages.map((url) {
                        return GestureDetector(
                          onTap: () => _showImageFullscreen(
                            url,
                          ), // 👈 Mở ảnh lớn khi chạm
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              url,
                              width: imageWidth,
                              height: imageWidth,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }

                // Các tin nhắn bình thường
                return Align(
                  alignment: msg.isSentByUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: msg.isSentByUser
                          ? Colors.blue[100]
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(msg.text),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _sendMessage(), // 👈 Gửi khi nhấn Enter
                    decoration: const InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose(); // 📌 đừng quên dispose controller
    super.dispose();
  }
}
