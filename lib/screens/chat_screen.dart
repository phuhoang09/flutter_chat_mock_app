import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/message.dart';
import '../widgets/fade_in_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final Random _random = Random();

  List<String> _generateSampleImages() {
    final count = _random.nextInt(7) + 4;
    return List.generate(
      count,
      (index) =>
          'https://picsum.photos/seed/image${_random.nextInt(1000)}/200/200',
    );
  }

  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _botResponses = [
    'Chào bạn!',
    'Bạn đang làm gì đó?',
    'Trời hôm nay đẹp quá!',
    'Bạn ăn cơm chưa?',
    'Tôi là chatbot giả lập.',
    'Flutter rất tuyệt!',
    'Bạn cần nghỉ ngơi đó.',
    'Cảm ơn vì đã nhắn cho tôi.',
    'Gặp lại sau nhé!',
    'Tôi là robot.',
    'Thử lại xem sao!',
    'Cố gắng lên!',
  ];

  void _showImageFullscreen(String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => GestureDetector(
        onTap: () => Navigator.pop(context),
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

    if (text.toLowerCase() == 'pics') {
      Future.delayed(const Duration(milliseconds: 500), () {
        final images = _generateSampleImages();
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
        final response = _botResponses[_random.nextInt(_botResponses.length)];
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
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                Widget messageWidget;

                if (msg.text == '__IMAGES__' && msg.imageUrls != null) {
                  final displayedImages = msg.imageUrls!.take(9).toList();
                  final screenWidth = MediaQuery.of(context).size.width;
                  final imageWidth = (screenWidth - 48) / 3;

                  messageWidget = Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: displayedImages.map((url) {
                        return GestureDetector(
                          onTap: () => _showImageFullscreen(url),
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
                } else {
                  messageWidget = Align(
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
                }

                // 👇 Bọc toàn bộ message trong hiệu ứng fade-in
                return FadeInMessage(child: messageWidget);
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
                    onSubmitted: (_) => _sendMessage(),
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
    _scrollController.dispose();
    super.dispose();
  }
}
