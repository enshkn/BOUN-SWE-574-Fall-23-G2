enum FlavorTypes {
  dev('dev'),
  prod('prod'),
  staging('staging');

  const FlavorTypes(this.value);
  final String value;

  static FlavorTypes fromValue(String value) {
    return FlavorTypes.values.firstWhere((el) => el.value == value);
  }
}
