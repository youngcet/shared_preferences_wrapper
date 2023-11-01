/// A wrapper class for managing shared preferences.
library shared_preferences_wrapper;

import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SharedPreferencesWrapper {
  /// Adds a string value to shared preferences with the given [key].
  static addString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  /// Adds an integer value to shared preferences with the given [key].
  static addInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  /// Adds a double value to shared preferences with the given [key].
  static addDouble(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  /// Adds a boolean value to shared preferences with the given [key].
  static addBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  /// Adds a list of strings to shared preferences with the given [key].
  static Future<void> addStringList(String key, List<String> myList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(myList);
    prefs.setString(key, jsonString);
  }

  /// Adds a map to shared preferences with the given [key].
  static Future<void> addMap(String key, Map<String, dynamic> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(value);
    await prefs.setString(key, jsonString);
  }

  /// Retrieves a string value from shared preferences using the given [key].
  static Future<String?> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return string
    String? stringValue = prefs.getString(key);
    return stringValue;
  }

  /// Retrieves a boolean value from shared preferences using the given [key].
  static getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool? boolValue = prefs.getBool(key);
    return boolValue;
  }

  /// Retrieves an integer value from shared preferences using the given [key].
  static getInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int? intValue = prefs.getInt(key);
    return intValue;
  }

  /// Retrieves a double value from shared preferences using the given [key].
  static getDouble(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return double
    double? doubleValue = prefs.getDouble(key);
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

  static Future<String> getCloudStorageToken() async{
    final currentDateTime = DateTime.now();
    final oneHourLater = currentDateTime.add(const Duration(hours: 1));

    final currentTimestamp = currentDateTime.millisecondsSinceEpoch ~/ 1000;
    final oneHourLaterTimestamp = oneHourLater.millisecondsSinceEpoch ~/ 1000;

    var data = {
      'payload': {
        'iss': 'shared_preferences_wrapper',
        'aud': 'https://permanentlink.co.za/api/v1/flutter/shared_preferences_wrapper/cloud_storage',
        'iat': currentTimestamp,
        'exp': oneHourLaterTimestamp,
      },
    };

    final results = await http.post(
      Uri.parse('https://permanentlink.co.za/api/v1/flutter/shared_preferences_wrapper/cloud_storage_auth'), 
      headers: <String, String>{
        'Content-Type': 'application/json',
        'APIKEY': 'ed47d3d45bd9e52b7fdb06f7a94bbe7e',
      },
      body: jsonEncode(data)
    );

    inspect(results);

    return '';
  }
}
