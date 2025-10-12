import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'providers/index_provider.dart';
import 'state/index_notifier.dart';

void main() {
  runApp(
    IndexProvider(
      indexNotifier: IndexNotifier(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        highlightColor: Colors.transparent,
        splashColor: Colors.blue.shade200,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.blue,
          selectedLabelStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600
          ),
          unselectedItemColor: Colors.black38,
          unselectedLabelStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w300
          ),
          showUnselectedLabels: true,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        )
      ),
      home: const HomePage(),
    );
  }
}
