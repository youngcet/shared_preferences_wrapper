
# SharedPreferences Wrapper

A Flutter package that provides a simple wrapper for working with shared preferences. This package simplifies the process of storing and retrieving various data types, including strings, integers, doubles, booleans, lists, and maps in shared preferences.

[![Pub Version](https://img.shields.io/pub/v/shared_preferences_wrapper)](https://pub.dev/packages/shared_preferences_wrapper)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/youngcet/shared_preferences_wrapper/blob/main/LICENSE)

## Features

- Store and retrieve data types like strings, integers, doubles, booleans, lists, and maps in shared preferences.
- Set default values for **string, bool, double, int** data types.
- Easily update values within a map stored in shared preferences.
- Check for the existence of keys in shared preferences.
- Remove specific keys or clear all data from shared preferences.
- Retrieve all shared preferences as a map.
- Check if shared preferences are empty.
- Encrypt/Decrypt sensitive data stored in shared preferences.
- Add or update multiple key-value pairs in a single batch operation.
- Add or remove listeners for shared preference changes.
- Organize preferences based on specific groups or categories.
- Namespace Support: Implement namespaces for easier management of different sets of preferences.
- A fluent API for chaining multiple operations in a more readable manner.

## Supported Data Types
- **String**
- **int**
- **double**
- **bool**
- **String List**
- **Map**

## Installation

To use this package, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  shared_preferences_wrapper: ^your_version_here
```

## Usage

Here's how to use the `SharedPreferencesWrapper` to work with shared preferences:

### Using single functions to set and retrieve data
```dart
import 'package:shared_preferences_wrapper/shared_preferences_wrapper.dart';

// set a string value
await SharedPreferencesWrapper.setValue('name', 'Yung');
// retrieving a value by key
final val = await SharedPreferencesWrapper.getValue('name');
print(val); // output Yung

// setting different data types
// set an int value
await SharedPreferencesWrapper.setValue('qty', 10);
final qty = await SharedPreferencesWrapper.getValue('qty');

// set a double value
await SharedPreferencesWrapper.setValue('amount', 4.5);
final amount = await SharedPreferencesWrapper.getValue('amount');

// set a bool value
await SharedPreferencesWrapper.setValue('processed', true);
final processed = await SharedPreferencesWrapper.getValue('processed');

// set a string list
await SharedPreferencesWrapper.setValue('items', ['item 1', 'item 2']);
final items = await SharedPreferencesWrapper.getValue('items');

// set a map
await SharedPreferencesWrapper.setValue('user', {'name': 'Yung', 'lname': 'Cet'});
final user = await SharedPreferencesWrapper.getValue('user');
```

#### Setting a default value in getValue()
You can specify a default value for when a key does not exist in shared preferences instead of returning null. This can be set for any of the supported data types above.
```dart
final name = await SharedPreferencesWrapper.getValue('name', defaultValue: '');
```

### Using specific functions based on data type
```dart
import 'package:shared_preferences_wrapper/shared_preferences_wrapper.dart';

// storing values
// note: refer to the methods section for methods that store other data types
await SharedPreferencesWrapper.addString('key', 'value'); // storing strings
await SharedPreferencesWrapper.addInt('int', 100);    // storing int
await SharedPreferencesWrapper.addDouble('double', 10.0);   // storing double
await SharedPreferencesWrapper.addBool('bool', true);   // storing bool
await SharedPreferencesWrapper.addStringList('list', ['item 1', 'item 2', 'item 3']);   // storing lists
await SharedPreferencesWrapper.addMap('map', {'key': 'value'});   // storing map

// Retrieve a string from shared preferences
// note: refer to the methods section for methods that store other data types
String? retrievedValue = await SharedPreferencesWrapper.getString('key');
int? intValue = await SharedPreferencesWrapper.getInt('int');
double? value = await SharedPreferencesWrapper.getDouble('key');
bool? value = await SharedPreferencesWrapper.getBool('key');
List<String> value = await SharedPreferencesWrapper.getStringList('key');
Map<String, dynamic>? value = await SharedPreferencesWrapper.getMap('key');
```

## Setting default values
You can set default values that should be returned instead of null for **string, int, bool, double** data types.

```dart
// returns empty string instead of null
String? stringValue = await SharedPreferencesWrapper.getString('myKey', defaultValue: '');

// returns 0 instead of null
int? intValue = await SharedPreferencesWrapper.getInt('myKey', defaultValue: 0);

// returns 0.0 instead of null
double? doubleValue = await SharedPreferencesWrapper.getDouble('myKey', defaultValue: 0.0);

// returns false instead of null
bool? boolValue = await SharedPreferencesWrapper.getBool('myKey', defaultValue: false);
```

## Using Namespaces
Implementing namespace support in the `shared_preferences_wrapper` package can help you organize and manage different sets of preferences more effectively. This is simmiliar to groups.

```dart
// create the namespace
final userPrefs = SharedPreferencesWrapper.createNamespace('user');

// set the value in the namespace, NOTICE that the value is set in userPrefs and not 'SharedPreferencesWrapper'
await userPrefs.setValue('name', 'John Doe'); // the value can be any of the supported data types

// get the value, NOTICE that the value is retrieved in userPrefs and not 'SharedPreferencesWrapper'
String? userName = await userPrefs.getValue('name');
print('name: $userName');

// to get clear the namespace
await userPrefs.clearNamespace();

// create another namespace
final appPrefs = SharedPreferencesWrapper.createNamespace('app');
await appPrefs.setValue('dark_mode', true);

bool? mode = await appPrefs.getValue('dark_mode');
print('mode: $mode');
```

## Method Chaining
Implement a builder for chaining multiple operations in a more readable manner.

```dart
// create the builder and chain methods together
await SharedPreferencesWrapper.getBuilder().then((builder) => {
  builder
      .addBool('is_logged_in', true)
      .addDouble('amount', 10.0)
      .addString('account', 'Prestige')
      .addInt('quantity', 100)
      .addMap('users', {'name': 'Yung','lname': 'Cet'})
      .addStringList('items', ['item 1', 'item 2'])
});

// to get the value above, you can use the specific method for the data type or getValue()
final is_logged_in =
          await SharedPreferencesWrapper.getValue('is_logged_in');
      print('is_logged_in: $is_logged_in');
```

### Checking if a key exists
Checks if a key exists in shared preferences
```dart
bool? exists = await SharedPreferencesWrapper.keyExists('key');
if (exists){
  print('key exists');
}else{
  print('key does not exist');
}
```

### Clearing all preferences
This clears all the stored shared preferences
```dart
await SharedPreferencesWrapper.clearAll();
```

### Checking if shared preferences are empty
```dart
bool? isEmpty = await SharedPreferencesWrapper.isSharedPreferencesEmpty();
if (isEmpty){
  print('shared preferences are not empty');
}else{
  print('shared preferences are empty');
}
```

### Removing a key
```dart
await SharedPreferencesWrapper.removeAtKey('key');
```

### Retrieving all preferences stored
This returns all preferences stored
```dart
Map<String, dynamic> allPreferences = await SharedPreferencesWrapper.getAllSharedPreferences();
print(allPreferences);
```

## Working with Maps
### Storing a map
```dart
await SharedPreferencesWrapper.addMap('mapKey', {
      'name': 'Yung',
      'age': 30,
      'isStudent': true,
    });
```

### Retrieving a map
```dart
Map<String, dynamic>? value = await SharedPreferencesWrapper.getMap('mapKey');
print(value);
```

### Retrieve a value from the map on a specific key
```dart
dynamic value = await SharedPreferencesWrapper.getMapKey('mapKey', 'name');
print('value'); // output: Yung
```

### Updating a map
You can update an existing map by adding new items to it
```dart
await SharedPreferencesWrapper.updateMap('mapKey', {'surname': 'Cet'});
```

The updated map now looks like this
```dart
{
  'name': 'Yung',
  'age': 30,
  'isStudent': true,
  'surname': 'Cet'  // new item added
}
```

### Updating a value inside a map with a specific key
You can update a value inside a map for a specific key
```dart
// this updates the age value to 40
await SharedPreferencesWrapper.updateMapKey('mapKey', 'age', 40);
```

### Checking if a key inside a map exists
```dart
final value = await SharedPreferencesWrapper.mapContainsKey('mapKey', 'mapKeyToCheck');
if (value){
  print('key exists');
}else{
  print('key does not exist');
}
```

### Removing a key inside a map
```dart
await SharedPreferencesWrapper.removeMapKey('mapKey', 'mapKeyToRemove');
```

## Single Batch Operation
Add or update multiple key-value pairs in a single batch operation

```dart
// Adding multiple preferences at once
Map<String, dynamic> dataToAdd = {
  'key1': 'value1',
  'key2': 42,
  'key3': true,
  'key4': ['item1', 'item2'],
  'key5': {'nestedKey': 'nestedValue'},
  // Add more key-value pairs as needed
};

await SharedPreferencesWrapper.addBatch(dataToAdd);

// access the batch data normally as you would, 
//take note of the data type stored to call the correct corresponding method
bool boolValue = await SharedPreferencesWrapper.getBool('key3');
int intValue = await SharedPreferencesWrapper.getInt('key2');

// Updating existing preferences in batch
Map<String, dynamic> dataToUpdate = {
  'key3': false,
  'key2': 100,
  // Update other keys as needed
};
await SharedPreferencesWrapper.updateBatch(dataToUpdate);
```

## Working with Listeners
Listeners serve as the intermediaries that facilitate communication between different parts of a system, allowing components to react and respond to changes without direct coupling between them.

There are two ways to add listeners.

1) Using **addListener()** method
```dart
// define a function to handle the preference change
void handleChangeListener() {
  print("Listener triggered!");
}

@override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      // Registering Listeners with callback function for when a shared preference changes
      SharedPreferencesWrapper.addListener('key', handleChangeListener);
    });
}
```

You can also define a callback function inline as below, however, if you're planning on removing the listener at some point it is better to define a callback function as shown above to ensure that the function signatures are the same.

```dart
SharedPreferencesWrapper.addListener('key', () {
  print("Preference with key changed!");
});
```

Removing a listener from **addListener()**
```dart
// define a function to handle the preference change
void handleChangeListener() {
  print("Listener triggered!");
}

