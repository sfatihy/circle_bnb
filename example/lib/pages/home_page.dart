import 'package:flutter/material.dart';

import '../providers/index_provider.dart';

import 'package:circle_bnb/circle_bnb.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final List<CircleBNBItem> pages = [
    CircleBNBItem(title: "Home", icon: Icons.home_outlined),
    CircleBNBItem(title: "Dashboard", icon: Icons.dashboard_outlined),
    CircleBNBItem(title: "Profile", icon: Icons.person_outlined),
    CircleBNBItem(title: "Explore", icon: Icons.explore_outlined),
    CircleBNBItem(title: "Settings", icon: Icons.settings_outlined),
    CircleBNBItem(title: "Notifications", icon: Icons.notifications_outlined),
    CircleBNBItem(title: "Saved", icon: Icons.bookmark_outline_outlined),
    CircleBNBItem(title: "Favorites", icon: Icons.favorite_outline_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final indexNotifier = IndexProvider.of(context);

    return ValueListenableBuilder<int>(
      valueListenable: indexNotifier,
      builder: (context, currentIndex, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Circle BNB',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.primaries[currentIndex % Colors.primaries.length],
            surfaceTintColor: Colors.transparent,
          ),
          body: IndexedStack(
            index: currentIndex,
            children: List.generate(
              pages.length,
              (index) => ListView(
                children: List.generate(
                  pages.length,
                  (index2) => Container(
                    color: Colors.primaries[(index + index2) % Colors.primaries.length],
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        pages.length,
                        (index3) => Text(
                          pages[index3].title,
                          style: TextStyle(color: index3 == currentIndex ? Colors.white : Colors.white24),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          extendBody: true,
          backgroundColor: Colors.primaries[currentIndex % Colors.primaries.length],
          bottomNavigationBar: CircleBNB(
            navigationStyle: NavigationStyle.circular,
            linearItemCount: 5,
            size: Size(MediaQuery.of(context).size.width * 0.75, MediaQuery.of(context).size.height * 0.25),
            dragSpeed: 0.05,
            items: pages,
            onChangeIndex: (index) {
              indexNotifier.index = index;
            },
          ),
        );
      },
    );
  }
}
