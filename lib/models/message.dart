import 'product.dart';

class Message {
  final String text;
  final bool isSentByUser;
  final List<String>? imageUrls;
  final List<Product>? products;

  Message({
    required this.text,
    required this.isSentByUser,
    this.imageUrls,
    this.products,
  });
}
