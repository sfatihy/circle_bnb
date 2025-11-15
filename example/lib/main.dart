import 'package:flutter/material.dart';

import 'package:example/pages/app_home_page.dart';

void main() {
  runApp(
    const App()
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
      ),
      home: const AppHomePage(),
    );
  }
}
