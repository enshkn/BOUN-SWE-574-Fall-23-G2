import 'package:hive_flutter/hive_flutter.dart';

abstract class ICacheManager<T> {
  ICacheManager(this.key);
  final String key;
  Box<T>? _box;
  Box<T>? get box => _box;

  Future<void> init() async {
    registerAdapters();
    if (!(_box?.isOpen ?? false)) {
      _box = await Hive.openBox(key);
    }
  }

  Future<void> setData(T data);
  Future<void> putAll(List<T> items);
  T? getData() {
    return null;
  }

  List<T>? getValues() {
    return null;
  }

  Future<void> removeItem(String key);
  Future<void> clearAll() async {
    await _box?.clear();
  }

  void registerAdapters();
}
