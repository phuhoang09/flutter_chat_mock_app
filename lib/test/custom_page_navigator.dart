import 'package:flutter/material.dart';

class CustomPageNavigator extends StatefulWidget {
  const CustomPageNavigator({super.key});

  @override
  State<CustomPageNavigator> createState() => _CustomPageNavigatorState();
}

class _CustomPageNavigatorState extends State<CustomPageNavigator>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _nextIndex = 0;

  late AnimationController _controller;
  late Animation<Offset> _currentPageOffset;
  late Animation<Offset> _nextPageOffset;

  bool _isAnimating = false;
  bool _isForward = true;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();

    _pages.addAll([
      PageTemplate(label: 'A', onNavigate: _navigateTo),
      PageTemplate(label: 'B', onNavigate: _navigateTo),
      PageTemplate(label: 'C', onNavigate: _navigateTo),
    ]);

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  void _navigateTo(int targetIndex) {
    if (_isAnimating || targetIndex == _currentIndex) return;

    setState(() {
      _nextIndex = targetIndex;
      _isForward = targetIndex > _currentIndex;
      _isAnimating = true;
    });

    _currentPageOffset = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(_isForward ? -1 : 1, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _nextPageOffset = Tween<Offset>(
      begin: Offset(_isForward ? 1 : -1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward(from: 0).then((_) {
      setState(() {
        _currentIndex = _nextIndex;
        _isAnimating = false;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildTransition() {
    if (!_isAnimating) return _pages[_currentIndex];

    return Stack(
      children: [
        SlideTransition(
          position: _currentPageOffset,
          child: _pages[_currentIndex],
        ),
        SlideTransition(position: _nextPageOffset, child: _pages[_nextIndex]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Slide Page Navigator')),
      body: _buildTransition(),
    );
  }
}

class PageTemplate extends StatelessWidget {
  final String label;
  final void Function(int) onNavigate;

  const PageTemplate({
    super.key,
    required this.label,
    required this.onNavigate,
  });

  int _indexOf(String char) => {'A': 0, 'B': 1, 'C': 2}[char]!;

  @override
  Widget build(BuildContext context) {
    final index = _indexOf(label);
    final others = [0, 1, 2]..remove(index);

    return Container(
      key: ValueKey(label),
      color: [Colors.red, Colors.green, Colors.blue][index],
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Page $label",
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => onNavigate(others[0]),
              child: Text("Go to Page ${String.fromCharCode(65 + others[0])}"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => onNavigate(others[1]),
              child: Text("Go to Page ${String.fromCharCode(65 + others[1])}"),
            ),
          ],
        ),
      ),
    );
  }
}
