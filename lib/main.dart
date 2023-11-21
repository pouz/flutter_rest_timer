import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

import 'route.dart';

const double windowWidth = 500;
const double windowHeight = 400;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      setWindowTitle('PJ Timer');
      setWindowMaxSize(const Size(windowWidth, windowHeight));
      setWindowMinSize(const Size(windowWidth, windowHeight));
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PJ Timer',
      debugShowCheckedModeBanner: false,
      theme: mainTheme,
      routerConfig: AppRoute.router,
    );
  }
}

ThemeData mainTheme = ThemeData(
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  hoverColor: Colors.transparent,
);
