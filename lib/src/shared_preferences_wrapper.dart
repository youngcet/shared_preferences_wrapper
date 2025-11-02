import 'dart:convert';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import '../concrete_namespaced_wrapper.dart';
import 'concrete_shared_prefs_wrapper_builder.dart';
import 'shared_preferences_wrapper_cache_manager.dart';
import '../shared_preferences_wrapper_encryption.dart';

typedef PreferenceChangeListener = void Function(String key);

/// A wrapper class for managing shared preferences in a structured way.
///
/// [SharedPreferencesWrapper] provides convenient methods to interact with
/// the shared preferences storage in Flutter. It supports storing various
/// data types like strings, integers, doubles, booleans, and lists of strings.
/// The class also allows for the use of encryption (AES and Salsa20) to secure
/// the values being stored.
///
/// In addition to basic storage, the class includes functionality to manage
/// event listeners and observers, which can be used to respond to changes
/// in specific keys stored in shared preferences.
///
/// ### Example Usage:
/// ```dart
/// // Add a string value
/// await SharedPreferencesWrapper.setValue('username', 'Alice');
///
/// // Add an integer value
/// await SharedPreferencesWrapper.setValue('age', 30);
///
/// // Get value
/// await SharedPreferencesWrapper.getValue('username');
/// await SharedPreferencesWrapper.getValue('age');
///
/// ```
///
/// ### Features:
/// - Supports storing multiple data types.
/// - Optionally secures stored data using AES and Salsa20 encryption.
/// - Notifies listeners and observers when a preference changes.
///
/// The class uses static methods, so no need to instantiate it for general use.
class SharedPreferencesWrapper {
  static final Map<String, List<VoidCallback>> _listeners = {};
  static final Map<String, List<Function(String, dynamic)>> _observers = {};

  SharedPreferencesWrapper();

  static SharedPreferencesWrapper createInstance() {
    return SharedPreferencesWrapper();
  }

  /// Adds a string value to shared preferences with the given [key].
  static addString(String key, String value,
      {AESEncryption? aesEncryption,
      Salsa20Encryption? salsa20Encryption}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String newValue = value;

    if (aesEncryption != null) {
      aesEncryption.accessKey = key;
      aesEncryption.value = value;
      String encryptedStr = await aesEncryption.encrypt;
      value = encryptedStr;
    }

    if (salsa20Encryption != null) {
      salsa20Encryption.accessKey = key;
      salsa20Encryption.value = value;
      String encryptedStr = await salsa20Encryption.encrypt;
      value = encryptedStr;
    }

    // if (fernetEncryption != null) {
    //   fernetEncryption.value = value;
    //   String encryptedStr = await fernetEncryption.encrypt;
    //   value = encryptedStr;
    // }

    prefs.setString(key, value);

    _notifyListeners(key);
    _notifyObservers(key, newValue);
  }

