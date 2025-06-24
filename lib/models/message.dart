class Message {
  final String text;
  final bool isSentByUser;
  final List<String>? imageUrls;

  Message({required this.text, required this.isSentByUser, this.imageUrls});
}