@override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      SharedPreferencesWrapper.removeListener('key', handleChangeListener);
    });
}
```

2) Using **addObserver()** method
```dart
// Function to observe changes
Function(String, dynamic) handleObserverChanges = (String key, dynamic newValue) {
  print("Observer triggered with data: key=$key value=$newValue");
};

@override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
        // Add an observer
      SharedPreferencesWrapper.addObserver('observer', handleObserverChanges);
    });
}
```

Removing listeners from **addObserver()**
```dart
SharedPreferencesWrapper.removeObserver('observer', handleObserverChanges);
```

## Shared Preferences Wrapper Encryption
Shared preferences wrapper encryption allows encrypting and decrypting of sensetive data using a secret key. This can only be applied to `String` data types.

There are two types of encryption to choose from:

- **AES**
- **Salsa20**

### <span style="color:red">DEPRICATED</span>
This method of setting the encryption has been depricated and is no longer supported. Please refer to the sections below this section for a new way of implementing encryption.

- **setEncryptionKey(String key)**: Sets an encryption key to encrypt and decrypt sensitive data stored in shared preferences. **CURRENTLY ONLY STRINGS ARE SUPPORTED.** This means that when the key is set, it will be applied to only String data types when adding and retrieving strings.
```dart
// set an encryption key, this has to be 16/24/32 character long
// NOTE: you must set the encryption key before storing strings in shared preferences
// This will apply to all string data types stored if the encryption key is set
SharedPreferencesWrapperEncryption.setEncryptionKey('my16CharacterKey');