  /// Adds an integer value to shared preferences with the given [key].
  static addInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
    _notifyListeners(key);
    _notifyObservers(key, value);
  }

  /// Adds a double value to shared preferences with the given [key].
  static addDouble(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
    _notifyListeners(key);
    _notifyObservers(key, value);
  }

  /// Adds a boolean value to shared preferences with the given [key].
  static addBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
    _notifyListeners(key);
    _notifyObservers(key, value);
  }

  /// Adds a list of strings to shared preferences with the given [key].
  static Future<void> addStringList(String key, List<String> myList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(myList);
    prefs.setString(key, jsonString);
    _notifyListeners(key);
    _notifyObservers(key, myList);
  }

  /// Adds a map to shared preferences with the given [key].
  static Future<void> addMap(String key, Map<String, dynamic> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(value);
    prefs.setString(key, jsonString);
    _notifyListeners(key);
    _notifyObservers(key, value);
  }

  /// Retrieves a string value from shared preferences using the given [key].
  static Future<String?> getString(String key,
      {String? defaultValue,
      AESDecryption? aesDecryption,
      Salsa20Decryption? salsa20Decryption}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return string
    String? stringValue = prefs.getString(key);
    if (aesDecryption != null) {
      aesDecryption.accessKey = key;
      aesDecryption.encryptedValue = stringValue!;
      stringValue = await aesDecryption.decrypt;
    }

    if (salsa20Decryption != null) {
      salsa20Decryption.accessKey = key;
      salsa20Decryption.encryptedValue = stringValue!;
      stringValue = await salsa20Decryption.decrypt;
    }

    // if (fernetDecryption != null) {
    //   fernetDecryption.encryptedValue = stringValue!;
    //   stringValue = await fernetDecryption.decrypt;
    // }

    stringValue = _setDefaultValue(stringValue, defaultValue);

    return stringValue;
  }

  /// Retrieves a boolean value from shared preferences using the given [key].
  static getBool(String key, {bool? defaultValue}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool? boolValue = prefs.getBool(key);
    boolValue = _setDefaultValue(boolValue, defaultValue);

    return boolValue;
  }

  /// Retrieves an integer value from shared preferences using the given [key].
  static getInt(String key, {int? defaultValue}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int? intValue = prefs.getInt(key);
    intValue = _setDefaultValue(intValue, defaultValue);

    return intValue;
  }

  /// Retrieves a double value from shared preferences using the given [key].
  static getDouble(String key, {double? defaultValue}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return double
    double? doubleValue = prefs.getDouble(key);
    doubleValue = _setDefaultValue(doubleValue, defaultValue);

    return doubleValue;
  }

  /// Retrieves a list of strings from shared preferences using the given [key].
  static Future<List<String>> getStringList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(key);
    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);
      List<String> myList = jsonList.cast<String>();
      return myList;
    } else {
      return [];
    }
  }

  /// Retrieves a map from shared preferences using the given [key].
  static Future<Map<String, dynamic>?> getMap(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      final map = json.decode(jsonString);
      return map as Map<String, dynamic>;
    }
    return null;
  }

  /// Retrieves a value from a map in shared preferences using the given [key] and [mapKey].
  static Future<dynamic> getMapKey(String key, String mapKey) async {
    Map<String, dynamic>? map = await getMap(key);

    if (map != null) {
      return (map.containsKey(mapKey)) ? map[mapKey] : null;
    }

    return null;
  }

  /// Updates a value in a map in shared preferences using the given [key], [mapKey], and [value].
  static Future<void> updateMapKey(
      String key, String mapKey, dynamic value) async {
    Map<String, dynamic>? map = await getMap(key);

    if (map != null) {
      if (map.containsKey(mapKey)) {
        map[mapKey] = value;
        addMap(key, map);
      }
    }
  }

  /// Updates a map in shared preferences using the given [key] with a new [newMap].
  static Future<void> updateMap(String key, Map<String, dynamic> newMap) async {
    Map<String, dynamic>? map = await getMap(key);

    if (map != null) {
      map.addAll(newMap);
      await addMap(key, map);
    }
  }

  /// Checks if a map in shared preferences with the given [key] contains a specific [mapKey].
  static Future<bool> mapContainsKey(String key, String mapKey) async {
    Map<String, dynamic>? map = await getMap(key);

    if (map != null) {
      return (map.containsKey(mapKey)) ? true : false;
    }

    return false;
  }

  /// Removes a value with the given [key] from a map in shared preferences.
  static Future<void> removeMapKey(String key, String mapKey) async {
    Map<String, dynamic>? map = await getMap(key);

    if (map != null) {
      map.remove(mapKey);
      await addMap(key, map);
    }
  }

  /// Checks if a key exists in shared preferences.
  static Future<bool> keyExists(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool keyExists = prefs.containsKey(key);

    return (keyExists) ? true : false;
  }

  /// Removes a value with the given [key] from shared preferences.
  static Future<void> removeAtKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  /// Removes a values where key starts with the given [key] from shared preferences.
  static Future<void> removeWhereKeyStartsWith(String keyPrefix) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final keys = prefs.getKeys();

    for (var key in keys) {
      if (key.startsWith(keyPrefix)) {
        await prefs.remove(key);
      }
    }
  }

  /// Clears all values from shared preferences.
  static Future<void> clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Retrieves all shared preferences as a map.
  static Future<Map<String, dynamic>> getAllSharedPreferences() async {
    Map<String, dynamic> allPreferences = {};

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();

    for (String key in keys) {
      var value = prefs.get(key);
      allPreferences.addAll({key: value});
    }

    return allPreferences;
  }

  /// Checks if shared preferences is empty.
  static Future<bool> isSharedPreferencesEmpty() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();

    return keys.isEmpty;
  }

  /// Adds a [listener] callback for the given event [key].
  ///
  /// The listener will be called when the event
  /// is triggered by [notifyListeners].
  ///
  /// - Parameters:
  ///   - [key]: The unique identifier for the event.
  ///   - [listener]: The callback to be invoked when the event occurs.
  ///
  /// Example usage:
  /// ```dart
  /// SharedPreferencesWrapper.addListener('key', () {
  ///   print('Event occurred!');
  /// });
  /// ```
  static void addListener(String key, VoidCallback listener) {
    if (!_listeners.containsKey(key)) {
      _listeners[key] = [];
    }
    _listeners[key]?.add(listener);
  }

  // Method to remove a callback for a specific preference key
  static void removeListener(String key, VoidCallback listener) {
    if (_listeners.containsKey(key)) {
      _listeners[key]?.remove(listener);
    }
  }

  // Method to notify listeners/callbacks when a preference value changes
  static void _notifyListeners(String key) {
    if (_listeners.containsKey(key)) {
      _listeners[key]?.forEach((listener) {
        listener();
      });
    }
  }

  /// Adds multiple key-value pairs to the shared preferences in a batch operation.
  ///
  /// The [data] parameter is a map where the keys are strings representing the preference keys
  /// and the values can be of types String, int, double, bool, List, or Map.
  ///
  /// Depending on the type of value, it will be stored in the shared preferences accordingly:
  /// - String values are stored using [SharedPreferences.setString].
  /// - Int values are stored using [SharedPreferences.setInt].
  /// - Double values are stored using [SharedPreferences.setDouble].
  /// - Bool values are stored using [SharedPreferences.setBool].
  /// - List<String> values are stored using [SharedPreferences.setStringList].
  /// - Map<String, dynamic> values are stored after being encoded to a JSON string using [jsonEncode]
  ///   and stored as a String using [SharedPreferences.setString].
  ///
  /// Example usage:
  /// ```dart
  /// SharedPreferencesWrapper.addBatch({
  ///   'key1': 'value1',
  ///   'key2': 42,
  ///   'key3': true,
  ///   'key4': [ 'item1', 'item2' ],
  ///   'key5': { 'nestedKey': 'nestedValue' },
  /// });
  /// ```
  static Future<void> addBatch(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    data.forEach((key, value) {
      if (value is String) {
        prefs.setString(key, value);
      } else if (value is int) {
        prefs.setInt(key, value);
      } else if (value is double) {
        prefs.setDouble(key, value);
      } else if (value is bool) {
        prefs.setBool(key, value);
      } else if (value is List<String>) {
        prefs.setStringList(key, value);
      } else if (value is Map<String, dynamic>) {
        prefs.setString(key, jsonEncode(value));
      }
    });
  }

  /// Updates existing preferences with the provided key-value pairs in a batch operation.
  ///
  /// The [data] parameter is a map where the keys represent the preference keys to be updated,
  /// and the values can be of types String, int, double, bool, List<String>, or Map<String, dynamic>.
  ///
  /// For each key in [data], if the shared preferences contain the key, the value will be updated
  /// using the respective SharedPreferences setter methods (e.g., [SharedPreferences.setString]).
  ///
  /// Example usage:
  /// ```dart
  /// SharedPreferencesWrapper.updateBatch({
  ///   'key1': 'updatedValue1',
  ///   'key2': 50,
  ///   'key3': false,
  /// });
  /// ```
  static Future<void> updateBatch(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    data.forEach((key, value) {
      if (prefs.containsKey(key)) {
        if (value is String) {
          prefs.setString(key, value);
        } else if (value is int) {
          prefs.setInt(key, value);
        } else if (value is double) {
          prefs.setDouble(key, value);
        } else if (value is bool) {
          prefs.setBool(key, value);
        } else if (value is List<String>) {
          prefs.setStringList(key, value);
        } else if (value is Map<String, dynamic>) {
          prefs.setString(key, jsonEncode(value));
        }
      }
    });
  }

  static dynamic _setDefaultValue(dynamic value, dynamic defaultValue) {
    if (value == null) {
      if (defaultValue != null) {
        value = defaultValue;
      }
    }

    return value;
  }

  // Method to add preferences to a specific category/group
  static Future<void> addToGroup(
      String groupName, String key, dynamic value) async {
    final groupExists = await getMap(groupName);
    if (groupExists == null) {
      await addMap(groupName, {});
    }
    await updateMap(groupName, {key: value});
  }

  // Method to retrieve preferences from a specific category/group
  static Future<Map<String, dynamic>?> getGroup(String groupName) {
    final map = getMap(groupName);
    return map;
  }

  // Method to add an observer
  static void addObserver(String key, Function(String, dynamic) callback) {
    if (!_observers.containsKey(key)) {
      _observers[key] = [];
    }
    _observers[key]!.add(callback);
  }

  // Method to remove an observer
  static void removeObserver(String key, Function(String, dynamic) callback) {
    if (_observers.containsKey(key)) {
      _observers[key]!.remove(callback);
    }
  }

  // Method to notify the observer
  static void _notifyObservers(String key, dynamic value) {
    if (_observers.containsKey(key)) {
      for (var observer in _observers[key]!) {
        observer(key, value);
      }
    }
  }

  /// Sets a value in SharedPreferences identified by [key] based on its data type [value].
  ///
  /// It supports storing `String`, `int`, `double`, `bool`, `List<String>`, and `Map<String, dynamic>` values.
  /// The data can optionally be stored with an expiration duration, after which it will be automatically removed.
  ///
  /// ## Parameters:
  /// - `key` (String): The unique key used to identify the stored value.
  /// - `value` (dynamic): The value to be stored. It can be of type `String`, `int`, `double`, `bool`, `List<String>`, or `Map<String, dynamic>`.
  /// - `expirationDuration` (Duration?, optional): The duration for which the stored value will remain valid.
  ///   If `null`, the value will be stored indefinitely.
  ///
  /// ## Throws:
  /// - May throw exceptions related to storage failure (e.g., if storage is not available or the data type is unsupported).
  ///
  /// ## Example:
  /// ```dart
  /// await setValue('user_name', 'John Doe');
  /// await setValue('user_age', 30);
  /// await setValue('user_isLoggedIn', true, expirationDuration: Duration(days: 7));
  /// ```
  static setValue(String key, dynamic value,
      {Duration? expirationDuration}) async {
    if (expirationDuration != null) {
      await cacheData(key, value, expirationDuration);
    } else {
      if (value is String) {
        await addString(key, value);
      } else if (value is int) {
        await addInt(key, value);
      } else if (value is double) {
        await addDouble(key, value);
      } else if (value is bool) {
        await addBool(key, value);
      } else if (value is List<String>) {
        await addStringList(key, value);
      } else if (value is Map<String, dynamic>) {
        await addMap(key, value);
      }
    }
  }

  /// Retrieves a value from SharedPreferences identified by [key].
  ///
  /// Returns the stored value corresponding to the [key]. If [defaultValue] is provided
  /// and no value exists for the [key], it returns the [defaultValue].
  ///
  /// The [key] represents the identifier for the stored value.
  /// The optional parameter [defaultValue] specifies the value to return if the [key] is not found.
  static Future<dynamic> getValue(String key, {dynamic defaultValue}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var cachedData = await getCachedData(key);
    var value = (cachedData != null) ? cachedData : prefs.get(key);
    if (value is String) {
      if (value.contains('[') && value.contains(']')) {
        List<dynamic> result = jsonDecode(value);
        List<String> resultList = result.map((e) => e.toString()).toList();
        value = resultList;
      } else if (value.contains('{') && value.contains('}')) {
        Map<String, dynamic> jsonMap = jsonDecode(value);
        value = jsonMap;
      }
    }

    value = _setDefaultValue(value, defaultValue);

    return value;
  }

  /// Creates and returns a new instance of `SharedPrefsWrapperBuilder`.
  /// This is an asynchronous function that returns a future containing
  /// a new instance of [SharedPrefsWrapperBuilder]. It can be used
  /// to build or initialize shared preferences functionality.
  ///
  /// Example usage:
  /// ```dart
  /// await SharedPreferencesWrapper.getBuilder().then((builder) => {
  ///           builder
  ///               .addBool('builder_bool', true)
  ///               .addDouble('builder_double', 10.0)
  ///               .addString('builder_str', 'str value')
  ///               .addInt('builder_int', 100)
  ///               .addMap('builder_map', {
  ///             'name': 'Yung',
  ///             'lname': 'Cet'
  ///           }).addStringList('builder_list', ['item 1', 'item 2'])
  ///         });
  /// ```
  ///
  /// - Returns: An instance of [SharedPrefsWrapperBuilder].

  static Future<ConcreteSharedPrefsWrapperBuilder> getBuilder() async {
    return ConcreteSharedPrefsWrapperBuilder();
  }

  /// Creates a [NamespacedPreference] instance for the given [namespace].
  ///
  /// This method returns a new instance of [NamespacedPreference], which is
  /// initialized with the specified [namespace]. The namespace helps isolate
  /// shared preferences under a specific name, allowing you to manage them
  /// separately from others.
  ///
  /// Example usage:
  /// ```dart
  /// final userPrefs = SharedPrefsWrapper.createNamespace('userSettings');
  /// await userPrefs.setValue('name', 'John Doe');
  ///
  /// // create another namespace
  /// final appPrefs = SharedPreferencesWrapper.createNamespace('app');
  /// await appPrefs.setValue('dark_mode', true);
  ///
  /// // access the values using getValue() function
  /// String? userName = await userPrefs.getValue('name');
  ///
  /// // clear namespace
  /// await userPrefs.clearNamespace();
  /// ```
  ///
  /// - Parameters:
  ///   - [namespace]: A string representing the unique namespace for the shared preferences.
  ///
  /// - Returns: A new instance of [NamespacedPreference] tied to the given [namespace].
  static ConcreteNamespacedPrefs createNamespace(String namespace) {
    return ConcreteNamespacedPrefs(namespace);
  }

  /// Caches the [data] associated with the given [key] for the specified
  /// [expirationDuration].
  ///
  /// Once the data expires, it will be automatically removed from the
  /// cache.
  ///
  ///   Example usage:
  /// ```dart
  /// await SharedPreferencesWrapper.cacheData('sessionToken', '123abc', Duration(hours: 1));
  /// ```
  ///
  /// - Parameters:
  ///   - [key]: The unique key to store the data under.
  ///   - [data]: The string data to be cached.
  ///   - [expirationDuration]: The duration after which the data will expire.
  ///
  static Future<void> cacheData(
      String key, dynamic data, Duration expirationDuration) async {
    await SharedPreferencesWrapperCacheManager.cacheData(
        key, data, expirationDuration);
  }

  /// Retrieves the cached data associated with the given [key], if it exists
  /// and has not expired.
  ///
  /// If the cached data has expired, it will be removed from the cache, and
  /// `null` will be returned. If no data is found, `null` will also be returned.
  ///
  ///  Example usage:
  /// ```dart
  /// await SharedPreferencesWrapper.getCachedData('sessionToken');
  /// ```
  ///
  /// - Parameters:
  ///   - [key]: The unique key used to retrieve the cached data.
  ///
  /// - Returns: A [Future] that resolves to the cached data, or `null` if no
  /// data is found or the data has expired.
  static Future<dynamic> getCachedData(String key) async {
    return await SharedPreferencesWrapperCacheManager.getCachedData(key);
  }

  /// Clears the cached data associated with the given [key].
  ///
  /// - Parameters:
  ///   - [key]: The unique key of the data to be cleared from the cache.
  ///
  /// Example usage:
  /// ```dart
  /// await SharedPreferencesWrapper.clearCache('sessionToken');
  /// ```
  static Future<void> clearCache(String key) async {
    await SharedPreferencesWrapperCacheManager.clearCache(key);
  }
}
