import 'package:flutter/material.dart';

class PageViewNavigator extends StatefulWidget {
  const PageViewNavigator({super.key});

  @override
  State<PageViewNavigator> createState() => _PageViewNavigatorState();
}

class _PageViewNavigatorState extends State<PageViewNavigator> {
  late final PageController _pageController;
  int _currentPage = 0;

  final List<String> _labels = ['A', 'B', 'C'];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  void _goToPage(int index) {
    if (index == _currentPage) return;
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() => _currentPage = index);
  }

  Widget _buildPage(String label) {
    final currentIndex = _labels.indexOf(label);
    final otherPages = List.generate(3, (i) => i)..remove(currentIndex);

    return Container(
      key: ValueKey(label),
      color: [Colors.red, Colors.green, Colors.blue][currentIndex],
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
              onPressed: () => _goToPage(otherPages[0]),
              child: Text("Go to Page ${_labels[otherPages[0]]}"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _goToPage(otherPages[1]),
              child: Text("Go to Page ${_labels[otherPages[1]]}"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PageView Navigator')),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(), // disable swipe
        children: _labels.map(_buildPage).toList(),
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
      ),
    );
  }
}
