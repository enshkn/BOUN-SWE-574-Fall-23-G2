enum DynamicLinkType {
  section(1),
  profile(2),
  referanceCode(3);

  const DynamicLinkType(this.value);
  final int value;

  static DynamicLinkType fromValue(int value) {
    return DynamicLinkType.values.firstWhere((e) => e.value == value);
  }
}
