import 'package:flutter/material.dart';

class Provider {
  static T of<T extends ChangeNotifier>(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<_InheritedProvider<T>>();
    if (provider == null) {
      throw Exception('No $T provider found in context');
    }
    return provider.value;
  }
}

class MultiProvider extends StatelessWidget {
  final List<ChangeNotifierProvider> providers;
  final Widget child;

  const MultiProvider({
    super.key,
    required this.providers,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget current = child;
    for (final provider in providers.reversed) {
      current = provider;
    }
    return current;
  }
}

class ChangeNotifierProvider extends StatefulWidget {
  final ChangeNotifier value;
  final Widget child;

  const ChangeNotifierProvider.value({
    super.key,
    required this.value,
    required this.child,
  });

  @override
  State<ChangeNotifierProvider> createState() => _ChangeNotifierProviderState();
}

class _ChangeNotifierProviderState extends State<ChangeNotifierProvider> {
  @override
  Widget build(BuildContext context) {
    return _InheritedProvider<ChangeNotifier>(
      value: widget.value,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    widget.value.dispose();
    super.dispose();
  }
}

class _InheritedProvider<T extends ChangeNotifier> extends InheritedWidget {
  final T value;

  const _InheritedProvider({
    required this.value,
    required super.child,
  });

  @override
  bool updateShouldNotify(_InheritedProvider<T> oldWidget) {
    return true;
  }
}