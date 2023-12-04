/// A wrapper class for managing shared preferences.
library shared_preferences_wrapper;

import 'dart:convert';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart';

typedef PreferenceChangeListener = void Function(String key);

class SharedPreferencesWrapperEncryption {
  static String? _encryptionKey;

  /// Sets the encryption key for SharedPreferencesWrapper.
  ///
  /// The [key] parameter represents the encryption key to be set.
  /// It should have a character length of 16, 24, or 32 for AES encryption.
  ///
  /// Throws an [Exception] if the [key] length is not 16, 24, or 32 characters.
  static void setEncryptionKey(String key) {
    final validKeyLengths = [16, 24, 32];
    int keyLength = key.length;

    if (!validKeyLengths.contains(keyLength)) {
      throw Exception(
          "[SharedPreferencesWrapperEncryption] key length should be 16/24/32 character length.");
    } else {
      _encryptionKey = key;
    }
  }

  /// Retrieves the encryption key set for SharedPreferencesWrapper.
  ///
  /// Returns the encryption key if set, otherwise returns null.
  static String? _getEncryptionKey() {
    return _encryptionKey;
  }
}

class SharedPreferencesWrapper {
  static Map<String, List<VoidCallback>> _listeners = {};

  final String? encryptionKey;
  static Map<String, List<Function(String, dynamic)>> _observers = {};

  SharedPreferencesWrapper._(this.encryptionKey);

  static SharedPreferencesWrapper createInstance() {
    String? encryptionKey =
        SharedPreferencesWrapperEncryption._getEncryptionKey();
    return SharedPreferencesWrapper._(encryptionKey);
  }

  String? _getEncryptionKey() {
    return encryptionKey;
  }

  /// Encrypts the provided [value] using the AES encryption algorithm.
  ///
  /// The [value] parameter represents the string to be encrypted.
  /// The encryption key used is obtained from the SharedPreferencesWrapper instance.
  ///
  /// Returns the Base64-encoded encrypted value.
  String _encryptValue(String value) {
    var instance = SharedPreferencesWrapper.createInstance();
    String encryptionKey = instance._getEncryptionKey()!;

    final key = Key.fromUtf8(encryptionKey);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(value, iv: iv);
    return encrypted.base64;
  }

  /// Decrypts the provided Base64-encoded [encryptedBase64] string.
  ///
  /// The [encryptedBase64] parameter represents the encrypted string in Base64 format.
  /// The decryption key used is obtained from the SharedPreferencesWrapper instance.
  ///
  /// Returns the decrypted value.
  dynamic _decryptValue(String encryptedBase64) {
    var instance = SharedPreferencesWrapper.createInstance();
    String encryptionKey = instance._getEncryptionKey()!;

    final key = Key.fromUtf8(encryptionKey);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final encrypted = Encrypted.fromBase64(encryptedBase64);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }

  /// Adds a string value to shared preferences with the given [key].
  static addString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String newValue = value;
    var instance = SharedPreferencesWrapper.createInstance();
    String? encryptionKey = instance._getEncryptionKey();

    if (encryptionKey != null) {
      String encrypted = instance._encryptValue(value);
      value = encrypted;
    }

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
  static Future<String?> getString(String key, {String? defaultValue}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return string
    String? stringValue = prefs.getString(key);

    var instance = SharedPreferencesWrapper.createInstance();
    String? encryptionKey = instance._getEncryptionKey();
    if (encryptionKey != null && stringValue != null) {
      final decrypted = instance._decryptValue(stringValue);
      stringValue = decrypted;
    }

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

  // Method to register a callback for a specific preference key
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
  /// and the values can be of types String, int, double, bool, List<String>, or Map<String, dynamic>.
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
      _observers[key]!.forEach((observer) {
        observer(key, value);
      });
    }
  }

  /// Sets a value in SharedPreferences identified by [key] based on its data type [value].
  ///
  /// If [value] is of type [String], it sets the string value using [addString].
  /// If [value] is of type [int], it sets the integer value using [addInt].
  /// If [value] is of type [double], it sets the double value using [addDouble].
  /// If [value] is of type [bool], it sets the boolean value using [addBool].
  /// If [value] is of type [List<String>], it sets the list of strings using [addStringList].
  /// If [value] is of type [Map<String, dynamic>], it sets the map using [addMap].
  ///
  /// The [key] represents the identifier for the stored value.
  static setValue(String key, dynamic value) async {
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

  /// Retrieves a value from SharedPreferences identified by [key].
  ///
  /// Returns the stored value corresponding to the [key]. If [defaultValue] is provided
  /// and no value exists for the [key], it returns the [defaultValue].
  ///
  /// The [key] represents the identifier for the stored value.
  /// The optional parameter [defaultValue] specifies the value to return if the [key] is not found.
  static Future<dynamic> getValue(String key, {dynamic defaultValue}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var value = prefs.get(key);
    if (value is String) {
      if (value.contains('[') && value.contains(']')) {
        List<dynamic> result = jsonDecode(value);
        List<String> resultList = result.map((e) => e.toString()).toList();
        value = resultList;
      } else if (value.contains('{') && value.contains('}')) {
        Map<String, dynamic> jsonMap = jsonDecode(value);
        value = jsonMap;
      } else {
        var instance = SharedPreferencesWrapper.createInstance();
        String? encryptionKey = instance._getEncryptionKey();
        if (encryptionKey != null) {
          final decrypted = instance._decryptValue(value);
          value = decrypted;
        }
      }
    }

    value = _setDefaultValue(value, defaultValue);

    return value;
  }
}
