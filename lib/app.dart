import 'package:flutter/material.dart';
import 'package:firefly/core/themes/app_theme.dart';
import 'package:firefly/presentation/pages/main/main_page.dart';
import 'package:firefly/presentation/router/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firefly',
      theme: AppTheme.darkTheme,
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter().generateRoute,
    );
  }
}
