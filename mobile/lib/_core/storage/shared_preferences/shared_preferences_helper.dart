import 'package:shared_preferences/shared_preferences.dart';

// Helper class for Shared Preferences
class SharedPreferencesHelper {
  static late SharedPreferences _preferences;

  /// Init method to asynchronously get Shared Preferences object
  ///
  /// Usage example:
  ///
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///
  ///   await SharedPreferencesHelper.init();
  ///
  ///   runApp(MyApp());
  /// }
  /// ```
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// Getter method to retrieve the Shared Preferences object
  static SharedPreferences get preferences => _preferences;

  /// Set method: takes key, value and preference type as parameters
  ///
  /// [key]: the key value of the shared preference
  /// [value]: the value to be set in the shared preference
  /// [type]: the data type of the shared preference (bool, double, int, string, string list)
  ///
  /// Usage example:
  ///
  /// ```dart
  /// SharedPreferencesHelper.set('isDarkModeEnabled', true, PreferenceType.boolType);
  /// ```
  ///
  static Future<bool> set<T>(String key, T value, PreferenceType type) {
    // switch-case block to perform the set operation based on data type
    switch (type) {
      case PreferenceType.boolType:
        return _preferences.setBool(key, value as bool);
      case PreferenceType.doubleType:
        return _preferences.setDouble(key, value as double);
      case PreferenceType.intType:
        return _preferences.setInt(key, value as int);
      case PreferenceType.stringType:
        return _preferences.setString(key, value as String);
      case PreferenceType.stringListType:
        return _preferences.setStringList(key, value as List<String>);
    }
  }

  /// Get method: takes key, preference type, and an optional default value as parameters
  ///
  /// [key]: the key value of the shared preference
  /// [type]: the data type of the shared preference (bool, double, int, string, string list)
  /// [defaultValue]: the default value to be returned if the shared preference is not found
  ///
  /// Usage example:
  ///
  /// ```dart
  /// bool isDarkModeEnabled = SharedPreferencesHelper.get('isDarkModeEnabled', PreferenceType.boolType, false)!;
  /// ```
  ///
  static T? get<T>(String key, PreferenceType type, [T? defaultValue]) {
    // switch-case block to perform the get operation based on data type
    switch (type) {
      case PreferenceType.boolType:
        return _preferences.getBool(key) as T?;
      case PreferenceType.doubleType:
        return _preferences.getDouble(key) as T?;
      case PreferenceType.intType:
        return _preferences.getInt(key) as T?;
      case PreferenceType.stringType:
        return _preferences.getString(key) as T?;
      case PreferenceType.stringListType:
        return _preferences.getStringList(key) as T?;
    }
  }
}

// Enumeration to represent the data type of a shared preference
enum PreferenceType {
  boolType,
  doubleType,
  intType,
  stringType,
  stringListType
}
