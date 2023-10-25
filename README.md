
# SharedPreferences Wrapper

A Flutter package that provides a simple wrapper for working with shared preferences. This package simplifies the process of storing and retrieving various data types, including strings, integers, doubles, booleans, lists, and maps in shared preferences.

[![Pub Version](https://img.shields.io/pub/v/shared_preferences_wrapper)](https://pub.dev/packages/shared_preferences_wrapper)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/youngcet/shared_preferences_wrapper/blob/main/LICENSE)

## Features

- Store and retrieve data types like strings, integers, doubles, booleans, lists, and maps in shared preferences.
- Easily update values within a map stored in shared preferences.
- Check for the existence of keys in shared preferences.
- Remove specific keys or clear all data from shared preferences.
- Retrieve all shared preferences as a map.
- Check if shared preferences are empty.

## Installation

To use this package, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  shared_preferences_wrapper: ^1.0.0
```

## Usage

Here's how to use the `SharedPreferencesWrapper` to work with shared preferences:

```dart
import 'package:shared_preferences_wrapper/shared_preferences_wrapper.dart';

// Add a string to shared preferences
SharedPreferencesWrapper.addString('key', 'value');

// Retrieve a string from shared preferences
String? retrievedValue = await SharedPreferencesWrapper.getString('key');
```

Please refer to the example code provided in the package repository for more usage examples.

## Methods

- **addString(String key, String value)**: Adds a string to shared preferences.
- **addInt(String key, int value)**: Adds an int to shared preferences.
- **addDouble(String key, double value)**: Adds a double to shared preferences.
- **addBool(String key, bool value)**: Adds a bool to shared preferences.
- **addStringList(String key, List<String> myList)**: Adds a list of strings to shared preferences.
- **addMap(String key, Map<String, dynamic> value)**: Adds a map to shared preferences.
- **getString(String key)**: Gets a string from shared preferences.
- **getBool(String key)**: Gets a bool from shared preferences.
- **getInt(String key)**: Gets an int from shared preferences.
- **getDouble(String key)**: Gets a double from shared preferences.
- **getStringList(String key)**: Gets a list of strings from shared preferences.
- **getMap(String key)**: Gets a map from shared preferences.
- **getMapKey(String key, String mapKey)**: Gets a key-value pair from a map in shared preferences.
- **updateMapKey(String key, String mapKey, dynamic value)**: Updates a key-value pair in a map in shared preferences.
- **updateMap(String key, Map<String, dynamic> newMap)**: Updates a map in shared preferences.
- **mapContainsKey(String key, String mapKey)**: Checks if a key exists in a map in shared preferences.
- **removeMapKey(String key, String mapKey)**: Removes a key-value pair from a map in shared preferences.
- **keyExists(String key)**: Checks if a key exists in shared preferences.
- **removeAtKey(String key)**: Removes a key from shared preferences.
- **clearAll()**: Clears all shared preferences.
- **getAllSharedPreferences()**: Gets all shared preferences.
- **isSharedPreferencesEmpty()**: Checks if shared preferences is empty.

## Contributing

If you have ideas or improvements for this package, we welcome contributions. Please open an issue or create a pull request on our [GitHub repository](https://github.com/youngcet/shared_preferences_wrapper).

## License

This package is available under the [MIT License](https://github.com/youngcet/shared_preferences_wrapper/blob/main/LICENSE).