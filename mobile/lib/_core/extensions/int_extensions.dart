extension IntExtensions on int {
  String getLimitStr(int val) {
    if (this > val) {
      return '$val+';
    } else {
      return '$this';
    }
  }
}
