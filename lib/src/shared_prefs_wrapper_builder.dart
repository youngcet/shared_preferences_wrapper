import 'shared_preferences_wrapper.dart';

/// A builder class for configuring a `SharedPrefsWrapper` instance with a fluent API.
abstract class SharedPrefsWrapperBuilder {
  /// Creates a new instance of `SharedPrefsWrapperBuilder`.
  SharedPrefsWrapperBuilder();

  /// Adds a string value to the shared preferences with the given key.
  SharedPrefsWrapperBuilder addString(String key, String value) {
    SharedPreferencesWrapper.setValue(key, value);
    return this;
  }

  /// Adds an integer value to the shared preferences with the given key.
  SharedPrefsWrapperBuilder addInt(String key, int value) {
    SharedPreferencesWrapper.setValue(key, value);
    return this;
  }

  /// Adds a boolean value to the shared preferences with the given key.
  SharedPrefsWrapperBuilder addBool(String key, bool value) {
    SharedPreferencesWrapper.setValue(key, value);
    return this;
  }

  /// Adds a double value to the shared preferences with the given key.
  SharedPrefsWrapperBuilder addDouble(String key, double value) {
    SharedPreferencesWrapper.setValue(key, value);
    return this;
  }

  /// Adds a list of strings to the shared preferences with the given key.
  SharedPrefsWrapperBuilder addStringList(String key, List<String> value) {
    SharedPreferencesWrapper.setValue(key, value);
    return this;
  }

  /// Adds a map to the shared preferences with the given key.
  SharedPrefsWrapperBuilder addMap(String key, Map<String, dynamic> value) {
    SharedPreferencesWrapper.setValue(key, value);
    return this;
  }
}
