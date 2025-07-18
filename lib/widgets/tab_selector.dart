// 📄 tab_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/utils/transition_config.dart';

class TabSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const TabSelector({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabCount = 2;
    final totalWidth = SizeConfig.scaleWidth(327);
    final tabWidth = (totalWidth - SizeConfig.scaleWidth(16)) / tabCount;

    return Container(
      width: totalWidth,
      height: SizeConfig.scaleHeight(56),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(56)),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: selectedIndex == 0
                ? Alignment.centerLeft
                : Alignment.centerRight,
            duration: const Duration(
              milliseconds: TransitionConfig.durationShort,
            ),
            curve: Curves.easeInOut,
            child: Container(
              width: tabWidth,
              margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.scaleWidth(8),
              ),
              height: SizeConfig.scaleHeight(40),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(SizeConfig.scaleWidth(32)),
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(width: SizeConfig.scaleWidth(8)),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTabChanged(0),
                  child: Align(
                    alignment: Alignment.center,
                    child: _buildTabItem(
                      "Đăng Nhập",
                      selected: selectedIndex == 0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTabChanged(1),
                  child: Align(
                    alignment: Alignment.center,
                    child: _buildTabItem(
                      "Đăng Ký",
                      selected: selectedIndex == 1,
                    ),
                  ),
                ),
              ),
              SizedBox(width: SizeConfig.scaleWidth(8)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String text, {bool selected = false}) {
    return Container(
      height: SizeConfig.scaleHeight(40),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          fontSize: SizeConfig.scaleFont(16),
          color: selected ? const Color(0xFF0E333C) : const Color(0xFF9E9E9E),
        ),
      ),
    );
  }
}
