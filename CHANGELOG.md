## 0.0.4
- Namespace Support: Implement namespaces for easier management of different sets of preferences.
- Encryption Options (AES & Salsa20): Enhance encryption features to support different encryption algorithms and improve security.
- A fluent API for chaining multiple operations in a more readable manner.
- Deprecation of setEncryptionKey(), refer to the documentation

## 0.0.3+2
- fixed pub dev analysis issues
- upgraded sdk to >=2.19.5 <3.0.0

## 0.0.3+1
- added setValue() to allow saving data to SharedPreferences
- added getValue() to retrieve values from SharedPreferences

## 0.0.3
- Add or remove observers for shared preference changes.
- Organize preferences based on specific groups or categories
- Get preferences based on specific groups or categories
- Setting default values that should be returned instead of null for **string, int, bool, double** data types

### Added
- Encrypt/Decrypt sensitive data stored in shared preferences
- Add or update multiple key-value pairs in a single batch operation
- Add or remove listeners for shared preference changes

## 0.0.2

### Added
- Encrypt/Decrypt sensitive data stored in shared preferences
- Add or update multiple key-value pairs in a single batch operation
- Add or remove listeners for shared preference changes

## 0.0.1+1

### Added
- Updated Dart SDK from 2.19.5 to 2.19.0

## 0.0.1

### Added
- Initial release: Store and retrieve strings, integers, doubles, booleans, and string lists in shared preferences.