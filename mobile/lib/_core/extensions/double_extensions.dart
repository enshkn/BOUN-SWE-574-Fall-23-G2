import 'dart:io';

extension DoubleExtensions on double {
  double get correctSize => Platform.isIOS ? this : this * 0.85;
}