// Once the key is set, whenever a string is stored in shared preferences the encryption is applied
await SharedPreferencesWrapper.addString('key', 'value');

// To remove encryption, simply remove SharedPreferencesWrapperEncryption.setEncryptionKey('my16CharacterKey');
```

NOTE: Encryption can only be applied via the **addString()** and not **setValue()**. To get the decrypted value use **getString()** and not **getValue()**.

### AES Encryption
```dart
// import the encryption library
import 'package:shared_preferences_wrapper/shared_preferences_wrapper_encryption.dart';

// encrypt
String key = 'pin';
String value = '123456';
String secretKey16Char = 'my16CharacterKey';

await SharedPreferencesWrapper.addString(key, value,
  aesEncryption: 
    AESEncryption( // encryption type
        encryptionKey: secretKey16Char, // the encryption key
));

// to get the decrypted value
String? mypin = await SharedPreferencesWrapper.getString(key,
        aesDecryption: // decryption type
            AESDecryption(
              encryptionKey: encryptionKey // the encryption key
));

print(mypin); // output 123456
```

### Salsa20 Encryption
```dart
// import the encryption library
import 'package:shared_preferences_wrapper/shared_preferences_wrapper_encryption.dart';

// encrypt
String key = 'pin';
String value = '123456';
String secretKey16Char = 'my16CharacterKey';

