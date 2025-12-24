import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class AccessibilityRouteObserver extends NavigatorObserver {
  AccessibilityRouteObserver({Map<String, String>? routeLabels})
      : _routeLabels = routeLabels ??
            const <String, String>{
              'home': 'Home',
              'item': 'Item',
              'item-by-id': 'Item',
              'log': 'Log',
              'web-view': 'Web view',
              'submit': 'Submit',
              'qr-code-scanner': 'QR code scanner',
              'qr-code-view': 'QR code',
            };

  final Map<String, String> _routeLabels;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _announce(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _announce(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _announce(newRoute);
  }

  void _announce(Route<dynamic>? route) {
    if (route == null) return;
    final BuildContext? context = navigator?.context;
    if (context == null) return;
    final String? label = _labelForRoute(route);
    if (label == null || label.isEmpty) return;
    final TextDirection textDirection =
        Directionality.maybeOf(context) ?? TextDirection.ltr;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SemanticsService.announce(label, textDirection);
    });
  }

  String? _labelForRoute(Route<dynamic> route) {
    final String? name = route.settings.name;
    if (name == null || name.isEmpty) return null;
    return _routeLabels[name] ?? _titleCase(name.replaceAll('-', ' '));
  }

  String _titleCase(String input) {
    return input
        .split(' ')
        .where((String part) => part.isNotEmpty)
        .map((String part) =>
            part[0].toUpperCase() + part.substring(1).toLowerCase())
        .join(' ');
  }
}
