import 'package:shared_preferences_wrapper/shared_preferences_wrapper.dart';

/// An abstract class that provides namespaced access to SharedPreferences.
///
/// This class allows for storing and retrieving values with a specific namespace
/// prefix to avoid key collisions.
abstract class NamespacedPreferences {
  /// The namespace used as a prefix for keys in SharedPreferences.
  final String namespace;

  /// Creates a [NamespacedPreferences] instance with the given [namespace].
  NamespacedPreferences(this.namespace);

  /// Constructs a namespaced key by prefixing the given [key] with the [namespace].
  ///
  /// [key] is the original key to be prefixed.
  /// Returns the namespaced key.
  String _getKey(String key) => '$namespace.$key';

  /// Adds a string value to SharedPreferences with a namespaced key.
  ///
  /// [key] is the original key.
  /// [value] is the string value to be stored.
  Future<void> setValue(String key, dynamic value) async {
    await SharedPreferencesWrapper.setValue(_getKey(key), value);
  }

  /// Retrieves a value from SharedPreferences with a namespaced key.
  ///
  /// [key] is the original key.
  /// [defaultValue] is the value to be returned if the key does not exist.
  /// Returns the stored value or the [defaultValue] if the key does not exist.
  Future<dynamic> getValue(String key, {dynamic defaultValue}) async {
    return await SharedPreferencesWrapper.getValue(_getKey(key),
        defaultValue: defaultValue);
  }

  /// Clears all values in SharedPreferences that have keys starting with the namespace.
  Future<void> clearNamespace() async {
    await SharedPreferencesWrapper.removeWhereKeyStartsWith('$namespace.');
  }
}
