enum FavoriteType {
  story('Story'),
  comment('Comment');

  const FavoriteType(this.value);
  final String value;

  static FavoriteType fromValue(String value) {
    return FavoriteType.values.firstWhere((el) => el.value == value);
  }
}
