## 1.0.0
### Updated

- **Dart SDK** updated to `3.8.1` to support latest language improvements and toolchain stability.
- **Flutter SDK** updated to `3.32.8`.
- Updated package dependencies in `pubspec.yaml` to latest compatible versions

## 0.0.5
- **Updated setValue method:**
  - Added a new optional parameter expirationDuration of type Duration?.
  - If expirationDuration is provided, the stored value will be cached with an expiration time.
  - This change allows values to be stored with an expiration, automatically removing them after the specified duration.
  - This update supports enhanced caching behavior, where persistent storage can now be time-bound.

- **Added Cache Management:**
  - Introduced a new caching manager that uses SharedPreferencesWrapper for storing data with expiration times.
  - The cache manager supports storing, retrieving, and clearing cached data, with automatic removal of expired data.

    **Key Features:**

    - Store Data with Expiration: Cache data for a specified duration, after which it will be automatically removed.
    - Retrieve Cached Data: Access cached data as long as it hasn't expired.
    - Clear Cached Data: Easily remove specific cached data from shared preferences.

    **New Methods:**

    - **cacheData(String key, dynamic data, Duration expirationDuration):** Caches the given data for a specified duration.
    - **getCachedData(String key):** Retrieves the cached data associated with the given key, or returns null if expired or not found.
    - **clearCache(String key):** Clears the cached data associated with the given key.

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