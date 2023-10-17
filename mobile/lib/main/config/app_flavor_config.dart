import 'package:flutter/material.dart';

@immutable
class AppFlavorConfig {
  final AppFlavor flavor;
  final String title;
  final ThemeData? theme;
  final bool debugShowCheckedModeBanner;

  const AppFlavorConfig({
    required this.flavor,
    required this.title,
    this.theme,
  }) : debugShowCheckedModeBanner = flavor == AppFlavor.dev;

  factory AppFlavorConfig.initial() {
    return AppFlavorConfig(
      flavor: AppFlavor.dev,
      title: 'Dev',
      theme: ThemeData.light(),
    );
  }
}

enum AppFlavor {
  dev('dev'),
  prod('prod');

  const AppFlavor(this.value);
  final String value;
}
