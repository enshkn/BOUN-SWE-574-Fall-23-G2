// ignore_for_file: prefer_single_quotes

extension StringExtensions on String {
  String get toSvg => 'assets/svg/$this.svg';

  String checkLength(int value) {
    if (length > value) {
      return '${substring(0, value)}...';
    } else {
      return this;
    }
  }

  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String toCamelCase() {
    return split('_')
        .map(
          (e) => "${e[0].toUpperCase()}${e.substring(1)}",
        )
        .join();
  }

  bool get isValidEmail => RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      ).hasMatch(this);
}

extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this == null || (this?.isEmpty ?? false);
}
