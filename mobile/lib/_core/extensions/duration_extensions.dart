extension DurationExtensions on Duration {
  /// Returns the duration in milliseconds.
  Duration difference(Duration other) {
    return Duration(milliseconds: inMilliseconds - other.inMilliseconds);
  }
}