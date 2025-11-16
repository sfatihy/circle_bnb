import 'package:flutter/material.dart';

import 'package:circle_bnb/circle_bnb.dart';

class AppHomePage extends StatefulWidget {
  const AppHomePage({super.key});

  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {

  int _bnbIndex = 0;
  NavigationStyle _navigationStyle = NavigationStyle.circular;
  final List<CircleBNBItem> _items = [
    CircleBNBItem(title: "Home", icon: Icons.home_outlined),
    CircleBNBItem(title: "Dashboard", icon: Icons.dashboard_outlined),
    CircleBNBItem(title: "Profile", icon: Icons.person_outlined),
    CircleBNBItem(title: "Explore", icon: Icons.explore_outlined),
    CircleBNBItem(title: "Settings", icon: Icons.settings_outlined),
    CircleBNBItem(title: "Notifications", icon: Icons.notifications_outlined),
    CircleBNBItem(title: "Saved", icon: Icons.bookmark_outline_outlined),
    CircleBNBItem(title: "Favorites", icon: Icons.favorite_outline_outlined),
    CircleBNBItem(title: "Saved", icon: Icons.bookmark_outline_outlined),
    CircleBNBItem(title: "Favorites", icon: Icons.favorite_outline_outlined),
  ];

  void setBnbIndex(int index) {
    if (index != _bnbIndex) {
      setState(() {
        _bnbIndex = index;
      });
    }
  }

  void incrementItems() {
    final newItem = CircleBNBItem(
      title: 'Item ${_items.length + 1}',
      icon: Icons.add_circle_outline,
    );
    setState(() {
      _items.add(newItem);
      _bnbIndex = 0;
    });
  }

  void decrementItems() {
    if (_items.length > 5) {
      setState(() {
        _items.removeLast();
        if (_bnbIndex >= _items.length) {
          _bnbIndex = _items.length - 1;
        }
        _bnbIndex = 0;
      });
    }
    if (_items.length == 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Minimum 5 items required'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_items[_bnbIndex].title),
        centerTitle: true,
        backgroundColor: Colors.primaries[_bnbIndex % Colors.primaries.length],
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 96),
          child: ColoredBox(
            color: Colors.primaries[_bnbIndex % Colors.primaries.length],
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton.filledTonal(
                      icon: const Icon(Icons.exposure_minus_1),
                      onPressed: _items.length > 5 ? decrementItems : null,
                      style: IconButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.primaries[_bnbIndex % Colors.primaries.length].shade900
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'CircleBNBItem Count',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.primaries[_bnbIndex % Colors.primaries.length].shade900,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          '${_items.length}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.primaries[_bnbIndex % Colors.primaries.length].shade900,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    IconButton.filledTonal(
                      icon: const Icon(Icons.exposure_plus_1),
                      onPressed: incrementItems,
                      style: IconButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.primaries[_bnbIndex % Colors.primaries.length].shade900
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 4,
                  children: [
                    SizedBox(
                      width: 48,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Linear',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.primaries[_bnbIndex % Colors.primaries.length].shade900,
                            fontWeight: _navigationStyle == NavigationStyle.linear
                              ? FontWeight.bold
                              : FontWeight.normal
                          ),
                        ),
                      ),
                    ),
                    Switch(
                      value: _navigationStyle == NavigationStyle.circular,
                      onChanged: (value) {
                        setState(() {
                          _navigationStyle = value ? NavigationStyle.circular : NavigationStyle.linear;
                        });
                      },
                      activeColor: Colors.primaries[_bnbIndex % Colors.primaries.length].shade900,
                      inactiveThumbColor: Colors.primaries[_bnbIndex % Colors.primaries.length].shade900,
                      inactiveTrackColor: Colors.white.withValues(alpha: 0.75),
                    ),
                    SizedBox(
                      width: 48,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Circular',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.primaries[_bnbIndex % Colors.primaries.length].shade900,
                            fontWeight: _navigationStyle == NavigationStyle.circular
                              ? FontWeight.bold
                              : FontWeight.normal
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: _bnbIndex,
        children: List.generate(
          _items.length,
          (index) => ListView(
            children: List.generate(
              _items.length,
              (index2) => Container(
                color: Colors.primaries[(index + index2) % Colors.primaries.length],
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _items.length,
                    (index3) => Text(
                      _items[index3].title,
                      style: TextStyle(color: index3 == _bnbIndex ? Colors.white : Colors.white24),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      extendBody: true,
      backgroundColor: Colors.primaries[_bnbIndex % Colors.primaries.length],
      bottomNavigationBar: CircleBNB(
        key: ValueKey('${_items.length}_$_navigationStyle'),
        navigationStyle: _navigationStyle,
        linearItemCount: 5,
        dragSpeed: 0.05,
        items: _items,
        colorList: const [
          Color(0xFFFF9B54),
          Color(0xFFFF7F51),
          Color(0xFFCE4257),
          Color(0xFF720026),
        ],
        linearBackgroundColor: const Color(0xFFFF9B54),
        selectedIconColor: Colors.black87,
        unselectedIconColor: Colors.black38,
        selectedTextStyle: const TextStyle(
          color: Color(0xFF4F000B),
          fontWeight: FontWeight.bold,
        ),
        unselectedTextStyle: const TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.normal,
        ),
        onChangeIndex: setBnbIndex,
      ),
    );
  }
}
