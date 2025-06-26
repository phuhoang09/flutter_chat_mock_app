import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/widgets/product_item.dart';
import '../models/message.dart';
import '../widgets/fade_in_wrapper.dart';
import '../widgets/fade_in_network_image.dart';
import '../theme/app_colors.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import '../data/sample_products.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final Random _random = Random();
  late final StreamSubscription<bool> _keyboardSubscription;
  // final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Tạo hội thoại mẫu
    _initializeDefaultConversation();

    // Theo dõi sự kiện keyboard
    _keyboardSubscription = KeyboardVisibilityController().onChange.listen((
      bool visible,
    ) {
      if (visible) {
        _scrollToBottomRepeatedly(500, 100);
      }
    });

    // _focusNode.addListener(() {
    //   if (_focusNode.hasFocus) {
    //     //_scrollToBottomRepeatedly(500, 100);
    //     _scrollToBottomRepeatedly(500, 50);
    //     Future.delayed(const Duration(milliseconds: 500), () {
    //       _scrollToBottom(500);
    //     });
    //   }
    // });
  }

  void _initializeDefaultConversation() {
    final sampleMessages = [
      'Xin chào!',
      'Hôm nay bạn thế nào?',
      'Tôi đang học Flutter.',
      'Bạn thích lập trình chứ?',
      'Chúng ta cùng thử chatbot nhé.',
    ];

    for (int i = 0; i < 5; i++) {
      _messages.add(Message(text: sampleMessages[i], isSentByUser: true));
      _messages.add(
        Message(
          text: _botResponses[_random.nextInt(_botResponses.length)],
          isSentByUser: false,
        ),
      );
    }

    // Đợi layout ổn định rồi scroll xuống
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(500);
    });
  }

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
  // late final StreamSubscription<bool> _keyboardSubscription;

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
          color: AppColors.imageFullscreenBackground.withAlpha(
            (0.1 * 255).toInt(),
          ),
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

  void _scrollToBottom(int milliseconds) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: milliseconds),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _scrollToBottomLinear(int milliseconds) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: milliseconds),
          curve: Curves.linear,
        );
      }
    });
  }

  void _scrollToBottomRepeatedly(int duration, int interval) {
    int count = 0;
    int times = (duration / interval).toInt();
    final intervalDuration = Duration(milliseconds: interval);

    Timer.periodic(intervalDuration, (timer) {
      _scrollToBottomLinear(interval);
      count++;
      if (count >= times) timer.cancel();
    });
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(Message(text: text, isSentByUser: true));
    });

    _controller.clear();
    _scrollToBottom(500);

    if (text.toLowerCase() == 'items') {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _messages.add(
            Message(
              text: 'Đây là một số sản phẩm dành cho bạn:',
              isSentByUser: false,
            ),
          );
          _messages.add(
            Message(
              text: '__PRODUCTS__',
              isSentByUser: false,
              products: sampleProducts,
            ),
          );
        });
        _scrollToBottom(500);
      });
      return;
    } else if (text.toLowerCase() == 'pics') {
      Future.delayed(const Duration(seconds: 1), () {
        final images = _generateSampleImages();
        setState(() {
          _messages.add(
            Message(text: 'Đây là những hình ảnh mẫu:', isSentByUser: false),
          );
          _messages.add(
            Message(text: '__IMAGES__', isSentByUser: false, imageUrls: images),
          );
        });
        _scrollToBottom(500);
      });
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        final response = _botResponses[_random.nextInt(_botResponses.length)];
        setState(() {
          _messages.add(Message(text: response, isSentByUser: false));
        });
        _scrollToBottom(500);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      resizeToAvoidBottomInset: true,
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

                if (msg.text == '__PRODUCTS__' && msg.products != null) {
                  // final items = msg.productItems!.take(10).toList();
                  // final screenWidth = MediaQuery.of(context).size.width;
                  // final itemWidth = (screenWidth - 48) / 2.5;

                  messageWidget = Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SizedBox(
                      height: 180,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: msg.products!.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, i) {
                          final product = msg.products![i];
                          return ProductItem(product: product);
                        },
                      ),
                    ),
                  );
                } else if (msg.text == '__IMAGES__' && msg.imageUrls != null) {
                  final displayedImages = msg.imageUrls!.take(9).toList();
                  final screenWidth = MediaQuery.of(context).size.width;
                  final imageWidth = (screenWidth - 48) / 3;

                  // messageWidget = Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 8),
                  //   child: Wrap(
                  //     spacing: 8,
                  //     runSpacing: 8,
                  //     children: displayedImages.map((url) {
                  //       return GestureDetector(
                  //         onTap: () => _showImageFullscreen(url),
                  //         child: ClipRRect(
                  //           borderRadius: BorderRadius.circular(8),
                  //           child: FadeInNetworkImage(
                  //             url: url,
                  //             width: imageWidth,
                  //             height: imageWidth,
                  //           ),
                  //         ),
                  //       );
                  //     }).toList(),
                  //   ),
                  // );

                  messageWidget = Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SizedBox(
                      height: imageWidth, // chiều cao của ảnh để giới hạn dòng
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: displayedImages.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, i) {
                          final url = displayedImages[i];
                          return GestureDetector(
                            onTap: () => _showImageFullscreen(url),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: FadeInNetworkImage(
                                url: url,
                                width: imageWidth,
                                height: imageWidth,
                              ),
                            ),
                          );
                        },
                      ),
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
                            ? AppColors.messageUser
                            : AppColors.messageBot,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(msg.text),
                    ),
                  );
                }
                return FadeInWrapper(child: messageWidget);
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  // child: GestureDetector(
                  //   behavior: HitTestBehavior.translucent,
                  //   onTap: () {
                  //     WidgetsBinding.instance.addPostFrameCallback((_) {
                  //       _scrollToBottomRepeatedly(500, 100);
                  //     });
                  //   },
                  child: TextField(
                    controller: _controller,
                    // focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      fillColor: AppColors.textFieldFill,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  // ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.sendButton,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
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
    _keyboardSubscription.cancel();
    // _focusNode.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