await SharedPreferencesWrapper.addString(key, value,
  salsa20Encryption: 
    Salsa20Encryption( // encryption type
        encryptionKey: secretKey16Char, // the encryption key
));

// to get the decrypted value
String? mypin = await SharedPreferencesWrapper.getString(key,
        salsa20Decryption: // decryption type
            Salsa20Decryption(
              encryptionKey: encryptionKey // the encryption key
));

print(mypin); // output 123456
```

## Grouping Preferences
Organize preferences based on specific groups or categories

```dart
// Add preferences to a specific group
await SharedPreferencesWrapper.addToGroup('UserSettings', 'username', 'JohnDoe');
await SharedPreferencesWrapper.addToGroup('UserSettings', 'email', 'john@example.com');

await SharedPreferencesWrapper.addToGroup('AppSettings', 'darkMode', true);
await SharedPreferencesWrapper.addToGroup('AppSettings', 'language', 'English');

// Retrieve preferences from a specific group
Map<String, dynamic>? userSettings = await SharedPreferencesWrapper.getGroup('UserSettings');
Map<String, dynamic>? appSettings = await SharedPreferencesWrapper.getGroup('AppSettings');
print('userSettings: $userSettings');
print('appSettings: $appSettings');
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
- **addListener(String key, void Function() listener)**: Adds listeners for shared preference changes.
- **removeListener(String key, VoidCallback listener)**: Removes listeners for shared preference changes.
- **addObserver(String key, Function(String, dynamic) callback)**: Add observers for shared preference changes.
- **removeObserver(String key, Function(String, dynamic) callback)**: Remove observers for shared preference changes.
- **addBatch(Map<String, dynamic> data)**: Add multiple key-value pairs in a single batch operation.
- **updateBatch(Map<String, dynamic> data)**: Update multiple key-value pairs in a single batch.
- **addToGroup(String groupName, String key, dynamic value)** Organize preferences based on specific groups or categories.
- **getGroup(String groupName)** Get preferences based on specific groups or categories.
- **setValue(String key, dynamic value)** Sets a value in SharedPreferences.
- **getValue(String key, {dynamic defaultValue})** Retrieves a value from SharedPreferences.
- **getBuilder()** Chains methods together.
- **createNamespace(String namespace)** Create a namespace.
- **clearNamespace()** Clears the namespace.
- **removeWhereKeyStartsWith(String keyPrefix)** Removes preferences where key starts with the given prefix.

## Contributing

If you have ideas or improvements for this package, we welcome contributions. Please open an issue or create a pull request on our [GitHub repository](https://github.com/youngcet/shared_preferences_wrapper).

## License

This package is available under the [MIT License](https://github.com/youngcet/shared_preferences_wrapper/blob/main/LICENSE).