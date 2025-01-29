import 'src/namespaced_preferences.dart';

/// A concrete implementation of [NamespacedPreferences].
///
/// This class allows for namespaced access to SharedPreferences.
///
/// [namespace] is the prefix used for keys in SharedPreferences.
class ConcreteNamespacedPrefs extends NamespacedPreferences {
  /// Creates a [ConcreteNamespacedPrefs] instance with the given [namespace].
  ///
  /// [namespace] is the prefix used for keys in SharedPreferences.
  ConcreteNamespacedPrefs(super.namespace);
}
