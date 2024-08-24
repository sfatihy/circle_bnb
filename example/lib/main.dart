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

  List<String> pages = [
    "Home",
    "Dashboard",
    "Profile",
    "Explore",
    "Settings",
    "Notifications",
    "Saved",
    "Favorites"
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
                color: Colors.primaries[index2 + index],
                height: MediaQuery.of(context).size.height * 0.5,
                child: Center(
                  child: Text(
                    pages[index],
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
          MediaQuery.of(context).size.height * 0.225
        ),
        colorList: [
          Colors.cyan.shade100,
          Colors.blue,
          Colors.green.shade200,
          Colors.purpleAccent,
        ],
        dragSpeed: 0.05,
        dataList: pages,
        onChangeIndex: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

