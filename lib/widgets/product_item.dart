import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  Future<void> _launchURL() async {
    final Uri url = Uri.parse(product.link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Không thể mở liên kết: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            product.imageUrl,
            width: 160,
            height: 120,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: _launchURL,
            child: Text(
              product.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 2),
          Text(product.price, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
