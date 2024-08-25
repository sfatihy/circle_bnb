import 'package:flutter/material.dart';

import 'package:circle_bnb/circle_bnb.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 0;

  List<CircleBNBItem> pages = [
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Circle BNB',
          style: TextStyle(
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.primaries[_currentIndex],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: List.generate(
          pages.length, (index) => ListView(
            children: List.generate(
              pages.length,
              (index2) => Container(
                color: Colors.primaries[(index + index2 >= 17) ? index2 : index + index2],
                height: MediaQuery.of(context).size.height * 0.5,
                child: Center(
                  child: Text(
                    pages[index].title,
                    style: const TextStyle(
                      color: Colors.white
                    ),
                  )
                ),
              ),
            )
          )
        )
      ),
      extendBody: true,
      backgroundColor: Colors.primaries[_currentIndex],
      bottomNavigationBar: CircleBNB(
        size: Size(
          MediaQuery.of(context).size.width * 0.75,
          MediaQuery.of(context).size.height * 0.235
        ),
        dragSpeed: 0.05,
        items: pages,
        onChangeIndex: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

