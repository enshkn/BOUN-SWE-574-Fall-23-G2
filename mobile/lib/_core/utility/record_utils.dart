extension RecordExtension<L, R> on (L?, R?) {
  E fold<E>(E Function(L? l) left, E Function(R r) right) {
    if (this.$1 == null) {
      return right(this.$2 as R);
    } else {
      return left(this.$1);
    }
  }
}

(L?, R?) right<L, R>(R? right) {
  return (null, right);
}

(L?, R?) left<L, R>(L? left) {
  return (left, null);
}
