import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';

class HeadingWithBackArrow extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;

  const HeadingWithBackArrow({super.key, required this.title, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onBack ?? () => Navigator.of(context).maybePop(),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.only(right: SizeConfig.scaleWidth(8)),
            child: Icon(
              Icons.arrow_back,
              size: SizeConfig.scaleFont(24),
              color: const Color(0xFF161616),
            ),
          ),
        ),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w700,
              fontSize: SizeConfig.scaleFont(24),
              color: const Color(0xFF161616),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
